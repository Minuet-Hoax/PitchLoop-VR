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
            position: .app.offsetBy(x: 0, z: 2.5),
            direction: .lookingAt(.app),
            role: Role.speaker
        )

        let audienceSeats: [any SpatialTemplateElement] = [
            .seat(
                position: .app.offsetBy(x: -1.4, z: 3.6),
                direction: .lookingAt(speakerSeat),
                role: Role.audience
            ),
            .seat(
                position: .app.offsetBy(x: 1.4, z: 3.6),
                direction: .lookingAt(speakerSeat),
                role: Role.audience
            ),
            .seat(position: .app.offsetBy(x: 0, z: 4.3), role: Role.audience),
            .seat(position: .app.offsetBy(x: -2.3, z: 4.7), role: Role.audience),
            .seat(position: .app.offsetBy(x: 2.3, z: 4.7), role: Role.audience),
            .seat(position: .app.offsetBy(x: -1.1, z: 5.1), role: Role.audience),
            .seat(position: .app.offsetBy(x: 1.1, z: 5.1), role: Role.audience)
        ]

        return [speakerSeat] + audienceSeats
    }
}
