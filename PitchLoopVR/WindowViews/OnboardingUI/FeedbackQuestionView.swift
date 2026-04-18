import SwiftUI

private let feedbackContent: [String: (question: String, options: [String])] = [
    "Pace": (
        question: "How is the speaker's pacing?",
        options: ["Too fast", "Too slow", "Felt just right"]
    ),
    "Eye Contact": (
        question: "How was the eye contact?",
        options: ["Too little", "Just right", "Avoiding audience"]
    ),
    "Gesture": (
        question: "How were the gestures?",
        options: ["Too few", "Natural", "Distracting"]
    ),
    "Timing": (
        question: "How was the overall timing?",
        options: ["Too short", "Just right", "Too long"]
    )
]

struct FeedbackQuestionView: View {
    @Environment(PitchLoopAppModel.self) private var appModel
    @Environment(\.openWindow) private var openWindow
    @Environment(AudienceFeedbackModel.self) private var model
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var selectedOption: String?

    var body: some View {
        if let item = model.activeFeedbackItem {
            let qa = feedbackContent[item.label]

            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: item.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.blue)
                }
                .padding(.bottom, 18)

                Text(qa?.question ?? "How did it go?")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 28)

                VStack(spacing: 10) {
                    ForEach(qa?.options ?? [], id: \.self) { option in
                        Button(action: { selectedOption = option }) {
                            Text(option)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(selectedOption == option ? .white : .primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 13)
                                .background(
                                    Capsule(style: .continuous)
                                        .fill(selectedOption == option ? Color.blue : Color.white.opacity(0.12))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 28)

                Text(
                    model.hasCompletedAllItems
                    ? "Pinch to continue"
                    : "Explore all four items to continue (\(model.completedItemLabels.count)/4)"
                )
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(model.hasCompletedAllItems ? 1 : 0.9)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                guard model.hasCompletedAllItems else {
                    return
                }
                appModel.stageManager.onboarding.completeAudienceFeedbackTutorial()
                model.activeFeedbackItem = nil
                dismissWindow(id: "feedback-question")
                dismissWindow(id: "audience-feedback")
                openWindow(id: "main")
            }
            .padding(32)
            .frame(width: 360)
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    model.activeFeedbackItem = nil
                    dismissWindow(id: "feedback-question")
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
                .padding(12)
            }
        }
    }
}
