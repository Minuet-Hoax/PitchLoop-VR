import SwiftUI

struct OnboardingStageView: View {
    @Environment(PitchLoopAppModel.self) private var appModel

    var body: some View {
        Group {
            if let deadline = appModel.sessionController?.roleSelectionCountdownDeadline {
                SessionStartCountdownView(deadline: deadline)
            } else {
                switch appModel.stageManager.onboarding.currentStep {
                    case .roleSelection:
                        RoleSelectionView()
                    case .speakerFeedback:
                        SpeakerFeedbackView()
                    case .speakerCueInstruction:
                        SpeakerCueInstructionView()
                    case .speakerReady:
                        SpeakerReadyView()
                    case .audienceReady:
                        AudienceReadyView()
                }
            }
        }
        .pitchLoopToolbar()
    }
}

#Preview {
    OnboardingStageView()
        .environment(PitchLoopAppModel())
}
