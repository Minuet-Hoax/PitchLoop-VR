/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's main entry point.
*/

import SwiftUI

@main
struct PitchLoopVRApp: App {
    @State var appModel = PitchLoopAppModel()
    
    var body: some Scene {
        Group {
            PitchLoopWindow()
            PitchLoopImmersiveSpace()
        }
        .environment(appModel)
    }
}
