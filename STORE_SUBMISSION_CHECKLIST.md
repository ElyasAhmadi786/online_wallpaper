# Play Store / App Store Submission Checklist

## Already Completed in Codebase
- [x] Replaced placeholder Android applicationId/namespace with production ID.
- [x] Replaced placeholder iOS bundle identifier with production ID.
- [x] Removed Android cleartext traffic flag (HTTPS-only).
- [x] Removed legacy Android external storage permissions from manifest.
- [x] Removed debug signing from Android release build config.
- [x] Removed hardcoded API key from source code (uses `PEXELS_API_KEY` via `--dart-define`).
- [x] Fixed iOS app display name typo.
- [x] Added privacy policy document (`PRIVACY_POLICY.md`).

## Required Before Release (Publisher Console / Local Signing)

### Android (Google Play)
- [ ] Create release keystore and configure signing (`key.properties`, release signingConfig).
- [ ] Build signed Android App Bundle (`.aab`).
- [ ] Upload app icon, feature graphic, screenshots, and store listing texts.
- [ ] Complete Data safety form in Play Console based on actual data handling.
- [ ] Provide and publish a privacy policy URL in Play Console.
- [ ] Fill content rating, target audience, and app access declarations.
- [ ] If using third-party APIs, ensure terms/license compliance (Pexels attribution/usage terms).

### iOS (App Store Connect)
- [ ] Set Apple Developer Team and signing certificate/profile.
- [ ] Archive and upload build from Xcode.
- [ ] Add screenshots, app description, keywords, and support URL.
- [ ] Add privacy policy URL in App Store Connect.
- [ ] Complete App Privacy questionnaire.
- [ ] Verify age rating, content rights, and export compliance.

## Release Commands
- Runtime/build API key injection:
  - `--dart-define=PEXELS_API_KEY=YOUR_KEY`
