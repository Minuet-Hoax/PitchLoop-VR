import SwiftUI

struct AudienceFeedbackPanel: View {
    enum ModalPresentation {
        case overlay
        case ornament
    }

    @State private var selectedFeedback: FeedbackType?
    let onSelectFeedback: (FeedbackType, FeedbackOption) -> Void
    var onFeedbackSent: () -> Void = {}
    var modalPresentation: ModalPresentation = .overlay
    var pillBottomPadding: CGFloat = 28
    var overlayModalBottomInset: CGFloat = 180
    var forcedSelectedFeedback: FeedbackType? = nil
    var isInteractionEnabled: Bool = true
    var showsModalCloseButton: Bool = true

    private var currentSelectedFeedback: FeedbackType? {
        forcedSelectedFeedback ?? selectedFeedback
    }

    var body: some View {
        Group {
            switch modalPresentation {
                case .overlay:
                    ZStack(alignment: .bottom) {
                        modalContent
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.bottom, pillBottomPadding + overlayModalBottomInset)

                        BottomFeedbackPill(
                            selectedFeedback: currentSelectedFeedback,
                            isInteractionEnabled: isInteractionEnabled && forcedSelectedFeedback == nil,
                            onTap: { type in
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                    selectedFeedback = selectedFeedback == type ? nil : type
                                }
                            }
                        )
                        .padding(.bottom, pillBottomPadding)
                    }
                case .ornament:
                    Color.clear
                        .overlay(alignment: .bottom) {
                            BottomFeedbackPill(
                                selectedFeedback: currentSelectedFeedback,
                                isInteractionEnabled: isInteractionEnabled && forcedSelectedFeedback == nil,
                                onTap: { type in
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                        selectedFeedback = selectedFeedback == type ? nil : type
                                    }
                                }
                            )
                            .padding(.bottom, pillBottomPadding)
                        }
                        .ornament(attachmentAnchor: .scene(.top), contentAlignment: .bottom) {
                            modalContent
                        }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: currentSelectedFeedback?.id)
    }

    @ViewBuilder
    private var modalContent: some View {
        if let type = currentSelectedFeedback {
            FeedbackModal(
                type: type,
                onSelect: { option in
                    guard isInteractionEnabled else {
                        return
                    }

                    onSelectFeedback(type, option)
                    withAnimation(.easeOut(duration: 0.2)) {
                        selectedFeedback = nil
                    }
                    onFeedbackSent()
                },
                onClose: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        selectedFeedback = nil
                    }
                },
                isInteractionEnabled: isInteractionEnabled,
                showsCloseButton: showsModalCloseButton
            )
            .fixedSize(horizontal: false, vertical: true)
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
        }
    }
}

#Preview {
    AudienceFeedbackPanel(onSelectFeedback: { _, _ in })
}

private struct BottomFeedbackPill: View {
    let selectedFeedback: FeedbackType?
    let isInteractionEnabled: Bool
    let onTap: (FeedbackType) -> Void

    var body: some View {
        HStack(spacing: 16) {
            ForEach(FeedbackType.allCases) { type in
                PillButton(
                    type: type,
                    isActive: selectedFeedback == type,
                    isInteractionEnabled: isInteractionEnabled,
                    onTap: {
                        onTap(type)
                    }
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.thickMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.black.opacity(0.18))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                )
        )
    }
}

private struct PillButton: View {
    let type: FeedbackType
    let isActive: Bool
    let isInteractionEnabled: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            Button(action: onTap) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(.white)
                        .frame(width: 56, height: 56)
                        .overlay(
                            Circle()
                                .stroke(isActive ? Color.blue : Color.clear, lineWidth: 2.5)
                        )

                    Text(type.emoji)
                        .font(.system(size: 28))
                        .baselineOffset(1)
                        .frame(width: 56, height: 56, alignment: .center)

                    if isActive {
                        ZStack {
                            Circle()
                                .fill(.blue)
                                .frame(width: 18, height: 18)
                            Image(systemName: "info")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .offset(x: 4, y: -4)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(!isInteractionEnabled)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isActive)

            if isActive {
                Text(type.rawValue)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .transition(.opacity)
            }
        }
        .frame(minHeight: 72)
    }
}

private struct FeedbackModal: View {
    let type: FeedbackType
    let onSelect: (FeedbackOption) -> Void
    let onClose: () -> Void
    let isInteractionEnabled: Bool
    let showsCloseButton: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 64, height: 64)
                    Text(type.emoji)
                        .font(.system(size: 30))
                        .baselineOffset(1)
                        .frame(width: 64, height: 64, alignment: .center)
                }
                .padding(.top, 32)
                .padding(.bottom, 16)

                Text(type.sheetQuestion)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                VStack(spacing: 10) {
                    ForEach(type.options) { option in
                        OptionButton(
                            label: option.label,
                            isEnabled: isInteractionEnabled,
                            onTap: {
                                onSelect(option)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
            }
            .frame(width: 380)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.thickMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.22))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
            )

            if showsCloseButton {
                Button(action: onClose) {
                    ZStack {
                        Circle()
                            .fill(.thickMaterial)
                            .overlay(
                                Circle().fill(Color.black.opacity(0.28))
                            )
                            .frame(width: 28, height: 28)
                        Image(systemName: "xmark")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(.plain)
                .padding(12)
                .disabled(!isInteractionEnabled)
            }
        }
    }
}

private struct OptionButton: View {
    let label: String
    let isEnabled: Bool
    let onTap: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white.opacity(isPressed ? 1.0 : 0.85))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.thickMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isPressed ? Color.blue : Color(white: 0.35, opacity: 0.88))
                        )
                )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard isEnabled else {
                        return
                    }
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}
