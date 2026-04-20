import SwiftUI

struct CuePreviewView: View {
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.28), lineWidth: 1)
                    .frame(width: 36, height: 36)

                Image(systemName: "waveform")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
            }

            Text("Pace Yourself")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .glassBackgroundEffect(in: Capsule())
    }
}

#Preview {
    CuePreviewView()
}
