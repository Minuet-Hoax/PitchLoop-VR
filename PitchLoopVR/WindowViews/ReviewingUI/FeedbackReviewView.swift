import SwiftUI

struct FeedbackReviewView: View {
    let title: String
    let onBack: () -> Void

    @State private var selectedFilter = ""

    private var filters: [String] {
        switch title {
            case "Eye Contact Feedback":
                ["Too fixed", "Just right", "Avoiding audience"]
            case "Volume Feedback":
                ["Too quiet", "Just right", "Too loud"]
            case "Structure Feedback":
                ["Too short", "Just right", "Too long"]
            default:
                ["Too fast", "Too slow", "Felt just right"]
        }
    }

    private var noteText: String {
        switch title {
            case "Eye Contact Feedback":
                "Your gaze tends to anchor left. Try scanning the full room every 20-30 seconds. The 0:47 and 2:15 flags both occur during Q&A."
            case "Volume Feedback":
                "You dropped in volume near the end of each section. Project through your final sentence before pausing. Flagged at 1:08 and 3:55."
            case "Structure Feedback":
                "Two sections lacked a clear closing before moving on. Add a one-line transition summary between topics. Flagged at 2:02 and 4:10."
            default:
                "You consistently rush at slide transitions. Practice a 1-second pause before each new section. Flagged at 1:14 and 1:32."
        }
    }

    private var dotPositions: [(CGFloat, Bool)] {
        switch title {
            case "Eye Contact Feedback":
                [(0.08, false), (0.29, true), (0.45, false), (0.71, true), (0.88, false)]
            case "Volume Feedback":
                [(0.15, false), (0.34, false), (0.58, true), (0.76, false), (0.91, true)]
            case "Structure Feedback":
                [(0.22, true), (0.43, false), (0.61, true), (0.79, false), (0.95, false)]
            default:
                [(0.10, true), (0.38, false), (0.52, false), (0.67, false), (0.82, false)]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ZStack {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Color.white.opacity(0.15)))
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.primary)
            }

            HStack(spacing: 4) {
                ForEach(filters, id: \.self) { filter in
                    Button(action: { selectedFilter = filter }) {
                        Text(filter)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(selectedFilter == filter ? .white : .primary.opacity(0.7))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(selectedFilter == filter ? Color.blue : Color.clear)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(4)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.white.opacity(0.08)))
            .frame(maxWidth: .infinity, alignment: .center)

            HStack(spacing: 18) {
                ReviewAvatar(label: "Everyone's\nFeed...", initials: nil)
                ReviewAvatar(label: "Lorena\nPazmino", initials: "LP")
                ReviewAvatar(label: "Carnaven\nChiu", initials: "CC")
                ReviewAvatar(label: "Amy\nDeDonato", initials: "AD")
                ReviewAvatar(label: "Jon\nDascola", initials: "JD")
            }
            .frame(maxWidth: .infinity, alignment: .center)

            Text("7 flags across this session. Tap a verdict to filter the timeline, or tap an audience member to see their individual feedback.")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.primary.opacity(0.85))
                .lineSpacing(3)

            VStack(alignment: .leading, spacing: 10) {
                Text("During the session")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.primary)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.22))
                            .frame(height: 4)
                            .padding(.horizontal, 6)

                        ForEach(dotPositions.indices, id: \.self) { i in
                            let (pos, isHighlighted) = dotPositions[i]
                            Circle()
                                .fill(isHighlighted ? Color.red : Color.white)
                                .frame(width: 12, height: 12)
                                .offset(x: pos * (geo.size.width - 12))
                        }
                    }
                }
                .frame(height: 16)

                HStack {
                    Text("0:00")
                    Spacer()
                    Text("0:20")
                    Spacer()
                    Text("0:40")
                    Spacer()
                    Text("1:00")
                }
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white.opacity(0.08)))

            Text("Most flags clustered between 1:14 and 3:42. Your pace accelerated each time you transitioned to a new section.")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white.opacity(0.08)))

            HStack(alignment: .top, spacing: 8) {
                Text("Note:")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
                Text(noteText)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineSpacing(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.teal.opacity(0.55)))

            HStack(spacing: 12) {
                Button(action: {}) {
                    Text("Replay this moment")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary.opacity(0.65))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white.opacity(0.1)))
                }
                .buttonStyle(.plain)

                Button(action: {}) {
                    Text("Practice this ↗")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.blue))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(24)
        .onAppear {
            switch title {
                case "Eye Contact Feedback":
                    selectedFilter = "Too fixed"
                case "Volume Feedback":
                    selectedFilter = "Just right"
                case "Structure Feedback":
                    selectedFilter = "Too long"
                default:
                    selectedFilter = "Too fast"
            }
        }
    }
}

private struct ReviewAvatar: View {
    let label: String
    let initials: String?

    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(Color.white.opacity(0.18))
                .frame(width: 52, height: 52)
                .overlay {
                    if let initials {
                        Text(initials)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                    } else {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.primary)
                    }
                }
            Text(label)
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
}

#Preview {
    FeedbackReviewView(title: "Pacing Feedback", onBack: {})
        .frame(width: 560, height: 680)
        .fixedSize()
}
