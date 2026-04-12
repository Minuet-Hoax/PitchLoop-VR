/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The role-selection panel for Pitch Loop VR.
*/

import SwiftUI

struct RoleSelectionView: View {
    @Environment(PitchLoopAppModel.self) private var appModel

    var body: some View {
        if let sessionController = appModel.sessionController {
            VStack(spacing: 54) {
                Text("Choose your preferred Role")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 26) {
                    RoleButton(
                        title: "Join as Speaker",
                        isSelected: sessionController.localRole == .speaker
                    ) {
                        appModel.stageManager.onboarding.beginSpeakerOnboarding(using: sessionController)
                    }
                    .disabled(sessionController.localIsReady || !sessionController.canBecomeSpeaker)
                    .opacity(sessionController.localIsReady || !sessionController.canBecomeSpeaker ? 0.55 : 1)

                    RoleButton(
                        title: "Join as Audience",
                        isSelected: sessionController.localRole == .audience
                    ) {
                        appModel.stageManager.onboarding.beginAudienceOnboarding(using: sessionController)
                    }
                    .disabled(sessionController.localIsReady)
                    .opacity(sessionController.localIsReady ? 0.55 : 1)
                }
            }
            .frame(maxWidth: 520)
            .padding()
        }
    }
}

private struct RoleButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 34)
            .frame(width: 350, height: 60)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? Color.blue : Color.white.opacity(0.28))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.white.opacity(isSelected ? 0.0 : 0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
