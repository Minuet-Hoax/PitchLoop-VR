//
//  SpeakerCueInstructionView.swift
//  PitchLoopVR
//
//  Created by Gennifer Hom on 3/27/26.
//

import SwiftUI

struct SpeakerCueInstructionView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    let onDismiss: () -> Void
    let onNext: () -> Void

    private let cuePreviewWindowID = "onboarding-cue-preview"

    var body: some View {
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
            .frame(maxWidth: 600)
            .contentShape(Rectangle())
            .onTapGesture {
                dismissWindow(id: cuePreviewWindowID)
                onNext()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary.opacity(0.9))
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            .padding(.top, 12)
            .padding(.trailing, 12)
        }
        .ornament(attachmentAnchor: .scene(.bottom), contentAlignment: .top) {
            Text("pinch the panel to continue")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .onAppear {
            openWindow(id: cuePreviewWindowID)
        }
        .onDisappear {
            dismissWindow(id: cuePreviewWindowID)
        }
    }
}

#Preview {
    SpeakerCueInstructionView(onDismiss: {}, onNext: {})
        .frame(width: 726, height: 420)
        .fixedSize()
}
