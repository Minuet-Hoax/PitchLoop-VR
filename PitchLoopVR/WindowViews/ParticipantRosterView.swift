/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Participant roster views for Pitch Loop VR.
*/

import SwiftUI

struct ParticipantRosterView: View {
    var body: some View {
        ParticipantRosterCard()
    }
}

struct ParticipantRosterCard: View {
    @Environment(PitchLoopAppModel.self) var appModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("People in the room")
                .font(.headline)
            
            if let sessionController = appModel.sessionController {
                ForEach(sessionController.orderedParticipants) { player in
                    HStack(spacing: 12) {
                        Image(systemName: player.role?.symbolName ?? "person.crop.circle.badge.questionmark")
                            .foregroundStyle((player.role?.color ?? .secondary).gradient)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(player.name.isEmpty ? "Guest" : player.name)
                                .fontWeight(.semibold)
                            Text(player.role?.name ?? "Waiting for role")
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
            } else {
                Text("Join a SharePlay session to see participants.")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(24)
        .glassBackgroundEffect()
    }
}
