import SwiftUI

struct SpeakingStageView: View {
    @Environment(PitchLoopAppModel.self) private var appModel

    var body: some View {
        Group {
            if let sessionController = appModel.sessionController {
                switch sessionController.localRole {
                    case .speaker:
                        SpeakerView(onEndPresentation: {
                            sessionController.endPresentation()
                        })
                        .environment(appModel.feedbackStore)
                    case .audience:
                        AudienceView(onSendFeedback: { type, option in
                            sessionController.submitAudienceFeedback(type: type, option: option)
                        })
                        .environment(appModel.feedbackStore)
                    case .none:
                        Color.clear
                }
            } else {
                Color.clear
            }
        }
    }
}

#Preview {
    SpeakingStageView()
        .environment(PitchLoopAppModel())
}
