import SwiftUI

struct LiveFeedbackItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let description: String
}

struct AudienceLiveFeedbackView: View {
    @Environment(AudienceFeedbackModel.self) private var feedbackModel
    @Binding var hoveredItem: LiveFeedbackItem?
    var onSelect: (LiveFeedbackItem) -> Void = { _ in }

    private var visibleItems: [LiveFeedbackItem] {
        if feedbackModel.isTutorialMode {
            let index = min(max(feedbackModel.tutorialStep, 0), audienceFeedbackItems.count - 1)
            return [audienceFeedbackItems[index]]
        }

        return audienceFeedbackItems
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(visibleItems) { item in
                let isHovered = hoveredItem?.id == item.id

                VStack(spacing: 5) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(isHovered ? 0.18 : 0))
                            .frame(width: 68, height: 68)
                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(width: 68, height: 68)
                            .opacity(isHovered ? 1 : 0)
                        Image(systemName: item.icon)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(isHovered ? Color.blue : Color.primary.opacity(0.85))
                    }
                    .frame(width: 68, height: 68)

                    Text(item.label)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
                .onHover { hovering in
                    guard !feedbackModel.isTutorialMode else {
                        return
                    }

                    withAnimation(.easeInOut(duration: 0.15)) {
                        hoveredItem = hovering ? item : nil
                    }
                }
                .onTapGesture {
                    guard !feedbackModel.isTutorialMode else {
                        return
                    }

                    onSelect(item)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(
            Capsule(style: .continuous)
                .fill(Color.white.opacity(0.08))
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.15), value: hoveredItem?.id)
    }
}

#Preview {
    AudienceLiveFeedbackView(hoveredItem: .constant(nil))
        .environment(AudienceFeedbackModel())
        .padding(16)
        .frame(width: 380)
}
