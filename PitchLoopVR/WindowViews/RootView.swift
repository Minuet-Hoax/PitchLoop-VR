/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The main UI view, which presents different subviews based on the app's current state.
*/

import GroupActivities
import SwiftUI

struct RootView: View {
    @Environment(PitchLoopAppModel.self) var appModel
    
    var body: some View {
        Group {
            switch appModel.sessionController?.game.stage {
                case .none:
                    SharePlayEntryView()
                case .some(let activityStage):
                    switch appModel.stageManager.stage(for: activityStage) {
                        case .onboarding:
                            OnboardingStageView()
                        case .speaking:
                            if let sessionController = appModel.sessionController {
                                switch sessionController.localRole {
                                    case .speaker:
                                        SpeakingStageView()
                                    case .audience:
                                        AudienceSpeakingMainPanelView()
                                    case .none:
                                        Color.clear
                                }
                            } else {
                                Color.clear
                            }
                        case .reviewing:
                            ReviewingStageView()
                    }
            }
        }
        .task(observeGroupSessions)
        .onChange(of: appModel.sessionController?.game.stage, initial: true) { _, newStage in
            if newStage == .speaking {
                appModel.speakingStageAudio.start()
            } else {
                appModel.speakingStageAudio.stop()
            }
        }
    }
    
    /// Monitor for new Guess Together group activity sessions.
    @Sendable
    func observeGroupSessions() async {
        for await session in PitchLoopActivity.sessions() {
            let sessionController = await SharePlaySessionController(session, appModel: appModel)
            guard let sessionController else {
                continue
            }
            appModel.stageManager.onboarding.reset()
            appModel.stageManager.reviewing.reset()
            appModel.feedbackStore.resetAll()
            appModel.sessionController = sessionController

            // Create a task to observe the group session state and clear the
            // session controller when the group session invalidates.
            Task {
                for await state in session.$state.values {
                    guard appModel.sessionController?.session.id == session.id else {
                        return
                    }

                    if case .invalidated = state {
                        appModel.stageManager.onboarding.reset()
                        appModel.stageManager.reviewing.reset()
                        appModel.feedbackStore.resetAll()
                        appModel.sessionController = nil
                        return
                    }
                }
            }
        }
    }
}
