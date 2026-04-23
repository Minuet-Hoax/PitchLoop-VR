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

    let elements: [any SpatialTemplateElement] = [
        // Default placement before role selection.
        .seat(position: .app.offsetBy(x: 0, z: 2.4)),
        .seat(position: .app.offsetBy(x: -1.2, z: 2.8)),
        .seat(position: .app.offsetBy(x: 1.2, z: 2.8)),
        .seat(position: .app.offsetBy(x: 0, z: 3.2)),

        // Role-based placement after selecting a role.
        .seat(position: .app.offsetBy(x: 0, z: 1.8), role: Role.speaker),
        .seat(position: .app.offsetBy(x: -2.3, z: 2.0), role: Role.audience),
        .seat(position: .app.offsetBy(x: 2.3, z: 2.0), role: Role.audience),
        .seat(position: .app.offsetBy(x: 0, z: 4.0), role: Role.audience)
    ]
}
