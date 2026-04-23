/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The implementation of Pitch Loop VR's group activity.
*/

import CoreTransferable
import GroupActivities

struct PitchLoopActivity: GroupActivity, Transferable, Sendable {
    var metadata: GroupActivityMetadata = {
        var metadata = GroupActivityMetadata()
        metadata.title = "Pitch Loop VR"

        // Avoid using a shared window/volume as the automatic scene anchor.
        // This keeps each participant's panels independent while sharing app state.
        metadata.sceneAssociationBehavior = .none

        return metadata
    }()
}
