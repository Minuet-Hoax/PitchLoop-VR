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

    private var localRole: ParticipantModel.Role? {
        appModel.sessionController?.localRole
    }

    private var mainWindowWidth: CGFloat {
        switch activityStage {
            case .speaking:
                switch localRole {
                    case .audience:
                        return 420
                    case .speaker:
                        return 220
                    case .none:
                        return 1
                }
            case .reviewing:
                return reviewingPanelSize.width
            case .none, .onboarding:
                return 900
        }
    }

    private var mainWindowHeight: CGFloat {
        switch activityStage {
            case .speaking:
                switch localRole {
                    case .audience:
                        return 170
                    case .speaker:
                        return 160
                    case .none:
                        return 1
                }
            case .reviewing:
                return reviewingPanelSize.height
            case .none, .onboarding:
                return 600
        }
    }

    private var reviewingPanelSize: CGSize {
        guard let sessionController = appModel.sessionController else {
            return CGSize(width: 900, height: 600)
        }

        switch sessionController.game.reviewingPhase {
            case .collectSurvey:
                return CGSize(width: 900, height: 600)
            case .publicScorecard:
                return appModel.stageManager.reviewing.preferredPanelSize
        }
    }

    var body: some Scene {
        WindowGroup(id: "main") {
            NavigationStack {
                RootView()
            }
            .frame(width: mainWindowWidth, height: mainWindowHeight)
            .participantNameAlert()
        }
        .windowResizability(.contentSize)

        WindowGroup(id: "speaking-stage") {
            SpeakingStageWindowView()
                .environment(appModel)
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)

        WindowGroup(id: "onboarding-cue-preview") {
            CuePreviewAuxiliaryWindowView()
                .frame(width: 320, height: 140)
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
    }
}
