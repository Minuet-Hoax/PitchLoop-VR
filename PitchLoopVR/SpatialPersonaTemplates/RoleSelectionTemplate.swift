/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The spatial template used to arrange participants during role selection.
*/

import GroupActivities
import Spatial

struct RoleSelectionTemplate: SpatialTemplate {
    enum Role: String, SpatialTemplateRole {
        case speaker
        case audience
    }

    var elements: [any SpatialTemplateElement] {
        let speakerSeat = SpatialTemplateSeatElement(
            position: .app.offsetBy(x: 5.2, z: 0.4),
            role: Role.speaker
        )

        let defaultSeats: [any SpatialTemplateElement] = [
            // Default placement before role selection: line up across x axis at z = 2.
            .seat(position: .app.offsetBy(x: 0, z: 2)),
            .seat(position: .app.offsetBy(x: -0.8, z: 2)),
            .seat(position: .app.offsetBy(x: 0.8, z: 2)),
            .seat(position: .app.offsetBy(x: 1.6, z: 2))
        ]

        let audienceSeats: [any SpatialTemplateElement] = [
            .seat(
                position: .app.offsetBy(x: 4.2, z: 1.2),
                direction: .lookingAt(speakerSeat),
                role: Role.audience
            ),
            .seat(
                position: .app.offsetBy(x: -6, z: 2),
                direction: .lookingAt(speakerSeat),
                role: Role.audience
            ),
            .seat(
                position: .app.offsetBy(x: -4, z: 2),
                direction: .lookingAt(speakerSeat),
                role: Role.audience
            )
        ]

        return defaultSeats + [speakerSeat] + audienceSeats
    }
}
