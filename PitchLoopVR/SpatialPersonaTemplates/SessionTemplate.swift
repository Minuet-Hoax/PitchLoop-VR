/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The spatial template used to arrange participants during speaking and reviewing.
*/

import GroupActivities
import Spatial

struct SessionTemplate: SpatialTemplate {
    enum Role: String, SpatialTemplateRole {
        case speaker
        case audience
    }

    var elements: [any SpatialTemplateElement] {
        let speakerSeat = SpatialTemplateSeatElement(
            position: .app.offsetBy(x: 0, z: 1.8),
            direction: .lookingAt(.app),
            role: Role.speaker
        )

        let audienceSeats: [any SpatialTemplateElement] = [
            .seat(
                position: .app.offsetBy(x: -2.3, z: 2.0),
                direction: .lookingAt(speakerSeat),
                role: Role.audience
            ),
            .seat(
                position: .app.offsetBy(x: 2.3, z: 2.0),
                direction: .lookingAt(speakerSeat),
                role: Role.audience
            ),
            .seat(
                position: .app.offsetBy(x: 0, z: 4.0),
                direction: .lookingAt(speakerSeat),
                role: Role.audience
            )
        ]

        return [speakerSeat] + audienceSeats
    }
}
