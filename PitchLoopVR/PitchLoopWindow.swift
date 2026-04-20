/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's main window, which presents the UI for the current stage.
*/

import SwiftUI

struct PitchLoopWindow: Scene {
    @State private var audienceFeedbackModel = AudienceFeedbackModel()
    
    var body: some Scene {
        WindowGroup(id: "main") {
            NavigationStack {
                RootView()
            }
            .frame(width: 900, height: 600)
            .participantNameAlert()
            .environment(audienceFeedbackModel)
        }
        .windowResizability(.contentSize)

        WindowGroup(id: "audience-feedback") {
            AudienceFeedbackWindow()
                .environment(audienceFeedbackModel)
        }
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let main = context.windows.first(where: { $0.id == "main" }) {
                return WindowPlacement(.below(main))
            }
            return WindowPlacement()
        }

        WindowGroup(id: "live-question") {
            FeedbackQuestionView()
                .environment(audienceFeedbackModel)
        }
        .windowResizability(.contentSize)

        WindowGroup(id: "cue-preview") {
            CuePreviewView()
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let main = context.windows.first(where: { $0.id == "main" }) {
                return WindowPlacement(.above(main))
            }
            return WindowPlacement()
        }

        WindowGroup(id: "waiting-participants") {
            WaitingParticipantsView()
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let main = context.windows.first(where: { $0.id == "main" }) {
                return WindowPlacement(.above(main))
            }
            return WindowPlacement()
        }
    }
}
