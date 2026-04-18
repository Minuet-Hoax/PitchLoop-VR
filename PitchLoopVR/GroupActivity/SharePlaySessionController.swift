/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The controller manages the app's active SharePlay session.
*/

import GroupActivities
import Foundation
import Observation

@Observable @MainActor
final class SharePlaySessionController {
    let session: GroupSession<PitchLoopActivity>
    let messenger: GroupSessionMessenger
    let systemCoordinator: SystemCoordinator

    private var handledResetToken: UUID?
    private var observedCountdownDeadline: Date?
    private var roleSelectionCountdownTask: Task<Void, Never>?
    
    var game: SessionState {
        get {
            gameSyncStore.game
        }
        set {
            if newValue != gameSyncStore.game {
                gameSyncStore.game = newValue
                shareLocalGameState(newValue)
            }
        }
    }
    
    var gameSyncStore = GameSyncStore() {
        didSet {
            gameStateChanged()
        }
    }

    var players = [Participant: ParticipantModel]() {
        didSet {
            if oldValue != players {
                updateLocalParticipantRole()
                reconcileOnboardingState()
            }
        }
    }
    
    var localPlayer: ParticipantModel {
        get {
            players[session.localParticipant]!
        }
        set {
            if newValue != players[session.localParticipant] {
                players[session.localParticipant] = newValue
                shareLocalPlayerState(newValue)
            }
        }
    }
    
    init?(_ groupSession: GroupSession<PitchLoopActivity>, appModel: PitchLoopAppModel) async {
        guard let groupSystemCoordinator = await groupSession.systemCoordinator else {
            return nil
        }

        session = groupSession

        // Create the group session messenger for session-state synchronization.
        messenger = GroupSessionMessenger(session: session)

        systemCoordinator = groupSystemCoordinator

        // Create a representation of the local participant.
        localPlayer = ParticipantModel(
            id: session.localParticipant.id,
            name: appModel.playerName
        )
        appModel.showPlayerNameAlert = localPlayer.name.isEmpty
        handledResetToken = game.resetToken
        
        observeRemoteParticipantUpdates()
        configureSystemCoordinator()
        
        session.join()
    }
    
    func updateSpatialTemplatePreference() {
        switch game.stage {
            case .onboarding:
                systemCoordinator.configuration.spatialTemplatePreference = .custom(RoleSelectionTemplate())
            case .speaking, .reviewing:
                systemCoordinator.configuration.spatialTemplatePreference = .custom(SessionTemplate())
        }
    }
    
    func updateLocalParticipantRole() {
        switch game.stage {
            case .onboarding:
                switch localPlayer.role {
                case .none:
                    systemCoordinator.resignRole()
                case .speaker:
                    systemCoordinator.assignRole(RoleSelectionTemplate.Role.speaker)
                case .audience:
                    systemCoordinator.assignRole(RoleSelectionTemplate.Role.audience)
                }
            case .speaking, .reviewing:
                switch localPlayer.role {
                case .none:
                    systemCoordinator.resignRole()
                case .speaker:
                    systemCoordinator.assignRole(SessionTemplate.Role.speaker)
                case .audience:
                    systemCoordinator.assignRole(SessionTemplate.Role.audience)
                }
        }
    }
    
    func configureSystemCoordinator() {
        // Let the system coordinator show each players' spatial Persona in the immersive space.
        systemCoordinator.configuration.supportsGroupImmersiveSpace = true
        
        Task {
            // Track seat updates from the system coordinator.
            for await localParticipantState in systemCoordinator.localParticipantStates {
                localPlayer.seatPose = localParticipantState.seat?.pose
            }
        }
    }

    var canBecomeSpeaker: Bool {
        guard let speakerParticipant else {
            return true
        }
        
        return speakerParticipant == session.localParticipant
    }
    
    var speakerParticipant: Participant? {
        players.first(where: { $0.value.role == .speaker })?.key
    }
    
    var audience: [ParticipantModel] {
        players.values
            .filter { $0.role == .audience }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    func chooseRole(_ role: ParticipantModel.Role) {
        guard game.stage == .onboarding else {
            return
        }
        
        guard !localPlayer.isReady else {
            return
        }
        
        guard role != .speaker || canBecomeSpeaker else {
            return
        }

        localPlayer.role = role
        localPlayer.isReady = false
        reconcileOnboardingState()
    }

    func clearRoleSelection() {
        guard game.stage == .onboarding else {
            return
        }

        localPlayer.role = nil
        localPlayer.isReady = false
        reconcileOnboardingState()
    }

    func markLocalParticipantReady() {
        guard game.stage == .onboarding else {
            return
        }

        guard localPlayer.role != nil else {
            return
        }

        localPlayer.isReady = true
        reconcileOnboardingState()
    }

    func startSession() {
        guard game.stage == .onboarding else {
            return
        }

        guard localPlayer.role == .speaker else {
            return
        }

        guard unassignedParticipants.isEmpty else {
            return
        }

        guard (1...3).contains(audienceCount) else {
            return
        }

        guard readyAudienceCount == audienceCount else {
            return
        }

        localPlayer.isReady = true

        var updatedGame = game
        updatedGame.sessionStartCountdownDeadline = Date().addingTimeInterval(3)
        game = updatedGame
    }
    
    func resetSession() {
        roleSelectionCountdownTask?.cancel()
        roleSelectionCountdownTask = nil
        observedCountdownDeadline = nil
        game = SessionState()
    }
    
    func gameStateChanged() {
        if handledResetToken != game.resetToken {
            handledResetToken = game.resetToken
            applyResetState()
        }
        
        updateSpatialTemplatePreference()
        updateLocalParticipantRole()
        synchronizeCountdownTask()
        reconcileOnboardingState()
    }
    
    private func applyResetState() {
        if localPlayer.role != nil || localPlayer.isReady {
            localPlayer.role = nil
            localPlayer.isReady = false
        }
    }
    
    private func reconcileOnboardingState() {
        guard game.stage == .onboarding else {
            return
        }
        
        if !allParticipantsReady {
            if game.sessionStartCountdownDeadline != nil {
                var updatedGame = game
                updatedGame.sessionStartCountdownDeadline = nil
                game = updatedGame
            }
            return
        }
    }
    
    private func synchronizeCountdownTask() {
        let deadline = game.stage == .onboarding ? game.sessionStartCountdownDeadline : nil
        
        guard let deadline else {
            observedCountdownDeadline = nil
            roleSelectionCountdownTask?.cancel()
            roleSelectionCountdownTask = nil
            return
        }
        
        guard observedCountdownDeadline != deadline else {
            return
        }
        
        observedCountdownDeadline = deadline
        roleSelectionCountdownTask?.cancel()
        roleSelectionCountdownTask = Task { [weak self] in
            guard let self else {
                return
            }
            
            let nanoseconds = max(deadline.timeIntervalSinceNow, 0) * 1_000_000_000
            
            do {
                try await Task.sleep(nanoseconds: UInt64(nanoseconds))
            } catch {
                return
            }
            
            guard !Task.isCancelled else {
                return
            }
            
            if self.game.stage == .onboarding,
               self.game.sessionStartCountdownDeadline == deadline,
               self.allParticipantsReady {
                var updatedGame = self.game
                updatedGame.sessionStartCountdownDeadline = nil
                updatedGame.stage = .speaking
                self.game = updatedGame
            }
        }
    }
}
