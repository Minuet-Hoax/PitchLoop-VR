/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An immersive space placeholder for future speaking and reviewing stages.
*/

import GroupActivities
import RealityKit
import SwiftUI

struct PitchLoopImmersiveSpace: SwiftUI.Scene {
    @Environment(PitchLoopAppModel.self) var appModel
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @State private var immersionStyle: ImmersionStyle = .full
    
    static let spaceID = "GameSpace"
    private static let sharedEnvironmentAssociationID = "shared-conference-room"
    
    var body: some SwiftUI.Scene {
        ImmersiveSpace(id: Self.spaceID) {
            immersiveRoomContent
            .onAppear {
                appModel.isImmersiveSpaceOpen = true
            }
            .onDisappear {
                appModel.isImmersiveSpaceOpen = false
            }
        }
        .immersionStyle(selection: $immersionStyle, in: .full)
        .onChange(
            of: appModel.sessionController?.game.stage,
            initial: true,
            updateImmersiveSpaceState
        )
    }

    @ViewBuilder
    private var immersiveRoomContent: some View {
        let roomContent = RealityView { content in
            do {
                let roomURL = Bundle.main.url(forResource: "pitchroomvr", withExtension: "usdz")
                    ?? Bundle.main.url(forResource: "pitchroomvr", withExtension: "usdc")

                guard let roomURL else {
                    print("Failed to find pitchroomvr.usdz or pitchroomvr.usdc in app bundle.")
                    return
                }

                print("Loading immersive room model from \(roomURL.lastPathComponent)")
                let roomEntity = try await Entity(contentsOf: roomURL)
                content.add(roomEntity)
            } catch {
                print("Failed to load immersive room model: \(error)")
            }
        }

        if #available(visionOS 26.0, *) {
            roomContent.groupActivityAssociation(.primary(Self.sharedEnvironmentAssociationID))
        } else {
            roomContent
        }
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
        let wasSessionAvailable = oldActivityStage != nil
        let isSessionAvailable = newActivityStage != nil
        
        guard wasSessionAvailable != isSessionAvailable else {
            return
        }
        
        Task { @MainActor in
            if isSessionAvailable && !appModel.isImmersiveSpaceOpen {
                let result = await openImmersiveSpace(id: Self.spaceID)
                switch result {
                    case .opened:
                        break
                    case .userCancelled:
                        print("Immersive space opening was cancelled by the user.")
                    case .error:
                        print("Immersive space failed to open.")
                    @unknown default:
                        print("Immersive space returned an unknown open result.")
                }
            } else if appModel.isImmersiveSpaceOpen {
                await dismissImmersiveSpace()
            }
        }
    }
}
