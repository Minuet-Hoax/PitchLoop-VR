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
    
    var audienceCount: Int {
        audience.count
    }
    
    var unassignedParticipants: [ParticipantModel] {
        players.values
            .filter { $0.role == nil }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
