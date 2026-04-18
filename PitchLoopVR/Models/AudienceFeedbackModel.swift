import Foundation
import Observation

struct LiveFeedbackItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let description: String
}

@MainActor
@Observable
final class AudienceFeedbackModel {
    var activeFeedbackItem: LiveFeedbackItem?
    var completedItemLabels = Set<String>()

    var hasCompletedAllItems: Bool {
        completedItemLabels.count >= 4
    }
}
