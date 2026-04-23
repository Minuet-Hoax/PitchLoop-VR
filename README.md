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
  - `audienceReminder`
  - `audienceReady`
  - `audienceWaiting`

## Window IDs In Use
- `main`: primary app window
- `speaking-stage`: speaker-only overlay window for `SpeakerFeedbackOverlay`
- `onboarding-cue-preview`: auxiliary cue preview window shown during `SpeakerCueInstructionView`

## Speaking Stage Data Stored For Reviewing
- Primary persisted dataset: `FeedbackStore.feedbackHistory: [FeedbackMessage]`
  - Populated when audience submits feedback via `submitAudienceFeedback(...)`.
  - Also populated from remote participants via SharePlay message sync.
  - Each `FeedbackMessage` includes: `id`, `type`, `notificationText`, `sentAt`, `senderID`, `senderName`.
- Ephemeral speaking-only dataset: `FeedbackStore.pendingFeedback`
  - Used only for live speaker banners in `SpeakerFeedbackOverlay`.
  - Cleared when presentation ends and when stage transitions to `reviewing`.
- Synchronization/catch-up behavior:
  - `FeedbackMessage` events are sent in real time.
  - `FeedbackHistoryMessage` sends full `feedbackHistory` to newly joined participants.
- Lifecycle/reset rules:
  - Entering a new speaking stage clears both `pendingFeedback` and `feedbackHistory`.
  - Transition `speaking -> reviewing` preserves `feedbackHistory` and clears only `pendingFeedback`.
  - Session reset/invalidation clears both arrays.
- Current reviewing-stage UI note:
  - `ReviewingStageView` is currently a placeholder (`Color.clear`), so stored history is ready but not yet rendered.

## Speaking Stage Structure
- `SpeakingStageView` (speaker main panel) opens `speaking-stage` window.
- `SpeakingStageWindowView` hosts `SpeakerFeedbackOverlay` for speaker cue banners.
- `AudienceSpeakingMainPanelView` hosts `AudienceFeedbackPanel` (ornament modal flow) for audience input.
- Data flow:
  - Audience taps feedback -> `SharePlaySessionController.submitAudienceFeedback(...)`
  - Store + sync -> `FeedbackStore` and SharePlay messenger
  - Speaker overlay renders from `feedbackStore.pendingFeedback`

## Immersive Setup
- `PitchLoopImmersiveSpace` declares `ImmersiveSpace(id: "GameSpace")`.
- The immersive scene loads the conference-room model from:
  - `Resources/pitchroomvr.usdz` (with `pitchroomvr.usdc` fallback)
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
  README.md
  PitchLoopVR/
    PitchLoopVRApp.swift
    PitchLoopWindow.swift
    WindowViews/
      RootView.swift
      SharePlayEntryView.swift
      Shared/
        ParticipantNameAlert.swift
        SharePlayLauncherButton.swift
        SessionStartCountdownView.swift
        RoleSelectionView.swift
      Stages/
        OnboardingStageView.swift
        ReviewingStageView.swift
        SpeakingStageView.swift
        SpeakingStageWindowView.swift
        AudienceSpeakingMainPanelView.swift
      OnboardingUI/
        AudienceOnboardingView.swift
        AudienceReadyView.swift
        AudienceReminderView.swift
        AudienceWaitingView.swift
        CuePreviewView.swift
        SpeakerFeedbackView.swift
        SpeakerCueInstructionView.swift
        SpeakerStartSessionView.swift
        WaitingParticipantsView.swift
      SpeakingUI/
        FeedbackModels.swift
        AudienceFeedbackPanel.swift
        SpeakerFeedbackOverlay.swift
    ImmersiveSpace/
      PitchLoopImmersiveSpace.swift
    Models/
      PitchLoopAppModel.swift
      SessionState.swift
      ParticipantModel.swift
    GroupActivity/
      PitchLoopActivity.swift
      SharePlaySessionController.swift
      SharePlaySessionController+Synchronization.swift
      SharePlaySessionController+ParticipantRoles.swift
    SpatialPersonaTemplates/
      RoleSelectionTemplate.swift
      SessionTemplate.swift
    Utilities/
      Publisher+withPrevious.swift
    Resources/
      PitchLoopVR.entitlements
      Info.plist
      pitchroomvroriginal.usdc
      pitchroomvr.usdz
    StageManagement/
      StageManager.swift
      OnboardingStageManager.swift
      SpeakingStageManager.swift
      ReviewingStageManager.swift
  Configuration/
    SampleCode.xcconfig
  LICENSE/
    LICENSE.txt
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
