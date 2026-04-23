/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The pre-SharePlay entry view for Pitch Loop VR.
*/

import SwiftUI

struct SharePlayEntryView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.brown.opacity(0.35), .indigo.opacity(0.55), .black.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 28) {
                SharePlayEntryBanner()
                
                VStack(spacing: 12) {
                    Text("Pitch Loop VR")
                        .font(.system(size: 54, weight: .bold, design: .rounded))
                    Text("Practice communication moments in a shared space.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 560)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Label("Launch from a FaceTime call with SharePlay.", systemImage: "shareplay")
                    Label("Assign one Speaker and any number of Audience members.", systemImage: "person.3.sequence.fill")
                }
                .font(.title3)
                .padding(24)
                .glassBackgroundEffect()
                
                SharePlayLauncherButton("Start Pitch Loop VR", activity: PitchLoopActivity())
                    .controlSize(.large)
                    .font(.title2.weight(.semibold))
            }
            .padding(40)
        }
    }
}

private struct SharePlayEntryBanner: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.12))
                .frame(width: 170, height: 170)
                .blur(radius: 12)
            Image(systemName: "waveform.and.mic")
                .font(.system(size: 72, weight: .semibold))
                .foregroundStyle(.white, .orange)
        }
    }
}
