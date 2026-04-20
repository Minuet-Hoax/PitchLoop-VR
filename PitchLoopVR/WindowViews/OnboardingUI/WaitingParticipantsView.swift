import SwiftUI

struct WaitingParticipantsView: View {
    @Environment(PitchLoopAppModel.self) private var appModel

    private var readyParticipantCount: Int {
        appModel.sessionController?.readyParticipantCount ?? 0
    }

    private var participantCount: Int {
        appModel.sessionController?.participantCount ?? 0
    }

    // Keep existing logic: green only when everyone has joined/ready, otherwise red.
    private var statusColor: Color {
        participantCount > 0 && readyParticipantCount == participantCount ? .green : .red
    }

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(statusColor)
                .frame(width: 9, height: 9)
            Text("\(readyParticipantCount) of \(participantCount) participant\(participantCount == 1 ? "" : "s") have joined")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 11)
        .background(Capsule(style: .continuous).fill(Color.white.opacity(0.18)))
        .overlay(Capsule(style: .continuous).stroke(Color.white.opacity(0.2), lineWidth: 1))
        .padding(8)
    }
}

#Preview {
    WaitingParticipantsView()
        .environment(PitchLoopAppModel())
}
