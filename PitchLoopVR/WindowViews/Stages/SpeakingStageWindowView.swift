import SwiftUI

struct SpeakingStageWindowView: View {
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
        .overlay(alignment: .topTrailing) {
            CompactWindowBrandBadge()
                .padding(.top, 14)
                .padding(.trailing, 14)
        }
    }
}

#Preview {
    SpeakingStageWindowView()
        .environment(PitchLoopAppModel())
}

private struct CompactWindowBrandBadge: View {
    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: "waveform.and.mic")
                .font(.system(size: 12, weight: .semibold))
            Text("Pitch Loop VR")
                .font(.system(size: 11, weight: .semibold))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .frame(maxWidth: 98, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
