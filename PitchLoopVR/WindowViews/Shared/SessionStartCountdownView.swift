import SwiftUI

struct SessionStartCountdownView: View {
    let deadline: Date

    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.25)) { context in
            VStack(spacing: 12) {
                Text("Session Start In")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)

                Text(countdownValue(now: context.date, deadline: deadline))
                    .font(.system(size: 54, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 520, height: 200)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func countdownValue(now: Date, deadline: Date) -> String {
        let remaining = max(Int(ceil(deadline.timeIntervalSince(now))), 1)
        return "\(remaining)"
    }
}

#Preview {
    SessionStartCountdownView(deadline: .now.addingTimeInterval(3))
}
