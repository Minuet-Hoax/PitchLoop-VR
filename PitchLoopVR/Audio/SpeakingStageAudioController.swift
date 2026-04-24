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
            player.numberOfLoops = -1
            player.volume = 1.0
            player.play()
            ambientPlayer = player
        } catch {
            print("Failed to start ambient loop: \(error)")
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
