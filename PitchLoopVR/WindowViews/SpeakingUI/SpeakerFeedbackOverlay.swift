import SwiftUI

struct SpeakerFeedbackOverlay: View {
    @Environment(FeedbackStore.self) private var feedbackStore
    @State private var lastShownAt: [String: Date] = [:]

    private let dedupeWindow: TimeInterval = 20

    private var displayQueue: [FeedbackMessage] {
        feedbackStore.pendingFeedback.filter { message in
            guard let lastDate = lastShownAt[message.notificationText] else {
                return true
            }

            return Date().timeIntervalSince(lastDate) >= dedupeWindow
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            if let message = displayQueue.first {
                FeedbackBanner(message: message) {
                    lastShownAt[message.notificationText] = Date()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        feedbackStore.dismiss(message: message)
                    }
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    )
                )
                .id(message.id)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: displayQueue.first?.id)
    }
}

private struct FeedbackBanner: View {
    let message: FeedbackMessage
    let onDismiss: () -> Void

    @State private var opacity: Double = 0

    var body: some View {
        Button(action: onDismiss) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.08), radius: 2)

                    Text(message.type.emoji)
                        .font(.system(size: 22))
                }

                Text(message.notificationText)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.regularMaterial, in: Capsule())
            .shadow(color: .black.opacity(0.12), radius: 8, y: 2)
        }
        .buttonStyle(.plain)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.25)) {
                opacity = 1
            }

            Task {
                try? await Task.sleep(for: .seconds(4))
                withAnimation(.easeIn(duration: 0.4)) {
                    opacity = 0
                }
                try? await Task.sleep(for: .seconds(0.4))
                onDismiss()
            }
        }
    }
}
