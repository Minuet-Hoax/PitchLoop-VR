import Foundation
import Observation
import CoreGraphics

@Observable @MainActor
final class ReviewingStageManager {
    enum PanelScreen: Hashable {
        case scorecard
        case feedbackReview(title: String)
    }

    var panelScreen: PanelScreen = .scorecard

    func canEnter(from activityStage: SessionState.ActivityStage) -> Bool {
        switch activityStage {
            case .onboarding, .speaking, .reviewing:
                true
        }
    }

    func reset() {
        panelScreen = .scorecard
    }

    func showScorecard() {
        panelScreen = .scorecard
    }

    func showFeedbackReview(title: String) {
        panelScreen = .feedbackReview(title: title)
    }

    var preferredPanelSize: CGSize {
        switch panelScreen {
            case .scorecard:
                CGSize(width: 780, height: 560)
            case .feedbackReview:
                CGSize(width: 560, height: 680)
        }
    }
}
