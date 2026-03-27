/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The controller manages the app's active SharePlay session.
*/

import GroupActivities
import Observation

@Observable @MainActor
final class SessionController {
    let session: GroupSession<GuessTogetherActivity>
    let messenger: GroupSessionMessenger
    let systemCoordinator: SystemCoordinator
    
    var game: GameModel {
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

    var players = [Participant: PlayerModel]() {
        didSet {
            if oldValue != players {
                updateLocalParticipantRole()
            }
        }
    }
    
    var localPlayer: PlayerModel {
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
    
    init?(_ groupSession: GroupSession<GuessTogetherActivity>, appModel: AppModel) async {
        guard let groupSystemCoordinator = await groupSession.systemCoordinator else {
            return nil
        }

        session = groupSession

        // Create the group session messenger for the session controller, which it uses to keep the game in sync for all participants.
        messenger = GroupSessionMessenger(session: session)

        systemCoordinator = groupSystemCoordinator

        // Create a representation of the local participant.
        localPlayer = PlayerModel(
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
                systemCoordinator.configuration.spatialTemplatePreference = .custom(GameTemplate())
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
                    systemCoordinator.assignRole(GameTemplate.Role.speaker)
                case .audience:
                    systemCoordinator.assignRole(GameTemplate.Role.audience)
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
    
    var speaker: PlayerModel? {
        players.values.first(where: { $0.role == .speaker })
    }
    
    var audience: [PlayerModel] {
        players.values
            .filter { $0.role == .audience }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    var orderedParticipants: [PlayerModel] {
        players.values.sorted { lhs, rhs in
            if lhs.roleOrder != rhs.roleOrder {
                return lhs.roleOrder < rhs.roleOrder
            }
            
            return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
    }
    
    func chooseRole(_ role: PlayerModel.Role) {
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
        game = GameModel()
    }
    
    func gameStateChanged() {
        if game.stage == .roleSelection, localPlayer.role != nil {
            localPlayer.role = nil
        }
        
        updateSpatialTemplatePreference()
        updateLocalParticipantRole()
    }
}

private extension PlayerModel {
    var roleOrder: Int {
        switch role {
            case .speaker: 0
            case .audience: 1
            case .none: 2
        }
    }
}
