import SwiftUI

struct SpeakingStageView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        Color.clear
            .frame(width: 1, height: 1)
            .fixedSize()
            .onAppear {
                openWindow(id: "speaking-stage")
            }
            .onDisappear {
                dismissWindow(id: "speaking-stage")
            }
    }
}

#Preview {
    SpeakingStageView()
}
