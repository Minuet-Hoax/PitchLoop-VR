import SwiftUI

struct SessionStartCountdownView: View {
    let deadline: Date

    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.25)) { context in
            let count = countdownValue(now: context.date, deadline: deadline)
            VStack(spacing: 12) {
                Text("Session Start In")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.secondary)

                Text("\(count)")
                    .font(.system(size: 96, weight: .bold))
                    .foregroundStyle(.primary)
                    .id(count)
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 1.4).combined(with: .opacity),
                            removal: .scale(scale: 0.6).combined(with: .opacity)
                        )
                    )
                    .animation(.easeInOut(duration: 0.25), value: count)
            }
            .padding(60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func countdownValue(now: Date, deadline: Date) -> Int {
        max(Int(ceil(deadline.timeIntervalSince(now))), 1)
    }
}

#Preview {
    SessionStartCountdownView(deadline: .now.addingTimeInterval(3))
}
