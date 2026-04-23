/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
Examples of how to use the AudioManager for spatial audio in PitchLoopVR.
*/

import RealityKit
import SwiftUI

// MARK: - Usage Examples

/*
 
 ## How to Use AudioManager in Your App
 
 The AudioManager is now available through your PitchLoopAppModel and can be accessed
 via the environment in any SwiftUI view.
 
 ### 1. Playing Ambient Background Audio
 
 For room ambience or background music that doesn't need spatial positioning:
 
 ```swift
 await appModel.audioManager.playAmbientAudio(
     resourceName: "conference-ambience",
     extension: "mp3",
     volume: 0.3,
     loops: true
 )
 ```
 
 ### 2. Playing Spatial Audio at a Specific Location
 
 For audio that should come from a specific point in your 3D space:
 
 ```swift
 // In your RealityView:
 RealityView { content in
     // Create an entity at the desired position
     let speakerEntity = Entity()
     speakerEntity.position = SIMD3(x: 0, y: 1.5, z: -2)
     content.add(speakerEntity)
     
     // Play audio from that position
     await appModel.audioManager.playSpatialAudio(
         resourceName: "applause",
         extension: "wav",
         at: speakerEntity
     )
 }
 ```
 
 ### 3. Adding Audio to Existing Entities in Your Scene
 
 If you have entities in your room model (like a virtual speaker or notification point):
 
 ```swift
 RealityView { content in
     let roomEntity = try await Entity(contentsOf: roomURL)
     content.add(roomEntity)
     
     // Find a specific entity in your room model
     if let notificationPoint = roomEntity.findEntity(named: "NotificationPoint") {
         await appModel.audioManager.playSpatialAudio(
             resourceName: "notification-sound",
             extension: "mp3",
             at: notificationPoint
         )
     }
 }
 ```
 
 ### 4. Playing Audio During Different Stages
 
 You can trigger audio based on your app's stage:
 
 ```swift
 // In SpeakingStageView or similar:
 .onAppear {
     Task {
         // Play a "session started" sound
         await appModel.audioManager.playAmbientAudio(
             resourceName: "session-start",
             extension: "mp3",
             volume: 0.5,
             loops: false
         )
     }
 }
 ```
 
 ### 5. Controlling Playback
 
 ```swift
 // Pause
 appModel.audioManager.pauseAudio()
 
 // Resume
 appModel.audioManager.resumeAudio()
 
 // Adjust volume
 appModel.audioManager.setVolume(0.7)
 
 // Stop
 appModel.audioManager.stopAudio()
 ```
 
 ### 6. Example: Feedback Sound Effects
 
 When audience gives feedback, play a spatial sound from their position:
 
 ```swift
 // In your feedback handling code:
 RealityView { content in
     // Create entity at participant's spatial position
     let feedbackEntity = Entity()
     // Position would come from spatial persona template
     feedbackEntity.position = participantPosition
     content.add(feedbackEntity)
     
     await appModel.audioManager.playSpatialAudio(
         resourceName: "feedback-received",
         extension: "wav",
         at: feedbackEntity
     )
 }
 ```
 
 ## Audio File Setup
 
 1. Add your audio files to the Resources folder
 2. Make sure they're included in the target's "Copy Bundle Resources"
 3. Supported formats: MP3, WAV, M4A, AAC
 
 ## Recommended Audio Use Cases for PitchLoopVR
 
 - **Session Start/End**: Play ambient cues when transitioning stages
 - **Feedback Notifications**: Spatial audio from audience member positions
 - **Timer/Countdown**: Audio cues during countdown
 - **Ambient Room Tone**: Subtle background audio for presence
 - **Cue Alerts**: Sound when speaker cues trigger
 - **Achievement Sounds**: Positive reinforcement for milestones
 - **Audience Murmuring**: Positioned ambient sounds to simulate audience presence
 
 ## Implementation Example: Audience Murmuring
 
 The app now includes positioned audience murmuring! See `PitchLoopImmersiveSpace.swift`:
 
 ```swift
 // Multiple audio sources positioned around the room
 let audiencePositions = [
     ("audience-left", SIMD3(x: -2.0, y: 1.0, z: -3.0)),
     ("audience-right", SIMD3(x: 2.0, y: 1.0, z: -3.0)),
     ("audience-center", SIMD3(x: 0.0, y: 1.0, z: -4.0)),
     // ... more positions
 ]
 
 // Each position gets its own looping audio source
 for (identifier, position) in audiencePositions {
     if let audioEntity = await appModel.audioManager.createPositionedAmbientAudio(
         resourceName: "audience-murmur",
         extension: "mp3",
         position: position,
         volume: 0.2,
         loops: true,
         identifier: identifier
     ) {
         content.add(audioEntity)
     }
 }
 ```
 
 This creates a realistic soundscape where audience chatter comes from multiple directions,
 enhancing the immersive presentation practice experience!
 
 */

// MARK: - Example View Integration

struct ExampleAudioIntegrationView: View {
    @Environment(PitchLoopAppModel.self) var appModel
    
    var body: some View {
        RealityView { content in
            // Example: Adding a virtual podium with spatial audio
            let podium = ModelEntity(
                mesh: .generateBox(size: [0.5, 1.0, 0.5]),
                materials: [SimpleMaterial(color: .brown, isMetallic: false)]
            )
            podium.position = [0, 0.5, -2]
            content.add(podium)
            
            // Play audio from the podium location
            await appModel.audioManager.playSpatialAudio(
                resourceName: "welcome-message",
                extension: "mp3",
                at: podium
            )
        }
        .onAppear {
            Task {
                // Setup audio when view appears
                await appModel.audioManager.setupAudio()
            }
        }
        .onDisappear {
            // Stop audio when leaving the view
            appModel.audioManager.stopAudio()
        }
    }
}
