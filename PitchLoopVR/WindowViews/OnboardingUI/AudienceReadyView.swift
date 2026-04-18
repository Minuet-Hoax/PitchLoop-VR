import SwiftUI

struct AudienceReadyView: View {
    @Environment(PitchLoopAppModel.self) private var appModel

    var body: some View {
        if let sessionController = appModel.sessionController {
            VStack(spacing: 24) {
                Text("Audience Test, You're all set!")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)

                Button("Ready") {
                    appModel.stageManager.onboarding.markAudienceReady(using: sessionController)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(sessionController.localIsReady)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(40)
            .navigationBarBackButtonHidden(true)
            .overlay(alignment: .topTrailing) {
                Button {
                    appModel.stageManager.onboarding.cancelOnboarding(using: appModel.sessionController)
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                }
                .buttonStyle(.plain)
                .padding(.top, 30)
                .padding(.trailing, 40)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AudienceReadyView()
    }
}
