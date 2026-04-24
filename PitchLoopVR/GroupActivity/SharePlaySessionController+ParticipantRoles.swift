/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Helpers that expose role-specific participant collections.
*/

import Foundation

extension SharePlaySessionController {
    var localRole: ParticipantModel.Role? {
        localPlayer.role
    }

    var localIsReady: Bool {
        localPlayer.isReady
    }
    
    var audienceCount: Int {
        audience.count
    }

    var readyAudienceCount: Int {
        audience.filter(\.isReady).count
    }
    
    var participantCount: Int {
        players.count
    }
    
    var readyParticipantCount: Int {
        players.values.filter(\.isReady).count
    }
    
    var allParticipantsReady: Bool {
        participantCount > 0 && readyParticipantCount == participantCount
    }
    
    var sessionStartCountdownDeadline: Date? {
        game.sessionStartCountdownDeadline
    }

    var unassignedParticipants: [ParticipantModel] {
        players.values
            .filter { $0.role == nil }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    private var submittedSurveyAudienceIDSet: Set<UUID> {
        Set(game.submittedSurveyAudienceIDs)
    }

    var completedSurveyAudienceCount: Int {
        audience.filter { submittedSurveyAudienceIDSet.contains($0.id) }.count
    }

    var allAudienceSubmittedSurvey: Bool {
        audienceCount > 0 && completedSurveyAudienceCount == audienceCount
    }

    var hasLocalAudienceSubmittedSurvey: Bool {
        guard localRole == .audience else {
            return false
        }

        return submittedSurveyAudienceIDSet.contains(localPlayer.id)
    }
}
