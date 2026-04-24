import SwiftUI

struct OnboardingStageView: View {
    @Environment(PitchLoopAppModel.self) private var appModel
    @State private var showSpeakerTakenNotice = false
    @State private var speakerTakenNoticeTask: Task<Void, Never>?

    var body: some View {
        Group {
            if let deadline = appModel.sessionController?.sessionStartCountdownDeadline {
                SessionStartCountdownView(deadline: deadline)
            } else {
                switch appModel.stageManager.onboarding.currentScreen {
                    case .roleSelection:
                        RoleSelectionView(onNavigate: onRoleSelection)
                            .overlay(alignment: .top) {
                                if showSpeakerTakenNotice {
                                    SpeakerTakenNotice()
                                        .offset(y: -30)
                                        .transition(.move(edge: .top).combined(with: .opacity))
                                }
                            }
                    case .speakerFeedback:
                        SpeakerFeedbackView(
                            onDismiss: {
                                appModel.stageManager.onboarding.cancelOnboarding(using: appModel.sessionController)
                            },
                            onNext: {
                                appModel.stageManager.onboarding.advanceSpeakerFeedback()
                            }
                        )
                    case .speakerCueInstruction:
                        SpeakerCueInstructionView(
                            onDismiss: {
                                appModel.stageManager.onboarding.cancelOnboarding(using: appModel.sessionController)
                            },
                            onNext: {
                                appModel.stageManager.onboarding.advanceSpeakerCueInstruction()
                            }
                        )
                    case .speakerStartSession:
                        if let sessionController = appModel.sessionController {
                            SpeakerStartSessionView(
                                onNext: {
                                    appModel.stageManager.onboarding.startSession(using: sessionController)
                                },
                                isStartEnabled: appModel.stageManager.onboarding.canStartSession(using: sessionController)
                            )
                        } else {
                            Color.clear
                                .frame(width: 1, height: 1)
                                .fixedSize()
                        }
                    case .audienceOnboarding:
                        AudienceOnboardingView(
                            onDismiss: {
                                appModel.stageManager.onboarding.cancelOnboarding(using: appModel.sessionController)
                            },
                            onNext: {
                                appModel.stageManager.onboarding.advanceAudienceOnboarding()
                            }
                        )
                        .frame(width: 640, height: 280)
                        .fixedSize()
                    case .audienceFeedbackTutorial:
                        AudienceFeedbackTutorialView(
                            onDismiss: {
                                appModel.stageManager.onboarding.cancelOnboarding(using: appModel.sessionController)
                            },
                            onComplete: {
                                appModel.stageManager.onboarding.advanceAudienceFeedbackTutorial()
                            }
                        )
                        .frame(width: 640, height: 560)
                        .fixedSize()
                    case .audienceReminder:
                        AudienceReminderView(
                            onDismiss: {
                                appModel.stageManager.onboarding.cancelOnboarding(using: appModel.sessionController)
                            },
                            onNext: {
                                appModel.stageManager.onboarding.currentScreen = .audienceReady
                            }
                        )
                        .frame(width: 640, height: 280)
                        .fixedSize()
                    case .audienceReady:
                        AudienceReadyView(
                            onDismiss: {
                                appModel.stageManager.onboarding.cancelOnboarding(using: appModel.sessionController)
                            },
                            onBack: {
                                appModel.stageManager.onboarding.currentScreen = .audienceReminder
                            },
                            onReady: {
                                if let sessionController = appModel.sessionController {
                                    appModel.stageManager.onboarding.markAudienceReady(using: sessionController)
                                }
                                appModel.stageManager.onboarding.audienceBeganWaiting()
                            }
                        )
                        .frame(width: 640)
                        .fixedSize()
                    case .audienceWaiting:
                        AudienceWaitingView(onNext: {})
                            .fixedSize()
                }
            }
        }
        .onDisappear {
            speakerTakenNoticeTask?.cancel()
            speakerTakenNoticeTask = nil
        }
    }

    private func onRoleSelection(_ role: UserRole) {
        guard let sessionController = appModel.sessionController else {
            return
        }

        switch role {
            case .speaker:
                guard !sessionController.localIsReady else {
                    return
                }

                if sessionController.canBecomeSpeaker {
                    appModel.stageManager.onboarding.beginSpeakerOnboarding(using: sessionController)
                } else {
                    presentSpeakerTakenNotice()
                }
            case .audience:
                guard !sessionController.localIsReady else {
                    return
                }

                appModel.stageManager.onboarding.beginAudienceOnboarding(using: sessionController)
        }
    }

    private func presentSpeakerTakenNotice() {
        speakerTakenNoticeTask?.cancel()

        withAnimation(.easeInOut(duration: 0.2)) {
            showSpeakerTakenNotice = true
        }

        speakerTakenNoticeTask = Task {
            try? await Task.sleep(for: .seconds(2))

            guard !Task.isCancelled else {
                return
            }

            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showSpeakerTakenNotice = false
                }
            }
        }
    }
}

private struct SpeakerTakenNotice: View {
    var body: some View {
        Text("Speaker role is already taken.")
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(.black.opacity(0.72), in: Capsule(style: .continuous))
            .padding(.top, 8)
    }
}

#Preview {
    OnboardingStageView()
        .environment(PitchLoopAppModel())
}
