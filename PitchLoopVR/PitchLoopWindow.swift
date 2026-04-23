/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's main window, which presents the UI for the current stage.
*/

import SwiftUI

struct PitchLoopWindow: Scene {
    @Environment(PitchLoopAppModel.self) private var appModel

    private var activityStage: SessionState.ActivityStage? {
        appModel.sessionController?.game.stage
    }

    private var shouldMinimizeMainHost: Bool {
        activityStage == .speaking || activityStage == .reviewing
    }

    private var shouldShowMainHeader: Bool {
        activityStage == .onboarding
    }

    var body: some Scene {
        WindowGroup(id: "main") {
            NavigationStack {
                VStack(spacing: 0) {
                    if shouldShowMainHeader {
                        MainWindowBrandHeader()
                            .padding(.top, 16)
                            .padding(.bottom, 8)
                    }

                    RootView()
                }
            }
            .frame(width: shouldMinimizeMainHost ? 1 : 900, height: shouldMinimizeMainHost ? 1 : 600)
            .participantNameAlert()
        }
        .windowResizability(.contentSize)

        WindowGroup(id: "speaking-stage") {
            SpeakingStageWindowView()
                .environment(appModel)
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
    }
}

private struct MainWindowBrandHeader: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "waveform.and.mic")
                .font(.title3.weight(.semibold))
            Text("Pitch Loop VR")
                .font(.headline.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
