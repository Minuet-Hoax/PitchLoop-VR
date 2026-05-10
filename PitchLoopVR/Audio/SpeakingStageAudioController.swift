import AVFoundation
import Foundation

@MainActor
final class SpeakingStageAudioController {
    private struct InterruptionSound {
        let name: String
        let volume: Float
        let rate: Float
    }

    private let ambientSoundName = "crowd-talking-2"
    private let interruptionSounds: [InterruptionSound] = [
        .init(name: "DistantCough", volume: 0.35, rate: 0.82),
        .init(name: "Message", volume: 0.40, rate: 0.88),
        .init(name: "Sneeze", volume: 0.30, rate: 0.78),
        .init(name: "VibrationRing", volume: 0.38, rate: 0.85),
        .init(name: "Camera", volume: 0.32, rate: 0.80)
    ]

    private var ambientPlayer: AVAudioPlayer?
    private var effectPlayers: [AVAudioPlayer] = []
    private var interruptionWorkItem: DispatchWorkItem?
    private var crowdLifecycleTask: Task<Void, Never>?
    private var isRunning = false

    func start() {
        guard !isRunning else {
            return
        }

        isRunning = true
        configureAudioSessionIfNeeded()
        startAmbientLoop()
        scheduleNextInterruption()
    }

    func stop() {
        guard isRunning else {
            return
        }

        isRunning = false
        interruptionWorkItem?.cancel()
        interruptionWorkItem = nil
        crowdLifecycleTask?.cancel()
        crowdLifecycleTask = nil

        ambientPlayer?.stop()
        ambientPlayer = nil

        effectPlayers.forEach { $0.stop() }
        effectPlayers.removeAll()
    }

    private func startAmbientLoop() {
        guard let url = resourceURL(named: ambientSoundName) else {
            print("Missing ambient sound: \(ambientSoundName)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0
            player.volume = 0.3
            player.play()
            ambientPlayer = player
            beginCrowdLifecycle()
        } catch {
            print("Failed to start ambient loop: \(error)")
        }
    }

    private func beginCrowdLifecycle() {
        crowdLifecycleTask?.cancel()
        crowdLifecycleTask = Task { @MainActor [weak self] in
            guard let self else {
                return
            }

            // Keep full crowd ambience for the first 5 seconds.
            do {
                try await Task.sleep(for: .seconds(5))
            } catch {
                return
            }

            guard self.isRunning, let player = self.ambientPlayer else {
                return
            }

            // Fade out over the next 5 seconds.
            let fadeDuration: Double = 5
            let fadeSteps = 50
            let fadeInterval = fadeDuration / Double(fadeSteps)
            let initialVolume = player.volume

            for step in 1...fadeSteps {
                guard self.isRunning else {
                    return
                }

                do {
                    try await Task.sleep(for: .seconds(fadeInterval))
                } catch {
                    return
                }

                let progress = Float(step) / Float(fadeSteps)
                player.volume = max(0, initialVolume * (1 - progress))
            }

            player.stop()
            self.ambientPlayer = nil
            self.crowdLifecycleTask = nil
        }
    }

    private func scheduleNextInterruption() {
        guard isRunning else {
            return
        }

        let delay = Double.random(in: 5...30)
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else {
                return
            }

            Task { @MainActor in
                guard self.isRunning else {
                    return
                }

                self.playRandomInterruption()
                self.scheduleNextInterruption()
            }
        }

        interruptionWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    private func playRandomInterruption() {
        guard let sound = interruptionSounds.randomElement() else {
            return
        }

        guard let url = resourceURL(named: sound.name) else {
            print("Missing interruption sound: \(sound.name)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.enableRate = true
            player.rate = sound.rate
            player.volume = sound.volume
            player.play()

            effectPlayers.removeAll { !$0.isPlaying }
            effectPlayers.append(player)
        } catch {
            print("Failed to play interruption \(sound.name): \(error)")
        }
    }

    private func resourceURL(named name: String) -> URL? {
        let supportedExtensions = ["mp3", "wav", "m4a", "aif", "aiff"]
        for ext in supportedExtensions {
            if let url = Bundle.main.url(forResource: name, withExtension: ext) {
                return url
            }
        }

        return nil
    }

    private func configureAudioSessionIfNeeded() {
        #if os(iOS) || os(tvOS) || os(visionOS)
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("Failed to configure AVAudioSession: \(error)")
        }
        #endif
    }
}
