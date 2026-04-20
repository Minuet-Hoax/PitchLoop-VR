import SwiftUI

struct AudienceWaitingView: View {
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text("Waiting for the speaker to begin")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            Text("Please wait for the speaker to start. You can get to know other audiences.")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 22)
        .frame(maxWidth: 560)
        .contentShape(Rectangle())
        .onTapGesture { onNext() }
    }
}

#Preview {
    AudienceWaitingView(onNext: {})
}
