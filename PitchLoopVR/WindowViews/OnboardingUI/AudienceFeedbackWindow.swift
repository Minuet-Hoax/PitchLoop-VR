import SwiftUI

struct AudienceFeedbackWindow: View {
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow
    @Environment(AudienceFeedbackModel.self) private var feedbackModel
    @State private var hoveredItem: LiveFeedbackItem? = nil

    var body: some View {
        AudienceLiveFeedbackView(hoveredItem: $hoveredItem) { item in
            guard !feedbackModel.isTutorialMode else {
                return
            }

            if feedbackModel.activeFeedbackItem == nil {
                feedbackModel.activeFeedbackItem = item
                openWindow(id: "live-question")
            } else {
                feedbackModel.activeFeedbackItem = item
            }
        }
        .opacity(feedbackModel.isWaitingForSession ? 0.4 : 1.0)
        .allowsHitTesting(!feedbackModel.isWaitingForSession)
        .padding(16)
        .frame(width: 340)
        .fixedSize()
        .onAppear {
            if feedbackModel.isTutorialMode {
                openTutorialStep()
            }
        }
        .onChange(of: feedbackModel.tutorialStep) { _, _ in
            if feedbackModel.isTutorialMode {
                openTutorialStep()
            }
        }
        .onChange(of: feedbackModel.liveSessionStarted) { _, started in
            if started {
                feedbackModel.isTutorialMode = false
                hoveredItem = nil
                dismissWindow(id: "main")
            }
        }
        .ornament(
            visibility: hoveredItem != nil && !feedbackModel.isTutorialMode ? .visible : .hidden,
            attachmentAnchor: .scene(.top),
            contentAlignment: .bottom
        ) {
            HStack(spacing: 12) {
                Text(hoveredItem?.description ?? "")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)
                Spacer(minLength: 0)
                Button(action: { withAnimation { hoveredItem = nil } }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(width: 320)
            .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private func openTutorialStep() {
        let safeIndex = min(max(feedbackModel.tutorialStep, 0), audienceFeedbackItems.count - 1)
        let item = audienceFeedbackItems[safeIndex]
        feedbackModel.activeFeedbackItem = item
        hoveredItem = item
        dismissWindow(id: "live-question")
        openWindow(id: "live-question")
    }
}
