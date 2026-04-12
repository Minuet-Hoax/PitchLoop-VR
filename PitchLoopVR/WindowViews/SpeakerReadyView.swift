//
//  SpeakerReadyView.swift
//  PitchLoopVR
//
//  Created by Gennifer Hom on 4/8/26.
//

import SwiftUI

struct SpeakerReadyView: View {
    @Environment(PitchLoopAppModel.self) private var appModel

    var body: some View {
        if let sessionController = appModel.sessionController {
            ZStack {
                VStack {
                    Spacer()

                    VStack(spacing: 18) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(.blue)

                        Text("You're all set")
                            .font(.system(size: 28, weight: .bold))

                        Text("When you press start, your session will begin.")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Button("StartSession") {
                            appModel.stageManager.onboarding.startSession(using: sessionController)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        .disabled(!appModel.stageManager.onboarding.canStartSession(using: sessionController))
                        .padding(.top, 10)

                        Text("\(sessionController.readyAudienceCount)/\(sessionController.audienceCount) audience ready")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 28)
                    .frame(width: 560)
                    .background(
                        RoundedRectangle(cornerRadius: 26)
                            .fill(.ultraThinMaterial)
                    )

                    Spacer()
                }

                VStack {
                    HStack {
                        Spacer()

                        Button {
                            appModel.stageManager.onboarding.cancelOnboarding(using: appModel.sessionController)
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .padding(.top, 30)
                        .padding(.trailing, 40)
                    }

                    Spacer()
                }
            }
            .contentShape(Rectangle())
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    NavigationStack {
        SpeakerReadyView()
    }
}
