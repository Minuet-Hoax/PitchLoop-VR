# Quick Setup Checklist: crowd-talking-2.mp3

## ✅ Setup Steps

### 1. Add File to Xcode
- [ ] Drag `crowd-talking-2.mp3` from Downloads into `Resources` folder in Xcode
- [ ] Ensure "Copy items if needed" is checked
- [ ] Ensure your app target is selected

### 2. Verify File is Included
- [ ] Select `crowd-talking-2.mp3` in Project Navigator
- [ ] Check File Inspector (right panel) → Target Membership
- [ ] Your app target should be checked

### 3. Verify in Build Phases
- [ ] Select your project in Project Navigator
- [ ] Select your app target
- [ ] Go to Build Phases tab
- [ ] Expand "Copy Bundle Resources"
- [ ] Confirm `crowd-talking-2.mp3` is listed

## 🎵 Current Configuration

**File name**: `crowd-talking-2.mp3`

**Code has been updated** in `PitchLoopImmersiveSpace.swift` to use this filename.

**Audio positions**: 5 sources around the room
- Left side: (-2.0, 1.0, -3.0)
- Right side: (2.0, 1.0, -3.0)  
- Center back: (0.0, 1.0, -4.0)
- Front left: (-1.5, 1.0, -2.0)
- Front right: (1.5, 1.0, -2.0)

**Volume**: 0.2 (quiet background)
**Looping**: Yes
**Auto-start**: When immersive space opens

## 🧪 Testing

1. Build and run your app
2. Start/join a SharePlay session
3. Enter the immersive space
4. You should hear ambient crowd talking from multiple directions
5. Turn your head to hear the spatial audio effect

## 🔧 Adjusting Settings

### To change volume:
In `PitchLoopImmersiveSpace.swift`, line ~91:
```swift
volume: 0.2,  // Try values between 0.1 (quieter) and 0.5 (louder)
```

### To add/remove positions:
Modify the `audiencePositions` array in `setupAudienceAmbience()`

### To stop audio:
```swift
appModel.audioManager.stopAllAmbientAudio()
```

## 🐛 Troubleshooting

**If you don't hear audio:**

1. Check Console logs for:
   - "Audio session configured for spatial playback" ✅
   - "Created positioned ambient audio" (should see 5 times) ✅
   - "Failed to find audio file" ❌ (means file not found)

2. If you see "Failed to find audio file":
   - Verify file is in Resources folder
   - Check spelling: `crowd-talking-2.mp3`
   - Confirm it's in Copy Bundle Resources
   - Clean build folder (Product → Clean Build Folder)
   - Rebuild

3. Check device volume is not muted

4. Test on actual Vision Pro hardware (spatial audio may not work in simulator)

## 📝 Notes

- The same audio file is played from all 5 positions
- This creates a surround-sound effect
- Audio automatically loops seamlessly
- Audio starts when immersive space opens
- Audio stops when immersive space closes
