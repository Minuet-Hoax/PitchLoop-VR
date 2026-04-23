import SwiftUI

struct SpeakingStageWindowView: View {
    @Environment(PitchLoopAppModel.self) private var appModel

    var body: some View {
        if let sessionController = appModel.sessionController, sessionController.localRole == .speaker {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(alignment: .top) {
                    SpeakerFeedbackOverlay()
                        .padding(.top, 16)
                }
                .environment(appModel.feedbackStore)
        } else {
            Color.clear
        }
    }
}

#Preview {
    SpeakingStageWindowView()
        .environment(PitchLoopAppModel())
}
