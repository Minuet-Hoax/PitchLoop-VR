import SwiftUI

struct AudienceReminderView: View {
    let onDismiss: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 38, weight: .regular))
                .foregroundStyle(.blue)

            Text("A few things to remember")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.primary)

            Text("During the session, you can flag each category up to 3 times. Your observations are recorded for the speaker's debrief and are not shared in real time.")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .frame(maxWidth: 460)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
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
        .contentShape(Rectangle())
        .onTapGesture { onNext() }
        .ornament(attachmentAnchor: .scene(.bottom), contentAlignment: .top) {
            Text("Pinch to continue")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    AudienceReminderView(onDismiss: {}, onNext: {})
}
