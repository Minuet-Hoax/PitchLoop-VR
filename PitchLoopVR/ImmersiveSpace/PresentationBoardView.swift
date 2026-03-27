/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A floating spatial board that mirrors the current presentation state.
*/

import Spatial
import SwiftUI

struct PresentationBoardView: View {
    @Environment(PitchLoopAppModel.self) var appModel
    @Environment(\.physicalMetrics) var converter
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .glassBackgroundEffect()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(alignment: .leading, spacing: 18) {
                Label(boardTitle, systemImage: boardSymbol)
                    .font(.title.weight(.bold))
                
                Divider()
                
                PromptLine(title: "Project", text: game.pitchTitle, fallback: "Waiting for a project title")
                PromptLine(title: "Question", text: game.coreQuestion, fallback: "Waiting for the speaker's question")
                PromptLine(title: "Principle", text: game.guidingPrinciple, fallback: "Waiting for the speaker's principle")
                PromptLine(title: "Work", text: game.supportingWork, fallback: "Waiting for supporting details")
                PromptLine(title: "Insight", text: game.takeaway, fallback: "Waiting for the final takeaway")
            }
            .padding(26)
        }
        .frame(width: 650, height: 430)
        .rotation3DEffect(Rotation3D(angle: .degrees(20), axis: .x), anchor: .center)
        .rotation3DEffect(Rotation3D(angle: .degrees(270), axis: .y), anchor: .center)
        .offset(y: -converter.convert(1.1, from: .meters))
    }
    
    private var game: SessionState {
        appModel.sessionController?.game ?? SessionState()
    }
    
    private var boardTitle: String {
        switch appModel.sessionController?.localRole {
            case .speaker:
                "Speaker Board"
            case .audience:
                "Audience Board"
            case .none:
                "Pitch Loop VR"
        }
    }
    
    private var boardSymbol: String {
        switch appModel.sessionController?.localRole {
            case .speaker:
                "mic.fill"
            case .audience:
                "person.3.fill"
            case .none:
                "waveform.and.mic"
        }
    }
}

private struct PromptLine: View {
    let title: String
    let text: String
    let fallback: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(text.isEmpty ? fallback : text)
                .foregroundStyle(text.isEmpty ? .secondary : .primary)
        }
    }
}
