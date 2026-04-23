/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
Manager for spatial audio playback in the immersive environment.
*/

import AVFoundation
import RealityKit
import Observation

@Observable @MainActor
final class AudioManager {
    private var audioPlaybackController: AudioPlaybackController?
    private var ambientAudioControllers: [String: AudioPlaybackController] = [:]
    
    /// Prepares the audio system for spatial playback
    func setupAudio() async {
        do {
            // Configure the audio session for spatial audio
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
            
            print("Audio session configured for spatial playback")
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    /// Plays a spatial audio file at the specified entity
    /// - Parameters:
    ///   - resourceName: The name of the audio file (without extension)
    ///   - extension: The file extension (e.g., "mp3", "wav")
    ///   - entity: The RealityKit entity to attach the audio to
    func playSpatialAudio(resourceName: String, extension: String, at entity: Entity) async {
        guard let audioURL = Bundle.main.url(forResource: resourceName, withExtension: `extension`) else {
            print("Failed to find audio file: \(resourceName).\(`extension`)")
            return
        }
        
        do {
            // Load the audio resource
            let audioResource = try await AudioFileResource(contentsOf: audioURL)
            
            // Create an audio playback controller
            let controller = entity.prepareAudio(audioResource)
            
            // Play the audio
            controller.play()
            
            self.audioPlaybackController = controller
            
            print("Playing spatial audio: \(resourceName).\(`extension`)")
        } catch {
            print("Failed to play spatial audio: \(error)")
        }
    }
    
    /// Plays ambient (non-spatial) background audio
    /// - Parameters:
    ///   - resourceName: The name of the audio file (without extension)
    ///   - extension: The file extension
    ///   - volume: Volume level (0.0 to 1.0)
    ///   - loops: Whether the audio should loop
    func playAmbientAudio(resourceName: String, extension: String, volume: Float = 1.0, loops: Bool = false) async {
        guard let audioURL = Bundle.main.url(forResource: resourceName, withExtension: `extension`) else {
            print("Failed to find audio file: \(resourceName).\(`extension`)")
            return
        }
        
        do {
            // Load the audio resource with ambient settings
            let audioResource = try await AudioFileResource(
                contentsOf: audioURL,
                configuration: AudioFileResource.Configuration(
                    shouldLoop: loops
                )
            )
            
            // For ambient audio, you can create an entity at the user's position
            // or use a fixed position in the scene
            let ambientEntity = Entity()
            
            let controller = ambientEntity.prepareAudio(audioResource)
            controller.gain = Double(20 * log10(volume))
            controller.play()
            
            self.audioPlaybackController = controller
            
            print("Playing ambient audio: \(resourceName).\(`extension`)")
        } catch {
            print("Failed to play ambient audio: \(error)")
        }
    }
    
    /// Stops the currently playing audio
    func stopAudio() {
        audioPlaybackController?.stop()
        audioPlaybackController = nil
        print("Audio playback stopped")
    }
    
    /// Pauses the currently playing audio
    func pauseAudio() {
        audioPlaybackController?.pause()
        print("Audio playback paused")
    }
    
    /// Resumes paused audio
    func resumeAudio() {
        audioPlaybackController?.play()
        print("Audio playback resumed")
    }
    
    /// Adjusts the volume of the currently playing audio
    /// - Parameter volume: Volume level (0.0 to 1.0)
    func setVolume(_ volume: Float) {
        audioPlaybackController?.gain = Double(20 * log10(volume))
    }
    
    /// Creates a positioned ambient audio source (e.g., for background audience murmuring)
    /// - Parameters:
    ///   - resourceName: The name of the audio file (without extension)
    ///   - extension: The file extension
    ///   - position: 3D position in world space
    ///   - volume: Volume level (0.0 to 1.0)
    ///   - loops: Whether the audio should loop
    ///   - identifier: Unique identifier for this audio source
    /// - Returns: The entity containing the audio source
    func createPositionedAmbientAudio(
        resourceName: String,
        extension: String,
        position: SIMD3<Float>,
        volume: Float = 0.3,
        loops: Bool = true,
        identifier: String
    ) async -> Entity? {
        guard let audioURL = Bundle.main.url(forResource: resourceName, withExtension: `extension`) else {
            print("Failed to find audio file: \(resourceName).\(`extension`)")
            return nil
        }
        
        do {
            // Load the audio resource with looping configuration
            let audioResource = try await AudioFileResource(
                contentsOf: audioURL,
                configuration: AudioFileResource.Configuration(
                    shouldLoop: loops
                )
            )
            
            // Create an entity at the specified position
            let audioEntity = Entity()
            audioEntity.position = position
            
            // Prepare and play the audio
            let controller = audioEntity.prepareAudio(audioResource)
            controller.gain = Double(20 * log10(volume))
            controller.play()
            
            // Store the controller for later control
            ambientAudioControllers[identifier] = controller
            
            print("Created positioned ambient audio '\(identifier)' at \(position)")
            return audioEntity
        } catch {
            print("Failed to create positioned ambient audio: \(error)")
            return nil
        }
    }
    
    /// Stops a specific ambient audio source by identifier
    func stopAmbientAudio(identifier: String) {
        ambientAudioControllers[identifier]?.stop()
        ambientAudioControllers.removeValue(forKey: identifier)
        print("Stopped ambient audio: \(identifier)")
    }
    
    /// Stops all ambient audio sources
    func stopAllAmbientAudio() {
        for (identifier, controller) in ambientAudioControllers {
            controller.stop()
            print("Stopped ambient audio: \(identifier)")
        }
        ambientAudioControllers.removeAll()
    }
    
    /// Adjusts volume of a specific ambient audio source
    func setAmbientVolume(_ volume: Float, for identifier: String) {
        ambientAudioControllers[identifier]?.gain = Double(20 * log10(volume))
    }
}
