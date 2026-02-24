# 🚀 Deep Linking Quick Reference

## Creepy Shorts - Fast Setup Guide

---

## 📋 Quick Checklist

### 1️⃣ Android Setup (5 minutes)

```bash
# Get SHA-256 fingerprint
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

✅ Copy SHA-256 fingerprint
✅ Update `web_fallback/.well-known/assetlinks.json`
✅ Upload to: `https://api.creepy-shorts.com/.well-known/assetlinks.json`

### 2️⃣ iOS Setup (5 minutes)

✅ Get Apple Team ID from developer.apple.com
✅ Update `web_fallback/.well-known/apple-app-site-association`
✅ Upload to: `https://api.creepy-shorts.com/.well-known/apple-app-site-association`
✅ Open Xcode → Runner → Signing & Capabilities → Add Associated Domains
✅ Add: `applinks:api.creepy-shorts.com`

### 3️⃣ Web Upload (10 minutes)

Upload these files to your domain:

```
https://api.creepy-shorts.com/
├── .well-known/
│   ├── assetlinks.json
│   └── apple-app-site-association
└── shorts/
    └── index.html (from web_fallback folder)
```

### 4️⃣ Test (5 minutes)

**Android:**

```bash
adb shell am start -W -a android.intent.action.VIEW -d "creepyshorts://shorts/TEST_VIDEO_ID" com.victorsaulmendozamena.creepyshorts
```

**iOS:**

- Open Safari → Type: `creepyshorts://shorts/TEST_VIDEO_ID`

---

## 🔗 Link Formats

### Share Link (HTTPS)

```
https://api.creepy-shorts.com/shorts/VIDEO_ID
```

### Custom Scheme

```
creepyshorts://shorts/VIDEO_ID
```

---

## 🧪 Testing Commands

### Android - Test Custom Scheme

```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "creepyshorts://shorts/67920e5c51d46fa7f99f3dff" \
  com.victorsaulmendozamena.creepyshorts
```

### Android - Test HTTPS Link

```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://api.creepy-shorts.com/shorts/67920e5c51d46fa7f99f3dff" \
  com.victorsaulmendozamena.creepyshorts
```

### Android - Verify Domain

```bash
adb shell pm get-app-links com.victorsaulmendozamena.creepyshorts
```

Expected output: `api.creepy-shorts.com: verified`

---

## 🔍 Verification URLs

### Check Android Asset Links

```
https://api.creepy-shorts.com/.well-known/assetlinks.json
```

### Check iOS AASA

```
https://api.creepy-shorts.com/.well-known/apple-app-site-association
```

### Test Web Fallback

```
https://api.creepy-shorts.com/shorts/test
```

---

## ⚠️ Common Issues & Quick Fixes

| Issue | Solution |
|-------|----------|
| Link opens in browser | Clear app data, reinstall app |
| 404 on assetlinks.json | Check file path & permissions |
| iOS not working | Verify Associated Domains in Xcode |
| Android not verified | Wait 24-48h or check SHA-256 |

---

## 📱 File Locations in Project

```
shorts_streaming_app/
├── android/app/src/main/AndroidManifest.xml  ← Android config
├── ios/Runner/Info.plist                      ← iOS config
├── ios/Runner/Runner.entitlements             ← iOS domains
├── lib/core/services/deep_link_service.dart   ← Deep link handler
├── lib/features/shorts/widgets/share_bottom_sheet.dart  ← Share UI
└── web_fallback/                              ← Upload to server
    ├── index.html
    └── .well-known/
        ├── assetlinks.json
        └── apple-app-site-association
```

---

## 🎯 Production Checklist

Before launching:

- [ ] Replace `YOUR_SHA256_FINGERPRINT_HERE` in assetlinks.json
- [ ] Replace `TEAM_ID` in apple-app-site-association
- [ ] Upload all files to production domain
- [ ] Test on real Android device
- [ ] Test on real iOS device
- [ ] Update Play Store link in web fallback
- [ ] Update App Store link in web fallback
- [ ] Verify domain ownership (24-48h wait time)

---

## 🆘 Need Help?

1. Read full guide: `DEEP_LINKING_SETUP_GUIDE.md`
2. বাংলা গাইড: `DEEP_LINKING_SETUP_BANGLA.md`
3. Test all commands above
4. Check file permissions on server

---

## 📞 Support Resources

- Android App Links: <https://developer.android.com/training/app-links>
- iOS Universal Links: <https://developer.apple.com/ios/universal-links/>
- AASA Validator: <https://branch.io/resources/aasa-validator/>

---

**Total Setup Time: ~30 minutes**

Good luck! 🚀
