/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A model that represents each player's state in the SharePlay group session.
*/

import Spatial
import SwiftUI

struct ParticipantModel: Codable, Hashable, Sendable, Identifiable {
    let id: UUID
    var name: String
    var role: Role? = nil
    var isReady = false
    var seatPose: Pose3D?
    
    enum Role: String, Codable, Hashable, Sendable {
        case speaker
        case audience
    }
}

extension ParticipantModel.Role {
    var name: String {
        switch self {
            case .speaker: "Speaker"
            case .audience: "Audience"
        }
    }
    
    var color: Color {
        switch self {
            case .speaker: .orange
            case .audience: .cyan
        }
    }
    
    var symbolName: String {
        switch self {
            case .speaker: "mic.fill"
            case .audience: "person.3.fill"
        }
    }
}
