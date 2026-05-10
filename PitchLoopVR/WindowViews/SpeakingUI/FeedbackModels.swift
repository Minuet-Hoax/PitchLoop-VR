import Foundation
import Observation
import SwiftUI

struct FeedbackOption: Identifiable, Hashable, Sendable {
    let label: String
    let notificationText: String

    var id: String { label }
}

enum FeedbackType: String, CaseIterable, Identifiable, Codable, Sendable {
    case pace = "Pace"
    case eyeContact = "Eye contact"
    case volume = "Volume"
    case timeStructure = "Time & Structure"

    var id: String { rawValue }

    var sfSymbol: String {
        switch self {
            case .pace: return "person.wave.2"
            case .eyeContact: return "eye"
            case .volume: return "speaker.wave.2"
            case .timeStructure: return "clock"
        }
    }

    var sheetQuestion: String {
        switch self {
            case .pace: return "How is the speaker's pacing?"
            case .eyeContact: return "How is the speaker's eye contact?"
            case .volume: return "How is the speaker's volume?"
            case .timeStructure: return "How is the speaker's presentation?"
        }
    }

    var options: [FeedbackOption] {
        switch self {
            case .pace:
                return [
                    FeedbackOption(label: "Too fast", notificationText: "Pace is too fast"),
                    FeedbackOption(label: "Too slow", notificationText: "Pace is too slow"),
                    FeedbackOption(label: "Felt just right", notificationText: "Pacing feels good")
                ]
            case .eyeContact:
                return [
                    FeedbackOption(label: "Too scattered", notificationText: "Eye contact too scattered"),
                    FeedbackOption(label: "Too fixed", notificationText: "Vary your eye contact"),
                    FeedbackOption(label: "Felt just right", notificationText: "Eye contact feels good")
                ]
            case .volume:
                return [
                    FeedbackOption(label: "Too loud", notificationText: "Lower your volume"),
                    FeedbackOption(label: "Too quiet", notificationText: "Speak up a little"),
                    FeedbackOption(label: "Felt just right", notificationText: "Volume feels good")
                ]
            case .timeStructure:
                return [
                    FeedbackOption(label: "Too long", notificationText: "Consider wrapping up"),
                    FeedbackOption(label: "Hard to follow", notificationText: "Structure is hard to follow"),
                    FeedbackOption(label: "Felt just right", notificationText: "Structure feels good")
                ]
        }
    }

    var color: Color {
        switch self {
            case .pace: return .orange
            case .eyeContact: return .cyan
            case .volume: return .purple
            case .timeStructure: return .blue
        }
    }

    var emoji: String {
        switch self {
            case .pace: return "🗣️"
            case .eyeContact: return "👁️"
            case .volume: return "🔊"
            case .timeStructure: return "🕑"
        }
    }
}

struct FeedbackMessage: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let type: FeedbackType
    let notificationText: String
    let sentAt: Date
    let senderID: UUID
    let senderName: String

    init(
        id: UUID = UUID(),
        type: FeedbackType,
        option: FeedbackOption,
        sentAt: Date = .now,
        senderID: UUID,
        senderName: String
    ) {
        self.id = id
        self.type = type
        self.notificationText = option.notificationText
        self.sentAt = sentAt
        self.senderID = senderID
        self.senderName = senderName
    }
}

@Observable @MainActor
final class FeedbackStore {
    var pendingFeedback: [FeedbackMessage] = []
    var feedbackHistory: [FeedbackMessage] = []

    @discardableResult
    func storeLocalFeedback(
        type: FeedbackType,
        option: FeedbackOption,
        senderID: UUID,
        senderName: String,
        shouldShowPending: Bool
    ) -> FeedbackMessage {
        let message = FeedbackMessage(
            type: type,
            option: option,
            senderID: senderID,
            senderName: senderName
        )
        mergeInboundFeedback(message, shouldShowPending: shouldShowPending)
        return message
    }

    func mergeInboundFeedback(_ message: FeedbackMessage, shouldShowPending: Bool) {
        if !feedbackHistory.contains(where: { $0.id == message.id }) {
            feedbackHistory.append(message)
        }

        guard shouldShowPending else {
            return
        }

        if !pendingFeedback.contains(where: { $0.id == message.id }) {
            pendingFeedback.append(message)
        }
    }

    func dismiss(message: FeedbackMessage) {
        pendingFeedback.removeAll { $0.id == message.id }
    }

    func clearPending() {
        pendingFeedback.removeAll()
    }

    func resetAll() {
        pendingFeedback.removeAll()
        feedbackHistory.removeAll()
    }
}
