import Foundation
import Observation

@Observable @MainActor
final class SpeakingStageManager {
    func canEnter(from activityStage: SessionState.ActivityStage) -> Bool {
        switch activityStage {
            case .onboarding, .speaking, .reviewing:
                true
        }
    }
}
