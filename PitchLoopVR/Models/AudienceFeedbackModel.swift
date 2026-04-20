import SwiftUI
import Observation

// Shared item definitions — used by AudienceLiveFeedbackView, AudienceFeedbackWindow, and FeedbackQuestionView.
let audienceFeedbackItems: [LiveFeedbackItem] = [
    LiveFeedbackItem(icon: "waveform", label: "Pace", description: "Pinch to note how the pacing felt"),
    LiveFeedbackItem(icon: "eye", label: "Eye Contact", description: "Pinch to flag an eye contact issue"),
    LiveFeedbackItem(icon: "hand.raised", label: "Gesture", description: "Pinch to note a gesture concern"),
    LiveFeedbackItem(icon: "clock", label: "Timing", description: "Pinch to note a timing issue")
]

@MainActor
@Observable
final class AudienceFeedbackModel {
    var activeFeedbackItem: LiveFeedbackItem? = nil

    // Tutorial state.
    var isTutorialMode: Bool = false
    var tutorialStep: Int = 0
    var tutorialComplete: Bool = false

    // Live session trigger.
    var liveSessionStarted: Bool = false

    var isLastTutorialItem: Bool {
        tutorialStep == audienceFeedbackItems.count - 1
    }

    var isWaitingForSession: Bool {
        tutorialComplete && !liveSessionStarted
    }
}
