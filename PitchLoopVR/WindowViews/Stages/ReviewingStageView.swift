import SwiftUI

struct ReviewingStageView: View {
    @Environment(PitchLoopAppModel.self) private var appModel
    @State private var mainPointChoice: SessionChoice?
    @State private var confidenceChoice: SessionChoice?

    var body: some View {
        Group {
            if let sessionController = appModel.sessionController {
                switch sessionController.game.reviewingPhase {
                    case .collectSurvey:
                        collectSurveyView(sessionController: sessionController)
                    case .publicScorecard:
                        publicScorecardView
                }
            } else {
                Color.clear
            }
        }
    }

    @ViewBuilder
    private func collectSurveyView(sessionController: SharePlaySessionController) -> some View {
        switch sessionController.localRole {
            case .speaker:
                PresentationSummaryView(
                    isScorecardEnabled: sessionController.allAudienceSubmittedSurvey,
                    onDone: {},
                    onScorecard: {
                        sessionController.enterPublicScorecard()
                    }
                )
                .ornament(attachmentAnchor: .scene(.top), contentAlignment: .center) {
                    SurveyCompletionOrnament(
                        completedSurveyAudienceCount: sessionController.completedSurveyAudienceCount,
                        audienceCount: sessionController.audienceCount
                    )
                }
            case .audience:
                if sessionController.hasLocalAudienceSubmittedSurvey {
                    FeedbackSubmittedWaitingView()
                } else {
                    PostSessionSurveyView(
                        mainPointChoice: $mainPointChoice,
                        confidenceChoice: $confidenceChoice,
                        onClose: {},
                        onSubmit: {
                            sessionController.submitPostSessionSurvey()
                        }
                    )
                }
            case .none:
                Color.clear
        }
    }

    @ViewBuilder
    private var publicScorecardView: some View {
        switch appModel.stageManager.reviewing.panelScreen {
            case .scorecard:
                SpeakerScorecardView(
                    onBack: {},
                    onReview: { title in
                        appModel.stageManager.reviewing.showFeedbackReview(title: title)
                    }
                )
            case .feedbackReview(let title):
                FeedbackReviewView(
                    title: title,
                    onBack: {
                        appModel.stageManager.reviewing.showScorecard()
                    }
                )
        }
    }
}

#Preview {
    ReviewingStageView()
        .environment(PitchLoopAppModel())
}

private struct SurveyCompletionOrnament: View {
    let completedSurveyAudienceCount: Int
    let audienceCount: Int

    private var statusColor: Color {
        audienceCount > 0 && completedSurveyAudienceCount == audienceCount ? .green : .red
    }

    private var completionText: String {
        let audienceLabel = audienceCount == 1 ? "audience" : "audiences"
        return "\(completedSurveyAudienceCount) of \(audienceCount) \(audienceLabel) completed the post-session survey"
    }

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(statusColor)
                .frame(width: 9, height: 9)
            Text(completionText)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 11)
        .background(Capsule(style: .continuous).fill(Color.white.opacity(0.18)))
        .overlay(Capsule(style: .continuous).stroke(Color.white.opacity(0.2), lineWidth: 1))
        .padding(8)
    }
}
