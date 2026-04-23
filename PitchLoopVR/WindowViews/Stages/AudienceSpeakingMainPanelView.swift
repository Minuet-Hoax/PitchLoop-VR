import SwiftUI

struct AudienceSpeakingMainPanelView: View {
    @Environment(PitchLoopAppModel.self) private var appModel

    var body: some View {
        AudienceFeedbackPanel(
            onSelectFeedback: { type, option in
                appModel.sessionController?.submitAudienceFeedback(type: type, option: option)
            },
            modalPresentation: .ornament,
            pillBottomPadding: 22
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    AudienceSpeakingMainPanelView()
        .environment(PitchLoopAppModel())
}
