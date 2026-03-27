/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The controller manages the app's active SharePlay session.
*/

import GroupActivities
import Observation

@Observable @MainActor
final class SharePlaySessionController {
    let session: GroupSession<PitchLoopActivity>
    let messenger: GroupSessionMessenger
    let systemCoordinator: SystemCoordinator
    
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

        // Create the group session messenger for the session controller, which it uses to keep the game in sync for all participants.
        messenger = GroupSessionMessenger(session: session)

        systemCoordinator = groupSystemCoordinator

        // Create a representation of the local participant.
        localPlayer = ParticipantModel(
            id: session.localParticipant.id,
            name: appModel.playerName
        )
        appModel.showPlayerNameAlert = localPlayer.name.isEmpty
        
        observeRemoteParticipantUpdates()
        configureSystemCoordinator()
        
        session.join()
    }
    
    func updateSpatialTemplatePreference() {
        switch game.stage {
            case .roleSelection:
                systemCoordinator.configuration.spatialTemplatePreference = .sideBySide
            case .session:
                systemCoordinator.configuration.spatialTemplatePreference = .custom(PresentationTemplate())
        }
    }
    
    func updateLocalParticipantRole() {
        switch game.stage {
            case .roleSelection:
                systemCoordinator.resignRole()
            case .session:
                switch localPlayer.role {
                case .none:
                    systemCoordinator.resignRole()
                case .speaker:
                    systemCoordinator.assignRole(PresentationTemplate.Role.speaker)
                case .audience:
                    systemCoordinator.assignRole(PresentationTemplate.Role.audience)
                }
        }
    }
    
    func configureSystemCoordinator() {
        // Let the system coordinator show each players' spatial Persona in the immersive space.
        systemCoordinator.configuration.supportsGroupImmersiveSpace = true
        
        Task {
            // Wait for gameplay updates from participants.
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
    
    var speaker: ParticipantModel? {
        players.values.first(where: { $0.role == .speaker })
    }
    
    var audience: [ParticipantModel] {
        players.values
            .filter { $0.role == .audience }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    var orderedParticipants: [ParticipantModel] {
        players.values.sorted { lhs, rhs in
            if lhs.roleOrder != rhs.roleOrder {
                return lhs.roleOrder < rhs.roleOrder
            }
            
            return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
    }
    
    func chooseRole(_ role: ParticipantModel.Role) {
        guard role != .speaker || canBecomeSpeaker else {
            return
        }
        
        localPlayer.role = role
        game.stage = .session
    }
    
    func leaveRoleSelection() {
        localPlayer.role = nil
        if players.values.allSatisfy({ $0.role == nil || $0.id == localPlayer.id }) {
            game.stage = .roleSelection
        }
    }
    
    func resetSession() {
        game = SessionState()
    }
    
    func gameStateChanged() {
        if game.stage == .roleSelection, localPlayer.role != nil {
            localPlayer.role = nil
        }
        
        updateSpatialTemplatePreference()
        updateLocalParticipantRole()
    }
}

private extension ParticipantModel {
    var roleOrder: Int {
        switch role {
            case .speaker: 0
            case .audience: 1
            case .none: 2
        }
    }
}
