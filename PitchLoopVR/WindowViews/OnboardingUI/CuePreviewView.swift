import SwiftUI

struct CuePreviewView: View {
    private let previewType: FeedbackType = .pace

    private var previewText: String {
        previewType.options.first?.notificationText ?? "Pace is too fast"
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 40, height: 40)
                    .shadow(color: .black.opacity(0.08), radius: 2)

                Text(previewType.emoji)
                    .font(.system(size: 22))
            }

            Text(previewText)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.regularMaterial, in: Capsule())
        .shadow(color: .black.opacity(0.12), radius: 8, y: 2)
    }
}

struct CuePreviewAuxiliaryWindowView: View {
    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .top) {
                CuePreviewView()
                    .padding(.top, 24)
            }
    }
}

#Preview {
    CuePreviewAuxiliaryWindowView()
        .frame(width: 320, height: 140)
}
