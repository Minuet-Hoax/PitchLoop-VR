/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's main window, which presents the UI for the current stage.
*/

import SwiftUI

struct PitchLoopWindow: Scene {
    var body: some Scene {
        WindowGroup(id: "main") {
            NavigationStack {
                RootView()
            }
            .frame(width: 900, height: 600)
            .participantNameAlert()
        }
        .windowResizability(.contentSize)
    }
}
