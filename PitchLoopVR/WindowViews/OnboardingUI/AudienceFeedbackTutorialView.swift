import SwiftUI

struct AudienceFeedbackTutorialView: View {
    let onDismiss: () -> Void
    let onComplete: () -> Void

    @State private var currentStepIndex = 0

    private var tutorialTypes: [FeedbackType] {
        FeedbackType.allCases
    }

    private var currentType: FeedbackType {
        tutorialTypes[currentStepIndex]
    }

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                AudienceFeedbackPanel(
                    onSelectFeedback: { _, _ in },
                    modalPresentation: .overlay,
                    pillBottomPadding: 8,
                    overlayModalBottomInset: 190,
                    forcedSelectedFeedback: currentType,
                    isInteractionEnabled: false,
                    showsModalCloseButton: false
                )
            }
            .overlay(alignment: .topTrailing) {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary.opacity(0.9))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
                .padding(.trailing, 12)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                advanceStep()
            }
            .ornament(attachmentAnchor: .scene(.bottom), contentAlignment: .top) {
                Text("pinch the panel to continue")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
            }
    }

    private func advanceStep() {
        if currentStepIndex < tutorialTypes.count - 1 {
            withAnimation(.easeOut(duration: 0.2)) {
                currentStepIndex += 1
            }
        } else {
            onComplete()
        }
    }
}

#Preview {
    AudienceFeedbackTutorialView(onDismiss: {}, onComplete: {})
        .frame(width: 640, height: 440)
}
