/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The implementation for an observable model that maintains the app's state.
*/

import Foundation
import SwiftUI
import Observation

@Observable @MainActor
final class PitchLoopAppModel {
    var sessionController: SharePlaySessionController?
    let stageManager = StageManager()
    let feedbackStore = FeedbackStore()
    
    var playerName: String = UserDefaults.standard.string(forKey: "player-name") ?? "" {
        didSet {
            UserDefaults.standard.set(playerName, forKey: "player-name")
            sessionController?.localPlayer.name = playerName
        }
    }
    
    var showPlayerNameAlert = false
    
    var isImmersiveSpaceOpen = false
}
