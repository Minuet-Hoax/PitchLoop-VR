/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The role-selection view for Pitch Loop VR.
*/

import SwiftUI

struct RoleSelectionView: View {
    @Environment(PitchLoopAppModel.self) var appModel
    
    var body: some View {
        if let sessionController = appModel.sessionController {
            ZStack {
                LinearGradient(
                    colors: [.black.opacity(0.9), .gray.opacity(0.85), .brown.opacity(0.65)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    VStack(spacing: 10) {
                        Text("Choose your preferred role")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                        Text("There can only be one Speaker. Everyone else joins as Audience.")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(spacing: 18) {
                        RoleChoiceButton(
                            title: "Join as Speaker",
                            subtitle: sessionController.canBecomeSpeaker ? "Lead the room, edit the coaching prompts, and drive the practice loop." : "Speaker is already taken in this SharePlay session.",
                            symbolName: "mic.fill",
                            accent: .orange,
                            isDisabled: !sessionController.canBecomeSpeaker
                        ) {
                            sessionController.chooseRole(.speaker)
                        }
                        
                        RoleChoiceButton(
                            title: "Join as Audience",
                            subtitle: "Observe, react, and follow the speaker's flow with a read-only support panel.",
                            symbolName: "person.3.fill",
                            accent: .cyan,
                            isDisabled: false
                        ) {
                            sessionController.chooseRole(.audience)
                        }
                    }
                    .frame(maxWidth: 560)
                    
                    ParticipantSummaryCard(
                        speaker: sessionController.speaker,
                        audience: sessionController.audience,
                        waitingRoom: sessionController.unassignedParticipants
                    )
                }
                .padding(40)
            }
            .pitchLoopToolbar()
        }
    }
}

private struct RoleChoiceButton: View {
    let title: String
    let subtitle: String
    let symbolName: String
    let accent: Color
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 18) {
                Image(systemName: symbolName)
                    .font(.title2.weight(.semibold))
                    .frame(width: 48, height: 48)
                    .background(accent.opacity(0.14), in: Circle())
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.title2.weight(.semibold))
                    Text(subtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.title3.weight(.bold))
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 22)
            .glassBackgroundEffect()
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.55 : 1)
    }
}

private struct ParticipantSummaryCard: View {
    let speaker: ParticipantModel?
    let audience: [ParticipantModel]
    let waitingRoom: [ParticipantModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Joined via SharePlay")
                .font(.headline)
            
            LabeledContent("Speaker") {
                Text(speaker?.displayName ?? "Available")
                    .foregroundStyle(speaker == nil ? .secondary : .primary)
            }
            
            LabeledContent("Audience") {
                Text(audience.isEmpty ? "No one yet" : audience.map(\.displayName).joined(separator: ", "))
                    .foregroundStyle(audience.isEmpty ? .secondary : .primary)
            }
            
            if !waitingRoom.isEmpty {
                LabeledContent("Waiting") {
                    Text(waitingRoom.map(\.displayName).joined(separator: ", "))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: 560)
        .padding(24)
        .glassBackgroundEffect()
    }
}

private extension ParticipantModel {
    var displayName: String {
        name.isEmpty ? "Guest" : name
    }
}
