# Audience Murmuring Audio Setup Guide

## Overview
Your PitchLoopVR app now has positioned ambient audio sources that create a realistic audience atmosphere. Multiple audio sources are placed around the conference room to simulate audience members quietly talking before a presentation.

## 📁 Where to Add Your Audio File

1. **Add to Resources folder**: 
   - Drag your audio file into the `Resources` folder in Xcode
   - File should be named: `audience-murmur.mp3` (or update the name in code)

2. **Ensure it's included in your target**:
   - Select the audio file in Xcode
   - Check the **Target Membership** in the File Inspector (right panel)
   - Make sure your app target is checked

3. **Verify in Build Phases**:
   - Select your project target
   - Go to **Build Phases** → **Copy Bundle Resources**
   - Confirm `audience-murmur.mp3` is listed there

## 🎵 Getting Audience Murmur Audio

### Option 1: Free Resources
- **Freesound.org**: Search for "crowd murmur", "audience chatter", "cafe ambience"
  - [Freesound.org](https://freesound.org)
  - Look for Creative Commons licensed files
  
- **YouTube Audio Library**: Search for ambient crowd sounds
  
- **BBC Sound Effects**: Free sound effects archive
  - [BBC Sound Effects](https://sound-effects.bbcrewind.co.uk/)

### Option 2: Premium Resources
- **Epidemic Sound**: High-quality ambient audio
- **AudioJungle**: Professional sound effects
- **Artlist**: Curated audio library

### Recommended Search Terms:
- "audience murmur"
- "crowd chatter quiet"
- "conference room ambience"
- "people talking background"
- "lobby atmosphere"
- "walla" (industry term for background crowd noise)

## 🎚️ Audio Specifications

### Recommended Format:
- **Format**: MP3, WAV, or M4A
- **Sample Rate**: 44.1 kHz or 48 kHz
- **Bit Depth**: 16-bit or higher
- **Channels**: Mono (preferred for spatial audio) or Stereo
- **Duration**: 30-60 seconds minimum (it will loop seamlessly)

### Audio Characteristics:
- **Volume**: Should be naturally quiet (you can adjust in code)
- **Content**: Indistinct conversation, no clear words
- **Quality**: Seamless loop (no obvious start/end)
- **Tone**: Professional/neutral (avoid laughter or specific emotions)

## 🔧 Current Implementation

The audio is positioned in 5 locations around your conference room:

```swift
let audiencePositions = [
    ("audience-left", SIMD3(x: -2.0, y: 1.0, z: -3.0)),      // Left side
    ("audience-right", SIMD3(x: 2.0, y: 1.0, z: -3.0)),      // Right side
    ("audience-center", SIMD3(x: 0.0, y: 1.0, z: -4.0)),     // Center back
    ("audience-front-left", SIMD3(x: -1.5, y: 1.0, z: -2.0)), // Front left
    ("audience-front-right", SIMD3(x: 1.5, y: 1.0, z: -2.0))  // Front right
]
```

### Adjusting Positions:
You can modify these positions in `PitchLoopImmersiveSpace.swift` to match your room layout:
- **X**: Left (-) to Right (+)
- **Y**: Down (-) to Up (+), typically around 1.0-1.5m for seated audience
- **Z**: Forward (+) to Back (-), negative values are away from user

### Adjusting Volume:
Current volume is set to `0.2` (quiet background). Adjust in the code:

```swift
volume: 0.2,  // Range: 0.0 (silent) to 1.0 (full volume)
```

## 🎮 Controlling the Audio

### Stop All Audience Sounds:
```swift
appModel.audioManager.stopAllAmbientAudio()
```

### Stop Specific Source:
```swift
appModel.audioManager.stopAmbientAudio(identifier: "audience-left")
```

### Adjust Volume:
```swift
appModel.audioManager.setAmbientVolume(0.3, for: "audience-center")
```

## 💡 Pro Tips

1. **Seamless Looping**: Use audio editing software (Audacity, GarageBand) to create seamless loops by cross-fading the end with the beginning

2. **Multiple Variations**: Consider using slightly different audio files for each position to avoid obvious repetition:
   ```swift
   resourceName: "audience-murmur-\(variationNumber)"
   ```

3. **Dynamic Volume**: Adjust volume based on app stage:
   - Louder during onboarding (0.3)
   - Quieter during speaking stage (0.15)
   - Can fade out during critical moments

4. **Test in Device**: Spatial audio sounds different in the simulator vs actual hardware. Test on Vision Pro for best results.

## 🚀 Quick Start

**Minimal setup to get started:**

1. Download a free audience murmur sound from Freesound.org
2. Convert/export as `audience-murmur.mp3`
3. Drag into `Resources` folder in Xcode
4. Build and run - audio will automatically play when immersive space opens!

## 🔍 Troubleshooting

**No audio playing:**
- Check Console for "Failed to find audio file" messages
- Verify file is in Copy Bundle Resources
- Check audio file format is supported (MP3, WAV, M4A)
- Ensure audio session is configured (happens automatically)

**Audio too loud/quiet:**
- Adjust `volume` parameter in `setupAudienceAmbience()`
- Try values between 0.1 (very quiet) and 0.5 (moderate)

**Audio not spatial:**
- Verify positions are set correctly
- Test by walking around in the immersive space
- Make sure you're using `createPositionedAmbientAudio()` not `playAmbientAudio()`

**Audio cuts off:**
- Make sure `loops: true` is set
- Check audio file duration (should be at least 10-15 seconds)
