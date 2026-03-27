/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Helpers that expose role-specific participant collections.
*/

import Foundation

extension SessionController {
    var localRole: PlayerModel.Role? {
        localPlayer.role
    }
    
    var audienceCount: Int {
        audience.count
    }
    
    var unassignedParticipants: [PlayerModel] {
        players.values
            .filter { $0.role == nil }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
