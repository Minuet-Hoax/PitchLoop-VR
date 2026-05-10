import SwiftUI

struct PresentationSummaryView: View {
    let isScorecardEnabled: Bool
    let onDone: () -> Void
    let onScorecard: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 64, height: 64)
                    Image(systemName: "checkmark")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 24)

                Text("Presentation Complete")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.bottom, 12)

                Text("You did it! Now, let's analyze how you can continue\nto improve and achieve even greater results.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.bottom, 32)

                Button(action: onScorecard) {
                    Text("View Score Card")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Capsule(style: .continuous).fill(isScorecardEnabled ? Color.blue : Color(white: 0.35, opacity: 0.9)))
                }
                .buttonStyle(.plain)
                .disabled(!isScorecardEnabled)
            }
            .padding(40)

            Button(action: onDone) {
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

#Preview {
    PresentationSummaryView(isScorecardEnabled: true, onDone: {}, onScorecard: {})
}
