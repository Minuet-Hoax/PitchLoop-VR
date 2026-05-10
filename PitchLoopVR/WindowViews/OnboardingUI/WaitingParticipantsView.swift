import SwiftUI

struct WaitingParticipantsView: View {
    @Environment(PitchLoopAppModel.self) private var appModel

    private var readyAudienceCount: Int {
        appModel.sessionController?.readyAudienceCount ?? 0
    }

    private var audienceCount: Int {
        appModel.sessionController?.audienceCount ?? 0
    }

    private var statusColor: Color {
        audienceCount > 0 && readyAudienceCount == audienceCount ? .green : .red
    }

    private var readinessText: String {
        let audienceLabel = audienceCount == 1 ? "audience" : "audiences"
        let verb = audienceCount == 1 ? "is" : "are"
        return "\(readyAudienceCount) of \(audienceCount) \(audienceLabel) \(verb) ready"
    }

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(statusColor)
                .frame(width: 9, height: 9)
            Text(readinessText)
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
