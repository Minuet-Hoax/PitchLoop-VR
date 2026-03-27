/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An immersive space the game presents during the in-game stages.
*/

import SwiftUI

struct PitchLoopImmersiveSpace: Scene {
    @Environment(PitchLoopAppModel.self) var appModel
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    static let spaceID = "GameSpace"
    
    var body: some Scene {
        ImmersiveSpace(id: Self.spaceID) {
            ZStack {
                PresentationBoardPodiumView()
                ParticipantRoleLabelsView()
            }
            .onAppear {
                appModel.isImmersiveSpaceOpen = true
            }
            .onDisappear {
                appModel.isImmersiveSpaceOpen = false
            }
        }
        .onChange(of: appModel.sessionController?.game.stage, updateImmersiveSpaceState)
    }
    
    /// Opens or dismisses the app's immersive space based on the game's current and previous states.
    ///
    /// - Parameters:
    ///     - oldActivityStage: The app's previous activity stage.
    ///     - newActivityStage: The app's current stage.
    func updateImmersiveSpaceState(
        oldActivityStage: SessionState.ActivityStage?,
        newActivityStage: SessionState.ActivityStage?
    ) {
        let wasSessionActive = oldActivityStage?.isSessionActive ?? false
        let isSessionActive = newActivityStage?.isSessionActive ?? false
        
        guard wasSessionActive != isSessionActive else {
            return
        }
        
        Task {
            if isSessionActive && !appModel.isImmersiveSpaceOpen {
                await openImmersiveSpace(id: Self.spaceID)
            } else if appModel.isImmersiveSpaceOpen {
                await dismissImmersiveSpace()
            }
        }
    }
}
