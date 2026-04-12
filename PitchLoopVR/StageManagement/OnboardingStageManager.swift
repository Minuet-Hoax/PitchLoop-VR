import Foundation
import Observation

@Observable @MainActor
final class OnboardingStageManager {
    enum Step: Hashable {
        case roleSelection
        case speakerFeedback
        case speakerCueInstruction
        case speakerReady
        case audienceReady
    }

    var currentStep: Step = .roleSelection

    func reset() {
        currentStep = .roleSelection
    }

    func canEnter(from activityStage: SessionState.ActivityStage) -> Bool {
        switch activityStage {
            case .onboarding, .speaking, .reviewing:
                true
        }
    }

    func beginSpeakerOnboarding(using sessionController: SharePlaySessionController) {
        sessionController.chooseRole(.speaker)
        currentStep = .speakerFeedback
    }

    func beginAudienceOnboarding(using sessionController: SharePlaySessionController) {
        sessionController.chooseRole(.audience)
        currentStep = .audienceReady
    }

    func advanceSpeakerFeedback() {
        currentStep = .speakerCueInstruction
    }

    func advanceSpeakerCueInstruction() {
        currentStep = .speakerReady
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
