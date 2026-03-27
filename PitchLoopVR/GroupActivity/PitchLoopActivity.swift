/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The implementation of the Guess Together app's group activity.
*/

import CoreTransferable
import GroupActivities

struct PitchLoopActivity: GroupActivity, Transferable, Sendable {
    var metadata: GroupActivityMetadata = {
        var metadata = GroupActivityMetadata()
        metadata.title = "Pitch Loop VR"
        return metadata
    }()
}
