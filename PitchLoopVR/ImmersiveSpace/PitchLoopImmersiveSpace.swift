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
                
                // Initialize audio system
                await appModel.audioManager.setupAudio()
                
                // Add positioned audience murmuring around the room
                // These create a realistic ambient soundscape of audience chatter
                await setupAudienceAmbience(in: content)
                
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
    
    /// Sets up positioned ambient audience sounds around the conference room
    private func setupAudienceAmbience(in content: RealityViewContent) async {
        // Define positions around the room where audience sounds will emanate
        // Adjust these based on your room layout
        let audiencePositions: [(identifier: String, position: SIMD3<Float>)] = [
            ("audience-left", SIMD3(x: -2.0, y: 1.0, z: -3.0)),      // Left side
            ("audience-right", SIMD3(x: 2.0, y: 1.0, z: -3.0)),      // Right side
            ("audience-center", SIMD3(x: 0.0, y: 1.0, z: -4.0)),     // Center back
            ("audience-front-left", SIMD3(x: -1.5, y: 1.0, z: -2.0)), // Front left
            ("audience-front-right", SIMD3(x: 1.5, y: 1.0, z: -2.0))  // Front right
        ]
        
        // Create positioned audio sources at each location
        for (identifier, position) in audiencePositions {
            if let audioEntity = await appModel.audioManager.createPositionedAmbientAudio(
                resourceName: "crowd-talking-2", // Your audio file name
                extension: "mp3",
                position: position,
                volume: 0.2,                      // Quiet background level
                loops: true,
                identifier: identifier
            ) {
                content.add(audioEntity)
            }
        }
        
        print("Audience ambience setup complete")
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
