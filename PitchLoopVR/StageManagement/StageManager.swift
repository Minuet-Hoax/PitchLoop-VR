import Foundation
import Observation

@Observable @MainActor
final class StageManager {
    enum Stage: String, Sendable {
        case onboarding
        case speaking
        case reviewing
    }

    let onboarding = OnboardingStageManager()
    let speaking = SpeakingStageManager()
    let reviewing = ReviewingStageManager()

    func stage(for activityStage: SessionState.ActivityStage) -> Stage {
        switch activityStage {
            case .onboarding:
                .onboarding
            case .speaking:
                .speaking
            case .reviewing:
                .reviewing
        }
    }
}
