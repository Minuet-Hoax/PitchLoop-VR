import SwiftUI

struct AudienceView: View {
    let onSendFeedback: (FeedbackType, FeedbackOption) -> Void

    @State private var showFeedbackSent = false

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if showFeedbackSent {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .font(.system(size: 14, weight: .semibold))
                            Text("Feedback Sent")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial, in: Capsule())
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    Spacer()
                }
                .padding(.top, 20)
                .padding(.leading, 20)

                Spacer()
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showFeedbackSent)

            AudienceFeedbackPanel(
                onSelectFeedback: onSendFeedback,
                onFeedbackSent: {
                    showFeedbackSent = true
                    Task {
                        try? await Task.sleep(for: .seconds(3))
                        await MainActor.run {
                            withAnimation {
                                showFeedbackSent = false
                            }
                        }
                    }
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}
