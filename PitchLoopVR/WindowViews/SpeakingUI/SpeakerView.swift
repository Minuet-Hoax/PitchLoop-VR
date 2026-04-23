import SwiftUI

struct SpeakerView: View {
    let onEndPresentation: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(.red)
                            .frame(width: 8, height: 8)
                        Text("Presenting")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.primary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(.regularMaterial, in: Capsule())

                    Spacer()
                }

                Button("End Presentation") {
                    onEndPresentation()
                }
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(.regularMaterial, in: Capsule())
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.top, 20)
            .padding(.leading, 20)

            VStack {
                SpeakerFeedbackOverlay()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
