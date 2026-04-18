import Foundation
import Observation

enum AppScreen {
    case roleSelection
    case speakerFeedback
    case speakerCueInstruction
    case speakerStartSession
    case audienceOnboarding
    case audienceReady
}

@Observable @MainActor
final class OnboardingStageManager {
    var currentScreen: AppScreen = .roleSelection

    func reset() {
        currentScreen = .roleSelection
    }

    func canEnter(from activityStage: SessionState.ActivityStage) -> Bool {
        switch activityStage {
            case .onboarding, .speaking, .reviewing:
                true
        }
    }

    func beginSpeakerOnboarding(using sessionController: SharePlaySessionController) {
        sessionController.chooseRole(.speaker)
        currentScreen = .speakerFeedback
    }

    func beginAudienceOnboarding(using sessionController: SharePlaySessionController) {
        sessionController.chooseRole(.audience)
        currentScreen = .audienceOnboarding
    }

    func completeAudienceFeedbackTutorial() {
        currentScreen = .audienceReady
    }

    func advanceSpeakerFeedback() {
        currentScreen = .speakerCueInstruction
    }

    func advanceSpeakerCueInstruction() {
        currentScreen = .speakerStartSession
    }

    func cancelOnboarding(using sessionController: SharePlaySessionController?) {
        sessionController?.clearRoleSelection()
        reset()
    }

    func markAudienceReady(using sessionController: SharePlaySessionController) {
        sessionController.markLocalParticipantReady()
    }

    func canStartSession(using sessionController: SharePlaySessionController) -> Bool {
        guard sessionController.localRole == .speaker else {
            return false
        }

        guard sessionController.unassignedParticipants.isEmpty else {
            return false
        }

        guard (1...3).contains(sessionController.audienceCount) else {
            return false
        }

        return sessionController.readyAudienceCount == sessionController.audienceCount
    }

    func startSession(using sessionController: SharePlaySessionController) {
        guard canStartSession(using: sessionController) else {
            return
        }

        sessionController.startSession()
    }
}
