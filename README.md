# Wild Sakartvelo

Wild Sakartvelo is an offline-first SwiftUI iOS app for children to explore Georgian nature through short missions, journal rewards, parent tools, accessibility settings, and downloadable media packs.

## Project Overview

- 4 ecosystems: Borjomi Forest, Caucasus Mountains, Kolkheti Wetlands, Black Sea Coast
- 24 animals
- 12 plants
- 20 missions
- all 5 activity types: multiple choice, matching, classification, sequencing, habitat placement
- local profiles and saved progress
- bilingual English and Georgian content
- offline content packs for optional audio and media
- parent dashboard with an adult gate
- journal and reward collection

## Architecture

- `WildSakartvelo/App`: app state, tab flow, launch routing
- `WildSakartvelo/Core/Models`: content, profiles, settings, progress, packs
- `WildSakartvelo/Core/Services`: content loading, progress, unlocks, audio, downloads
- `WildSakartvelo/Core/Components`: shared UI components and error states
- `WildSakartvelo/Features`: explore, missions, journal, parent, settings, onboarding, downloads
- `WildSakartvelo/Resources/Content`: bundled JSON content
- `WildSakartvelo/Resources/Localization`: English and Georgian strings
- `WildSakartvelo/PrivacyInfo.xcprivacy`: App Store privacy manifest for required-reason APIs
- `WildSakartveloTests`: unit tests
- `WildSakartveloUITests`: basic UI tests

## Supported iOS

- iOS 17.0

## Setup

1. Open `WildSakartvelo.xcodeproj` in Xcode 16 or newer.
2. Select the `WildSakartvelo` scheme.
3. Pick an iPhone simulator.
4. Run the app.

## Simulator Build

```bash
xcodebuild \
  -project WildSakartvelo.xcodeproj \
  -scheme WildSakartvelo \
  -sdk iphonesimulator \
  -configuration Debug \
  CODE_SIGNING_ALLOWED=NO \
  build
```

## Test Command

```bash
xcodebuild test \
  -project WildSakartvelo.xcodeproj \
  -scheme WildSakartvelo \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

If `iPhone 16` is unavailable, use another installed simulator name.

## Offline Content

The app bundles essential JSON content locally so missions work without a network connection. Optional ecosystem media can be downloaded later through the Offline Content screen. Downloads are stored outside the app bundle and tracked locally per profile-independent pack state.

## Apple Product Readiness

- privacy manifest declares local `UserDefaults` persistence and disk-space checks for offline packs
- no tracking domains, analytics SDKs, or collected-data categories are declared
- universal iPhone and iPad target with portrait-only iPhone and all iPad orientations
- English and Georgian are registered as project localizations
- App Store Connect still needs the final bundle identifier, team signing, privacy policy URL, age rating, screenshots, and review metadata

## Known Limitations

- only selected content has narration audio
- some images still fall back to SF Symbols
- offline packs use bundled development fallback files when no remote source is provided
- no cloud sync
- no teacher dashboard
- no multiplayer
- no speech recognition
- no production analytics

## Future Improvements

- expand original artwork coverage
- add more narration and accessibility audio
- add richer offline pack metadata
- deepen ecosystem progression and replay variety
- add backend-backed sync only if the product scope grows in that direction
