/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A session controller extension that synchronizes the app's state with the SharePlay group session.
*/

import Foundation
import GroupActivities

extension SharePlaySessionController {
    func shareLocalPlayerState(_ newValue: ParticipantModel) {
        Task {
            do {
                try await messenger.send(newValue)
            } catch {
                print("The app can't send the player state message due to: \(error)")
            }
        }
    }

    func shareLocalGameState(_ newValue: SessionState) {
        gameSyncStore.editCount += 1
        gameSyncStore.lastModifiedBy = session.localParticipant

        let message = GameMessage(
            game: newValue,
            editCount: gameSyncStore.editCount
        )
        Task {
            do {
                try await messenger.send(message)
            } catch {
                print("The app can't send the game state message due to: \(error)")
            }
        }
    }

    func shareLocalFeedbackMessage(_ newValue: FeedbackMessage) {
        Task {
            do {
                try await messenger.send(newValue)
            } catch {
                print("The app can't send the feedback message due to: \(error)")
            }
        }
    }

    func observeRemoteParticipantUpdates() {
        observeActiveRemoteParticipants()
        observeRemoteGameModelUpdates()
        observeRemotePlayerModelUpdates()
        observeRemoteFeedbackUpdates()
        observeRemoteFeedbackHistoryUpdates()
    }

    private func observeRemoteGameModelUpdates() {
        Task {
            for await (message, context) in messenger.messages(of: GameMessage.self) {
                let senderID = context.source.id

                let editCount = gameSyncStore.editCount
                let gameLastModifiedBy = gameSyncStore.lastModifiedBy ?? session.localParticipant
                let shouldAcceptMessage = if message.editCount > editCount {
                    true
                } else if message.editCount == editCount && senderID > gameLastModifiedBy.id {
                    true
                } else {
                    false
                }

                guard shouldAcceptMessage else {
                    continue
                }

                if message.game != gameSyncStore.game {
                    gameSyncStore.game = message.game
                }
                gameSyncStore.editCount = message.editCount
                gameSyncStore.lastModifiedBy = context.source
            }
        }
    }

    private func observeRemotePlayerModelUpdates() {
        Task {
            for await (player, context) in messenger.messages(of: ParticipantModel.self) {
                players[context.source] = player
            }
        }
    }

    private func observeRemoteFeedbackUpdates() {
        Task {
            for await (feedback, _) in messenger.messages(of: FeedbackMessage.self) {
                appModel.feedbackStore.mergeInboundFeedback(
                    feedback,
                    shouldShowPending: localRole == .speaker
                )
            }
        }
    }

    private func observeRemoteFeedbackHistoryUpdates() {
        Task {
            for await (historyMessage, _) in messenger.messages(of: FeedbackHistoryMessage.self) {
                for feedback in historyMessage.feedbackHistory {
                    appModel.feedbackStore.mergeInboundFeedback(
                        feedback,
                        shouldShowPending: false
                    )
                }
            }
        }
    }

    private func observeActiveRemoteParticipants() {
        let activeRemoteParticipants = session.$activeParticipants.map {
            $0.subtracting([self.session.localParticipant])
        }
        .withPrevious()
        .values

        Task {
            for await (oldActiveParticipants, currentActiveParticipants) in activeRemoteParticipants {
                let oldActiveParticipants = oldActiveParticipants ?? []

                let newParticipants = currentActiveParticipants.subtracting(oldActiveParticipants)
                let removedParticipants = oldActiveParticipants.subtracting(currentActiveParticipants)

                if !newParticipants.isEmpty {
                    do {
                        let gameMessage = GameMessage(
                            game: game,
                            editCount: gameSyncStore.editCount
                        )
                        try await messenger.send(gameMessage, to: .only(newParticipants))
                    } catch {
                        print("Failed to send game catchup message, \(error)")
                    }

                    do {
                        try await messenger.send(localPlayer, to: .only(newParticipants))
                    } catch {
                        print("Failed to send player catchup message, \(error)")
                    }

                    do {
                        let historyMessage = FeedbackHistoryMessage(
                            feedbackHistory: appModel.feedbackStore.feedbackHistory
                        )
                        try await messenger.send(historyMessage, to: .only(newParticipants))
                    } catch {
                        print("Failed to send feedback history catchup message, \(error)")
                    }
                }

                for participant in removedParticipants {
                    players[participant] = nil
                }
            }
        }
    }

    struct GameSyncStore {
        var editCount: Int = 0
        var lastModifiedBy: Participant?
        var game = SessionState()
    }
}

struct GameMessage: Codable, Sendable {
    let game: SessionState
    let editCount: Int
}

struct FeedbackHistoryMessage: Codable, Sendable {
    let feedbackHistory: [FeedbackMessage]
}
