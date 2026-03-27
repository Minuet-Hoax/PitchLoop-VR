/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Implementation for the Guess Together view modifier.
*/

import SwiftUI

struct GuessTogetherToolbarModifier: ViewModifier {
    @Environment(AppModel.self) var appModel
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "waveform.and.mic")
                            .foregroundStyle(.orange.gradient)
                        Text("Pitch Loop VR")
                    }
                    .font(.largeTitle)
                }
                
            }
            .toolbarRole(.navigationStack)
    }
}

// A convenience custom modifier wrapper.
extension View {
    func guessTogetherToolbar() -> some View {
        return modifier(GuessTogetherToolbarModifier())
    }
}
