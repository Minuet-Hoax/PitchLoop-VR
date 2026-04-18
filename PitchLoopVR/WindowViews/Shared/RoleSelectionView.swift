/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The role-selection panel for Pitch Loop VR.
*/

import SwiftUI

enum UserRole: String {
    case speaker = "Speaker"
    case audience = "Audience"
}

struct RoleSelectionView: View {
    let onNavigate: (UserRole) -> Void
    @State private var selectedRole: UserRole?

    var body: some View {
        VStack(spacing: 54) {
            Text("Choose your preferred Role")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            VStack(spacing: 26) {
                RoleButton(
                    title: "Join as Speaker",
                    isSelected: selectedRole == .speaker
                ) {
                    selectedRole = .speaker
                    onNavigate(.speaker)
                }

                RoleButton(
                    title: "Join as Audience",
                    isSelected: selectedRole == .audience
                ) {
                    selectedRole = .audience
                    onNavigate(.audience)
                }
            }
        }
        .frame(maxWidth: 520)
        .padding()
    }
}

private struct RoleButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 34)
            .frame(width: 350, height: 60)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? Color.blue : Color.white.opacity(0.28))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.white.opacity(isSelected ? 0.0 : 0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
