import SwiftUI

enum SessionChoice: String, Sendable {
    case yes
    case no
}

struct PostSessionSurveyView: View {
    @Binding var mainPointChoice: SessionChoice?
    @Binding var confidenceChoice: SessionChoice?
    let onClose: () -> Void
    let onSubmit: () -> Void

    private var canSubmit: Bool {
        mainPointChoice != nil && confidenceChoice != nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text("Session Ended")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Could you follow the speaker's main\npoint?")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)

                    HStack(spacing: 10) {
                        ChoiceButton(
                            title: "Yes",
                            isSelected: mainPointChoice == .yes
                        ) {
                            mainPointChoice = .yes
                        }

                        ChoiceButton(
                            title: "No",
                            isSelected: mainPointChoice == .no
                        ) {
                            mainPointChoice = .no
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Did the speaker come across as\nconfident?")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)

                    HStack(spacing: 10) {
                        ChoiceButton(
                            title: "Yes",
                            isSelected: confidenceChoice == .yes
                        ) {
                            confidenceChoice = .yes
                        }

                        ChoiceButton(
                            title: "No",
                            isSelected: confidenceChoice == .no
                        ) {
                            confidenceChoice = .no
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            Button(action: onSubmit) {
                Text("Submit Feedback")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white.opacity(canSubmit ? 1.0 : 0.85))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        Capsule()
                            .fill(canSubmit ? Color.blue : Color(white: 0.35, opacity: 0.9))
                    )
            }
            .buttonStyle(.plain)
            .disabled(!canSubmit)
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
        .frame(width: 420)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.thickMaterial)
                .overlay(RoundedRectangle(cornerRadius: 24).fill(Color.black.opacity(0.22)))
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.3), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.22), radius: 30, y: 10)
    }
}

struct FeedbackSubmittedWaitingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.green)
                    .frame(width: 72, height: 72)
                    .shadow(color: .green.opacity(0.4), radius: 18)
                Image(systemName: "checkmark")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.top, 24)

            Text("Feedback Submitted")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)

            Text("Waiting for speaker to view scorecard together")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white.opacity(0.95))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.bottom, 28)
        .frame(width: 420)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.thickMaterial)
                .overlay(RoundedRectangle(cornerRadius: 24).fill(Color.black.opacity(0.22)))
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.3), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.22), radius: 30, y: 10)
    }
}

private struct ChoiceButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white.opacity(isSelected ? 1.0 : 0.8))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    Capsule()
                        .fill(isSelected ? .blue : Color(white: 0.35, opacity: 0.82))
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 24) {
        PostSessionSurveyView(mainPointChoice: .constant(nil), confidenceChoice: .constant(nil), onClose: {}, onSubmit: {})
        FeedbackSubmittedWaitingView()
    }
}
