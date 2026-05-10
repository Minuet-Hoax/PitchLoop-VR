import SwiftUI

struct SpeakerScorecardView: View {
    let onBack: () -> Void
    let onReview: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 12) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color.white.opacity(0.15)))
                }
                .buttonStyle(.plain)

                Text("Check out your score card")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.primary)
            }

            HStack {
                HStack(spacing: 14) {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.primary)
                        )
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pitch Feedback")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                        Text("Review each area to improve your next pitch")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                HStack(spacing: 8) {
                    Text("4:32")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule(style: .continuous).fill(Color.red))
                    Text("Session time")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.white.opacity(0.1)))

            HStack(spacing: 12) {
                SummaryScoreCard(
                    title: "Main Point",
                    rating: "Good",
                    ratingColor: .green,
                    audience: "3/4 audiences"
                )
                SummaryScoreCard(
                    title: "Confidence",
                    rating: "Mixed",
                    ratingColor: Color(red: 0.85, green: 0.65, blue: 0.1),
                    audience: "2/4 audiences"
                )
            }

            HStack(spacing: 12) {
                FeedbackDetailCard(
                    title: "Pace",
                    description: "You are rushing through key points",
                    icon: "waveform",
                    notificationCount: 7,
                    onReview: { onReview("Pacing Feedback") }
                )
                FeedbackDetailCard(
                    title: "Eye Contact",
                    description: "Gaze is too fixed on one area of the room",
                    icon: "eye",
                    notificationCount: 7,
                    onReview: { onReview("Eye Contact Feedback") }
                )
                FeedbackDetailCard(
                    title: "Volume",
                    description: "Volume level was well calibrated throughout",
                    icon: "speaker.wave.2",
                    notificationCount: 7,
                    onReview: { onReview("Volume Feedback") }
                )
                FeedbackDetailCard(
                    title: "Structure",
                    description: "Some sections lacked a clear narrative flow",
                    icon: "clock",
                    notificationCount: 7,
                    onReview: { onReview("Structure Feedback") }
                )
            }
        }
        .padding(24)
    }
}

private struct SummaryScoreCard: View {
    let title: String
    let rating: String
    let ratingColor: Color
    let audience: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
            Text(rating)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(ratingColor)
            Text(audience)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.white.opacity(0.1)))
    }
}

private struct FeedbackDetailCard: View {
    let title: String
    let description: String
    let icon: String
    let notificationCount: Int
    let onReview: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
                Text(description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Circle()
                .fill(Color.white.opacity(0.9))
                .frame(width: 52, height: 52)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.blue)
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)

            Spacer()

            HStack(spacing: 6) {
                Circle()
                    .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                    .frame(width: 12, height: 12)
                Text("\(notificationCount) notifications")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 12)

            Divider()

            Button(action: onReview) {
                Text("Review Feedback")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.white.opacity(0.1)))
    }
}

#Preview {
    SpeakerScorecardView(onBack: {}, onReview: { _ in })
        .frame(width: 780, height: 560)
        .fixedSize()
}
