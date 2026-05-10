import SwiftUI

struct SpeakerStartSessionView: View {
    let onNext: () -> Void
    let isStartEnabled: Bool

    var body: some View {
        VStack(spacing: 0) {
            Circle()
                .stroke(Color.blue.opacity(0.8), lineWidth: 2)
                .frame(width: 44, height: 44)
                .padding(.bottom, 14)

            Text("You're all set!")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.primary)
                .padding(.bottom, 10)

            Text("Stretch, drink some water, and start the session when everyone is ready.")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 460)
                .padding(.bottom, 28)

            Button(action: onNext) {
                Text("Start Session")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 10)
                    .background(
                        Capsule(style: .continuous)
                            .fill(isStartEnabled ? Color.blue : Color.gray.opacity(0.6))
                    )
            }
            .buttonStyle(.plain)
            .disabled(!isStartEnabled)
        }
        .padding(40)
        .frame(maxWidth: 560)
        .ornament(attachmentAnchor: .scene(.top), contentAlignment: .bottom) {
            WaitingParticipantsView()
        }
    }
}

#Preview {
    SpeakerStartSessionView(
        onNext: {},
        isStartEnabled: false
    )
    .environment(PitchLoopAppModel())
}
