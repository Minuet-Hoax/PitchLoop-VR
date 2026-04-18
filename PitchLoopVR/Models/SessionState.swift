/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A model that represents the shared presentation state
  in the SharePlay group session.
*/

import Foundation

struct SessionState: Codable, Hashable, Sendable {
    var resetToken = UUID()
    var stage: ActivityStage = .onboarding
    var sessionStartCountdownDeadline: Date?
}

extension SessionState {
    enum ActivityStage: Codable, Hashable, Sendable {
        case onboarding
        case speaking
        case reviewing
        
        var isSessionActive: Bool {
            switch self {
                case .onboarding:
                    false
                case .speaking, .reviewing:
                    true
            }
        }
    }
}
