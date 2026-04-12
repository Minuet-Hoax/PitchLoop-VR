import Foundation
import Observation

@Observable @MainActor
final class ReviewingStageManager {
    func canEnter(from activityStage: SessionState.ActivityStage) -> Bool {
        switch activityStage {
            case .onboarding, .speaking, .reviewing:
                true
        }
    }
}
