# PitchVR Loop
PitchVR Loop is a communication support tool for Apple Vision Pro built with Xcode, SwiftUI, SharePlay, and visionOS spatial features.

## Overview

PitchVR Loop adapts an Apple SharePlay sample into a presentation practice experience. One participant acts as the speaker, while the rest join as audience members. The app uses a shared session so real people can observe a presentation, send feedback, and support a more realistic communication practice environment.
The core idea is to help speakers improve both during and after a presentation through live audience participation, lightweight in-session nudges, and post-presentation reflection.

> Note: This project started from concepts demonstrated in WWDC24 session [10201: Customize spatial Persona templates in SharePlay](https://developer.apple.com/videos/play/wwdc2024/10201).

## Core Session Flow

1. A user launches the app and starts a SharePlay session.
2. Other participants join through SharePlay.
3. Participants select a role:
   - `Speaker`: only one participant can be the speaker.
   - `Audience`: all other participants join as audience members.
4. After role selection:
   - The speaker enters a speaker-only view.
   - Audience members enter an audience-only view.
5. Both roles see different panels and interactions tailored to their responsibilities.

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

### Post-Presentation Reflection

After the presentation, the speaker receives feedback in areas such as:

- `Clarity of Argument`
- `Organization and Structure`
- `Tone and Pacing`
- `Confidence and Persuasiveness`

## Future Directions

### Simulated Pressure Environment

To make practice more realistic, later versions may include:

- Audience ambiance
- Coughing
- Phone ringing
- Environment-specific pressure sounds

### Active Audience Interaction

Future audience interactions may include:

- Asking questions during the presentation
- Interrupting in controlled ways

## Technology

This project is built around Apple platform technologies including:

- `SwiftUI`
- `visionOS`
- `SharePlay`
- `GroupActivities`
- Spatial Persona templates

## Goal

The long-term goal is to help people become stronger communicators by giving them a realistic, shared, and supportive practice environment inside Apple Vision Pro.

