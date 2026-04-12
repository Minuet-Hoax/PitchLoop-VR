//
//  SpeakerCueInstructionView.swift
//  PitchLoopVR
//
//  Created by Gennifer Hom on 3/27/26.
//

import SwiftUI

struct SpeakerCueInstructionView: View {
    @Environment(PitchLoopAppModel.self) private var appModel
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(spacing: 18) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 34, weight: .regular))
                        .foregroundStyle(.blue)

                    Text("Look up for feedback cues")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)

                    Text("If someone flags something like pace, it will appear as a subtle notification. Use it to adjust while you speak.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.78))
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .frame(maxWidth: 520)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 34)
                .frame(width: 700, height: 250)

                cuePreview

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    appModel.stageManager.onboarding.cancelOnboarding(using: appModel.sessionController)
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary.opacity(0.9))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
                .padding(.trailing, 12)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { appModel.stageManager.onboarding.advanceSpeakerCueInstruction() }
        .onAppear { openWindow(id: "cue-preview") }
        .onDisappear { dismissWindow(id: "cue-preview") }
        .navigationBarBackButtonHidden(true)
        .ornament(attachmentAnchor: .scene(.bottom), contentAlignment: .top) {
            Text("tap to continue")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }

    private var cuePreview: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.28), lineWidth: 1)
                    .frame(width: 62, height: 62)

                Image(systemName: "waveform")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.white)
            }

            Text("Pace Yourself")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(width: 360, height: 92)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .padding(.top, 22)
    }
}

#Preview {
    NavigationStack {
        SpeakerCueInstructionView()
    }
    .frame(width: 726, height: 281)
    .fixedSize()
}
