/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The custom spatial template used to arrange spatial Personas
  during Guess Together's game stage.
*/

import GroupActivities
import Spatial

struct GameTemplate: SpatialTemplate {
    enum Role: String, SpatialTemplateRole {
        case speaker
        case audience
    }
    
    static let speakerPosition = Point3D(x: 0, z: 2.5)
    
    var elements: [any SpatialTemplateElement] {
        let speakerSeat = SpatialTemplateSeatElement(
            position: .app.offsetBy(x: Self.speakerPosition.x, z: Self.speakerPosition.z),
            direction: .lookingAt(.app),
            role: Role.speaker
        )
        
        let audienceSeats: [any SpatialTemplateElement] = [
            .seat(
                position: .app.offsetBy(x: -1.8, z: 4.5),
                direction: .lookingAt(speakerSeat),
                role: Role.audience
            ),
            .seat(
                position: .app.offsetBy(x: 1.8, z: 4.5),
                direction: .lookingAt(speakerSeat),
                role: Role.audience
            ),
            .seat(position: .app.offsetBy(x: 0, z: 5.2), role: Role.audience),
            .seat(position: .app.offsetBy(x: -3, z: 5.6), role: Role.audience),
            .seat(position: .app.offsetBy(x: 3, z: 5.6), role: Role.audience),
            .seat(position: .app.offsetBy(x: -1.4, z: 6.1), role: Role.audience),
            .seat(position: .app.offsetBy(x: 1.4, z: 6.1), role: Role.audience)
        ]
        
        return [speakerSeat] + audienceSeats
    }
}
