/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's main window, which presents the UI for the current stage.
*/

import SwiftUI

struct PitchLoopWindow: Scene {
    @Environment(PitchLoopAppModel.self) var appModel
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
            }
            .frame(width: 900, height: 600)
            .participantNameAlert()
        }
        .windowResizability(.contentSize)
    }
}
