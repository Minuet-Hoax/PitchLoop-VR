import SwiftUI

struct SpeakerFeedbackView: View {
    @Environment(PitchLoopAppModel.self) private var appModel
    
    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 38, weight: .regular))
                .foregroundStyle(.blue)

            Text("Before you begin")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.primary)

            Text("You’ll receive feedback as you speak.\nSubtle cues will help you adjust in the moment.")
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
            Button(action: {
                appModel.stageManager.onboarding.cancelOnboarding(using: appModel.sessionController)
            }) {
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
        .onTapGesture {
            appModel.stageManager.onboarding.advanceSpeakerFeedback()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        SpeakerFeedbackView()
    }
}
