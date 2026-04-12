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

    static let panelDistance: Double = 2.5

    let elements: [any SpatialTemplateElement] = [
        .seat(position: .app.offsetBy(x: -1.6, z: 2.5), role: Role.speaker),
        .seat(position: .app.offsetBy(x: -2.1, z: 2.2), role: Role.speaker),
        .seat(position: .app.offsetBy(x: 0, z: panelDistance)),
        .seat(position: .app.offsetBy(x: 0.75, z: panelDistance)),
        .seat(position: .app.offsetBy(x: -0.75, z: panelDistance)),
        .seat(position: .app.offsetBy(x: 1.4, z: panelDistance)),
        .seat(position: .app.offsetBy(x: -1.4, z: panelDistance)),
        .seat(position: .app.offsetBy(x: 1.6, z: 2.5), role: Role.audience),
        .seat(position: .app.offsetBy(x: 2.1, z: 2.2), role: Role.audience),
        .seat(position: .app.offsetBy(x: 2.6, z: 1.9), role: Role.audience),
        .seat(position: .app.offsetBy(x: 3.1, z: 1.6), role: Role.audience),
        .seat(position: .app.offsetBy(x: 3.6, z: 1.3), role: Role.audience)
    ]
}
