/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view modifier that presents an alert that asks for the participant's name.
*/

import SwiftUI

struct ParticipantNameAlertModifier: ViewModifier {
    @Environment(PitchLoopAppModel.self) var appModel
    @State var playerName = ""
    
    func body(content: Content) -> some View {
        @Bindable var appModel = appModel
        
        content
            .alert("What's your name?", isPresented: $appModel.showPlayerNameAlert) {
                TextField("Name", text: $playerName).textContentType(.givenName)
                Button("Join!") {
                    appModel.playerName = playerName
                }
            } message: {
                Text("This name is shown to the other participants in your SharePlay session.")
            }
    }
}

// A convenience custom modifier wrapper.
extension View {
    func participantNameAlert() -> some View {
        modifier(ParticipantNameAlertModifier())
    }
}
