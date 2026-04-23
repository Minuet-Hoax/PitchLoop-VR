# PitchLoopVR
PitchLoopVR is a visionOS SharePlay app for presentation practice. It supports one `Speaker` and up to three `Audience` participants, with role-specific onboarding and synchronized session state.

## Current App Flow
1. Start/join SharePlay from the entry view.
2. In onboarding, each participant selects a role (`Speaker` or `Audience`).
3. Role-specific onboarding UI is shown:
   - Speaker: `SpeakerFeedbackView` → `SpeakerCueInstructionView` → `SpeakerStartSessionView`
   - Audience: `AudienceOnboardingView` → tutorial feedback flow → `AudienceReminderView` → `AudienceReadyView` → `AudienceWaitingView`
4. Speaker starts session only when backend conditions are met (role/assignment/readiness checks).
5. A shared countdown (`SessionStartCountdownView`) appears, then stage switches to speaking.

## Stage Management
- `SessionState.ActivityStage`: `onboarding`, `speaking`, `reviewing`
- `StageManager`: maps backend `ActivityStage` to local stage managers
- `OnboardingStageManager`: controls onboarding screens:
  - `roleSelection`
  - `speakerFeedback`
  - `speakerCueInstruction`
  - `speakerStartSession`
  - `audienceOnboarding`
  - `audienceFeedback`
  - `audienceReminder`
  - `audienceReady`
  - `audienceWaiting`

## Window IDs In Use
- `main`: primary app window
- `audience-feedback`: audience icon-bar window
- `live-question`: feedback question window
- `cue-preview`: speaker cue preview window
- `waiting-participants`: speaker waiting-status pill window

## Immersive Setup
- `PitchLoopImmersiveSpace` declares `ImmersiveSpace(id: "GameSpace")`.
- The immersive scene loads the conference-room model from:
  - `Resources/pitchroomvr.usdc`
- Immersion style is set to full:
  - `.immersionStyle(selection: ..., in: .full)`
- The app opens/dismisses immersive space when session availability changes:
  - open when a SharePlay session is present
  - dismiss when session ends

## 3D Environment Anchoring
- Goal: participants are anchored by the shared 3D environment, not by draggable 2D panels.
- Scene association is configured to avoid automatic window anchoring:
  - `PitchLoopActivity.metadata.sceneAssociationBehavior = .none`
- Spatial persona placement is defined with templates relative to `.app`:
  - `RoleSelectionTemplate` for onboarding/default + role-selection layout
  - `SessionTemplate` for speaking/reviewing layout (1 speaker, up to 3 audience)
- On newer visionOS versions, immersive content applies:
  - `.groupActivityAssociation(.primary("shared-conference-room"))`
  to make the immersive scene the primary SharePlay-associated context.
- Onboarding panels remain participant-local in placement; shared state (roles/countdown/stage) is synchronized through `SharePlaySessionController`.

## Immersive Troubleshooting
- If logs show `Failed to find pitchroomvr.usdc in app bundle`, verify `pitchroomvr.usdc` is included in target **Copy Bundle Resources**.
- If immersive does not appear, check `openImmersiveSpace` result logs (`opened`, `userCancelled`, `error`).

## Project Structure
```text
PitchLoopVR/
  PitchLoopVRApp.swift
  PitchLoopWindow.swift
  WindowViews/
    RootView.swift
    SharePlayEntryView.swift
    Shared/
      ParticipantNameAlert.swift
      PitchLoopToolbar.swift
      SharePlayLauncherButton.swift
      RoleSelectionView.swift
      SessionStartCountdownView.swift
    Stages/
      OnboardingStageView.swift
      SpeakingStageView.swift
      ReviewingStageView.swift
    OnboardingUI/
      SpeakerFeedbackView.swift
      SpeakerCueInstructionView.swift
      SpeakerStartSessionView.swift
      CuePreviewView.swift
      WaitingParticipantsView.swift
      AudienceOnboardingView.swift
      AudienceLiveFeedbackView.swift
      AudienceFeedbackWindow.swift
      FeedbackQuestionView.swift
      AudienceReminderView.swift
      AudienceReadyView.swift
      AudienceWaitingView.swift
  GroupActivity/
    PitchLoopActivity.swift
    SharePlaySessionController.swift
    SharePlaySessionController+Synchronization.swift
    SharePlaySessionController+ParticipantRoles.swift
  Models/
    PitchLoopAppModel.swift
    SessionState.swift
    ParticipantModel.swift
    AudienceFeedbackModel.swift
  StageManagement/
    StageManager.swift
    OnboardingStageManager.swift
    SpeakingStageManager.swift
    ReviewingStageManager.swift
  ImmersiveSpace/
    PitchLoopImmersiveSpace.swift
  SpatialPersonaTemplates/
    RoleSelectionTemplate.swift
    SessionTemplate.swift
  Resources/
    Info.plist
    PitchLoopVR.entitlements
    pitchroomvr.usdc
```

## Backend Rules (Current)
- Only one speaker can be selected.
- Speaker can start session only if:
  - local role is speaker
  - no unassigned participants
  - audience count is in `1...3`
  - all audience participants are ready
- Countdown deadline is synchronized through shared session state.

## Tech Stack
- SwiftUI
- visionOS
- SharePlay / GroupActivities
- Spatial Persona templates
