# PitchLoopVR
PitchLoopVR is a visionOS SharePlay app for presentation practice. It supports one `Speaker` and up to three `Audience` participants, with role-specific onboarding and synchronized session state.

## Overview

PitchVR Loop adapts an Apple SharePlay sample into a presentation practice experience. One participant acts as the speaker, while the rest join as audience members. The app uses a shared session so real people can observe a presentation, send feedback, and support a more realistic communication practice environment.
The core idea is to help speakers improve both during and after a presentation through live audience participation, lightweight in-session nudges, and post-presentation reflection.

> Note: This project’s Shareplay feature started from templates demonstrated in WWDC24 session [10201: Customize spatial Persona templates in SharePlay](https://developer.apple.com/videos/play/wwdc2024/10201).

## Roles

### Speaker

The speaker presents inside the session, receives live nudges during the presentation, and reviews audience feedback afterward.

### Audience

Audience members are real users in the SharePlay session. They observe, send real-time feedback, and contribute post-presentation reflections.

## Current Product Direction

### Real-Time Audience Feedback

- Audience members can send feedback while the presentation is happening.
- Feedback is delivered live to help the speaker adjust in the moment.
- The experience keeps real users in the loop instead of relying only on automated scoring.

### In-Presentation Nudges

- Small notifications appear during the presentation.
- Nudges are designed to guide the speaker without interrupting flow.
- These prompts may focus on pacing, clarity, confidence, or engagement.

### Simulated Pressure Environment

To make practice more realistic, later versions may include:

- Audience ambiance
- Coughing
- Phone ringing
- Environment-specific pressure sounds

### Post-Presentation Reflection

After the presentation, the speaker receives feedback in areas such as:

- `Clarity of Argument`
- `Organization and Structure`
- `Tone and Pacing`
- `Confidence and Persuasiveness`

## Future Directions

To make practice more realistic, later versions may include:

- AI-generated audience behavior,
- adaptive interview simulations,
- public speaking anxiety coaching,
- classroom integration,
- recruiter and mentor feedback rooms,
- and communication training for industries like healthcare, leadership, and sales.

## Current Onboarding Flow
1. Start/join SharePlay from the entry view.
2. In onboarding, each participant selects a role (`Speaker` or `Audience`).
3. Role-specific onboarding UI is shown:
   - Speaker: `SpeakerFeedbackView` → `SpeakerCueInstructionView` → `SpeakerStartSessionView`
   - Audience: `AudienceOnboardingView` → tutorial feedback flow → `AudienceReminderView` → `AudienceReadyView` → `AudienceWaitingView`
   - Both roles see different panels and interactions tailored to their responsibilities.
4. Speaker starts session only when backend conditions are met (role/assignment/readiness checks).
5. A shared countdown (`SessionStartCountdownView`) appears, then stage switches to speaking.

## Backend Rules (Current)
- Only one speaker can be selected.
- Speaker can start session only if:
  - local role is speaker
  - no unassigned participants
  - audience count is in `1...3`
  - all audience participants are ready
- Countdown deadline is synchronized through shared session state.

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
- Goal: participants are anchored by the shared 3D environment.
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

## Tech Stack
- SwiftUI
- visionOS
- SharePlay / GroupActivities
- Spatial Persona templates
