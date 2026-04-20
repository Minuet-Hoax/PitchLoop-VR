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
    @Environment(AudienceFeedbackModel.self) private var model
    @Environment(\.dismiss) private var dismiss
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

                if !model.isTutorialMode {
                    Text("Live mode: choose an option, then close to continue.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 28)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                guard model.isTutorialMode else {
                    return
                }
                advanceTutorial()
            }
            .padding(32)
            .frame(width: 360)
            .overlay(alignment: .topTrailing) {
                if !model.isTutorialMode {
                    Button(action: {
                        model.activeFeedbackItem = nil
                        dismiss()
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
            .ornament(
                visibility: model.isTutorialMode ? .visible : .hidden,
                attachmentAnchor: .scene(.bottom),
                contentAlignment: .top
            ) {
                Text(model.isLastTutorialItem ? "Pinch to finish" : "Pinch to continue")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .onChange(of: model.tutorialStep) { _, _ in
                selectedOption = nil
            }
        }
    }

    private func advanceTutorial() {
        if model.isLastTutorialItem {
            model.activeFeedbackItem = nil
            model.tutorialComplete = true
        } else {
            model.tutorialStep += 1
        }
    }
}
