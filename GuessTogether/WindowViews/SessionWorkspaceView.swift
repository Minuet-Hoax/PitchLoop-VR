/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Role-specific session views for Pitch Loop VR.
*/

import SwiftUI

struct ScoreBoardView: View {
    @Environment(AppModel.self) var appModel
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    
    @State private var showResetConfirmation = false
    
    var body: some View {
        if let sessionController = appModel.sessionController {
            Group {
                switch sessionController.localRole {
                    case .speaker:
                        SpeakerWorkspaceView()
                    case .audience:
                        AudienceWorkspaceView()
                    case .none:
                        CategorySelectionView()
                }
            }
            .guessTogetherToolbar()
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if !appModel.isImmersiveSpaceOpen {
                        Button("Open Space", systemImage: "mountain.2.fill") {
                            Task {
                                await openImmersiveSpace(id: GameSpace.spaceID)
                            }
                        }
                    }
                    
                    Button("Reset Room", systemImage: "arrow.counterclockwise") {
                        showResetConfirmation = true
                    }
                }
            }
            .confirmationDialog("Reset the room for everyone?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
                Button("Reset Room", role: .destructive) {
                    sessionController.resetSession()
                }
            }
        }
    }
}

private struct SpeakerWorkspaceView: View {
    @Environment(AppModel.self) var appModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                HStack(alignment: .top, spacing: 24) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Speaker Console")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                        
                        CoachingEditorCard(
                            title: "Project Name",
                            prompt: "How do you want to frame this pitch?",
                            text: binding(\.pitchTitle),
                            axis: .horizontal
                        )
                        
                        CoachingEditorCard(
                            title: "Define Question",
                            prompt: "What are you trying to solve or explain?",
                            text: binding(\.coreQuestion),
                            axis: .vertical
                        )
                        
                        CoachingEditorCard(
                            title: "Set the Principle",
                            prompt: "What is the guiding idea or criteria behind your decision?",
                            text: binding(\.guidingPrinciple),
                            axis: .vertical
                        )
                        
                        CoachingEditorCard(
                            title: "Show Your Work",
                            prompt: "What proof, examples, or reasoning should the room hear next?",
                            text: binding(\.supportingWork),
                            axis: .vertical
                        )
                        
                        CoachingEditorCard(
                            title: "Wrap with Insights",
                            prompt: "What key takeaway or ask should the audience remember?",
                            text: binding(\.takeaway),
                            axis: .vertical
                        )
                    }
                    .frame(width: max(geometry.size.width * 0.58, 420), alignment: .topLeading)
                    
                    VStack(spacing: 20) {
                        SessionStatusCard()
                        ParticipantRosterCard()
                    }
                    .frame(width: max(geometry.size.width * 0.28, 260), alignment: .top)
                }
                .padding(28)
            }
        }
    }
    
    private func binding(_ keyPath: WritableKeyPath<GameModel, String>) -> Binding<String> {
        Binding(
            get: {
                appModel.sessionController?.game[keyPath: keyPath] ?? ""
            },
            set: { newValue in
                guard let sessionController = appModel.sessionController else {
                    return
                }
                
                var game = sessionController.game
                game[keyPath: keyPath] = newValue
                sessionController.game = game
            }
        )
    }
}

private struct AudienceWorkspaceView: View {
    @Environment(AppModel.self) var appModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                HStack(alignment: .top, spacing: 24) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Audience View")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                        
                        AudiencePromptCard(
                            title: "Define Question",
                            icon: "scope",
                            text: game.coreQuestion,
                            fallback: "Wait for the speaker to define the question."
                        )
                        AudiencePromptCard(
                            title: "Set the Principle",
                            icon: "brain.head.profile",
                            text: game.guidingPrinciple,
                            fallback: "The speaker has not shared the guiding principle yet."
                        )
                        AudiencePromptCard(
                            title: "Show Your Work",
                            icon: "hands.clap.fill",
                            text: game.supportingWork,
                            fallback: "No supporting examples or evidence have been added yet."
                        )
                        AudiencePromptCard(
                            title: "Wrap with Insights",
                            icon: "eye.fill",
                            text: game.takeaway,
                            fallback: "The final takeaway will appear here."
                        )
                        
                        if let sessionController = appModel.sessionController,
                           sessionController.canBecomeSpeaker {
                            Button("Become Speaker", systemImage: "mic.fill") {
                                sessionController.chooseRole(.speaker)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .frame(width: max(geometry.size.width * 0.58, 420), alignment: .topLeading)
                    
                    VStack(spacing: 20) {
                        SessionStatusCard()
                        ParticipantRosterCard()
                    }
                    .frame(width: max(geometry.size.width * 0.28, 260), alignment: .top)
                }
                .padding(28)
            }
        }
    }
    
    private var game: GameModel {
        appModel.sessionController?.game ?? GameModel()
    }
}

private struct CoachingEditorCard: View {
    let title: String
    let prompt: String
    let text: Binding<String>
    let axis: Axis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            Text(prompt)
                .foregroundStyle(.secondary)
            
            if axis == .horizontal {
                TextField("Start typing…", text: text)
                    .textFieldStyle(.roundedBorder)
                    .font(.title3)
            } else {
                TextEditor(text: text)
                    .frame(minHeight: 120)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
            }
        }
        .padding(22)
        .glassBackgroundEffect()
    }
}

private struct AudiencePromptCard: View {
    let title: String
    let icon: String
    let text: String
    let fallback: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 42, height: 42)
                .background(.white.opacity(0.12), in: Circle())
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                Text(text.isEmpty ? fallback : text)
                    .foregroundStyle(text.isEmpty ? .secondary : .primary)
            }
            Spacer()
        }
        .padding(22)
        .glassBackgroundEffect()
    }
}

private struct SessionStatusCard: View {
    @Environment(AppModel.self) var appModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Room Status")
                .font(.headline)
            Text(roomTitle)
                .font(.title3.weight(.semibold))
            Text(statusCopy)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .glassBackgroundEffect()
    }
    
    private var roomTitle: String {
        let title = appModel.sessionController?.game.pitchTitle ?? ""
        return title.isEmpty ? "Untitled practice room" : title
    }
    
    private var statusCopy: String {
        if let speakerName = appModel.sessionController?.speaker?.name, !speakerName.isEmpty {
            return "\(speakerName) is currently the speaker."
        }
        
        return "Speaker role is still available."
    }
}
