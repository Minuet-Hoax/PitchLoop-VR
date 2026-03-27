# PitchVR Loop

## Summary

PitchVR Loop is a communication support tool for Apple Vision Pro built with Xcode, SwiftUI, SharePlay, and visionOS spatial features. The project starts from an Apple SharePlay sample and is being adapted into a presentation practice experience where one speaker presents to a live audience in a shared session.

The goal is to help speakers improve communication skills in real time and through post-session reflection, using both live audience participation and Apple platform capabilities that fit naturally into visionOS.

## Core Session Flow

1. A user launches the app and starts a SharePlay session to invite other participants.
2. Participants join the shared session.
3. Each participant takes a role:
   - `Speaker`: only one participant can be the speaker.
   - `Audience`: all other participants join as audience members.
4. After role selection:
   - The speaker enters a speaker-specific view.
   - Audience members enter an audience-specific view.
5. The speaker and audience see different panels, controls, and interactions based on their roles.

## Users

### Speaker

The speaker is the presenting user. This person delivers the presentation, receives live nudges during the session, and reviews feedback after the presentation ends.

### Audience

Audience members are real users connected through SharePlay. They observe the presentation, send feedback during the session, and provide reflections afterward.

## Key Product Idea

PitchVR Loop is designed to simulate a presentation environment while keeping real people in the loop. Instead of relying only on automated coaching, it combines live audience presence with lightweight in-session guidance so the speaker can practice under more realistic conditions.

## Current Feature Direction

### 1. Real User Feedback Through SharePlay

- Real audience members join the session through SharePlay.
- Audience members can select feedback to send while the presentation is happening.
- Feedback is delivered in real time to support the speaker.

### 2. In-Presentation Nudges

- Small notifications appear while the speaker is presenting.
- Nudges are meant to guide the speaker without breaking flow.
- The intent is to help the speaker improve in the moment rather than only afterward.

Possible examples include reminders about pacing, clarity, confidence, or audience engagement.

### 3. Post-Presentation Feedback

After the presentation ends, the speaker receives feedback from the audience focused on:

- `Clarity of Argument`: whether ideas were understandable and easy to follow.
- `Organization and Structure`: whether the presentation had a strong and logical flow.
- `Tone and Pacing`: whether delivery style and rhythm supported the message.
- `Confidence and Persuasiveness`: based on signals such as volume, eye contact, and hand gestures.

## Planned Future Features

### Simulated Pressure Environment

The experience may later include environmental pressure cues to make practice sessions feel more realistic.

Potential additions:

- Realistic ambient audience audio
- Coughing
- Phone ringing
- General crowd ambiance
- Sound variations based on the chosen environment

### Real Audience Interaction

Future versions may also allow more active audience behavior, such as:

- Asking questions during the presentation
- Interrupting the speaker in controlled ways

## Apple Platform Opportunities

This project is a strong fit for Apple technologies including:

- `SwiftUI` for role-based interfaces and window content
- `SharePlay` and `GroupActivities` for synchronized multi-user sessions
- `visionOS` spatial UI patterns for immersive presentation support
- Spatial Persona templates for shared presence and presentation context
- Other Apple frameworks that can support feedback, interaction design, and immersive coaching flows as the product evolves

## Product Goal

The long-term goal is to help people become stronger communicators by giving them a realistic, shared, and supportive practice environment inside Apple Vision Pro.
