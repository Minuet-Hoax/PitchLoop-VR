import SwiftUI

struct SpeakingStageView: View {
    @Environment(PitchLoopAppModel.self) private var appModel
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                VStack {
                    Spacer()
                    SpeakerMainControlPanel(onEndPresentation: {
                        appModel.sessionController?.endPresentation()
                    })
                    .padding(.bottom, 24)
                }
            }
            .onAppear {
                openWindow(id: "speaking-stage")
            }
            .onDisappear {
                dismissWindow(id: "speaking-stage")
            }
    }
}

private struct SpeakerMainControlPanel: View {
    let onEndPresentation: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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

            Button("End Presentation") {
                onEndPresentation()
            }
            .font(.system(size: 13, weight: .regular))
            .foregroundStyle(.primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.regularMaterial, in: Capsule())
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    SpeakingStageView()
        .environment(PitchLoopAppModel())
}
