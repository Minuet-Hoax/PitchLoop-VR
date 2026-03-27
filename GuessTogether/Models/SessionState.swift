/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A model that represents the shared presentation state
  in the SharePlay group session.
*/

import Foundation

struct GameModel: Codable, Hashable, Sendable {
    var stage: ActivityStage = .roleSelection
    var pitchTitle = ""
    var coreQuestion = ""
    var guidingPrinciple = ""
    var supportingWork = ""
    var takeaway = ""
}

extension GameModel {
    enum ActivityStage: Codable, Hashable, Sendable {
        case roleSelection
        case session
        
        var isSessionActive: Bool {
            self == .session
        }
    }
}
