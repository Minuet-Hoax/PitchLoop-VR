import SwiftUI

struct AudienceReadyView: View {
    let onDismiss: () -> Void
    let onBack: () -> Void
    let onReady: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 38, weight: .regular))
                .foregroundStyle(.blue)

            Text("You're all set!")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.primary)

            Text("Stretch, drink some water, and press the button when you're ready. Then wait for the speaker to begin.")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .frame(maxWidth: 460)
                .padding(.bottom, 8)

            HStack(spacing: 12) {
                Button(action: onReady) {
                    Text("I'm Ready")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Capsule(style: .continuous).fill(Color.blue))
                }
                .buttonStyle(.plain)

                Button(action: onBack) {
                    Text("Go Back")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            Capsule(style: .continuous)
                                .fill(Color.white.opacity(0.12))
                        )
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: 400)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 28)
        .frame(maxWidth: 640)
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
    }
}

#Preview {
    AudienceReadyView(onDismiss: {}, onBack: {}, onReady: {})
}
