/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Helpers that expose role-specific participant collections.
*/

import Foundation

extension SharePlaySessionController {
    var localRole: ParticipantModel.Role? {
        localPlayer.role
    }

    var localIsReady: Bool {
        localPlayer.isReady
    }
    
    var audienceCount: Int {
        audience.count
    }

    var readyAudienceCount: Int {
        audience.filter(\.isReady).count
    }
    
    var participantCount: Int {
        players.count
    }
    
    var readyParticipantCount: Int {
        players.values.filter(\.isReady).count
    }
    
    var allParticipantsReady: Bool {
        participantCount > 0 && readyParticipantCount == participantCount
    }
    
    var isRoleSelectionCoordinator: Bool {
        guard let coordinator = players.keys.min(by: { $0.id.uuidString < $1.id.uuidString }) else {
            return false
        }
        
        return coordinator == session.localParticipant
    }
    
    var roleSelectionCountdownDeadline: Date? {
        game.roleSelectionCountdownDeadline
    }

    var unassignedParticipants: [ParticipantModel] {
        players.values
            .filter { $0.role == nil }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
