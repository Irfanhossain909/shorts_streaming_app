# ✅ Action Checklist - Deep Linking Setup
## Creepy Shorts App

এই checklist follow করুন step by step। প্রতিটি step complete হলে checkbox tick করুন।

---

## 📋 Pre-Setup (5 minutes)

- [ ] Git এ current changes commit করেছেন
- [ ] Backup নিয়েছেন project এর
- [ ] Development environment ready আছে
- [ ] Android Studio/Xcode installed আছে
- [ ] Server access আছে (cPanel/SSH)

---

## 🤖 Android Setup (10 minutes)

### Step 1: SHA-256 Fingerprint

- [ ] Terminal open করেছেন
- [ ] এই command চালিয়েছেন:
  ```bash
  keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
  ```
- [ ] SHA-256 fingerprint কপি করেছেন (looks like: `14:6D:E9:83:...`)
- [ ] File খুলেছেন: `web_fallback/.well-known/assetlinks.json`
- [ ] `YOUR_SHA256_FINGERPRINT_HERE` replace করেছেন actual fingerprint দিয়ে
- [ ] File save করেছেন

### Step 2: Release Keystore (Production এর জন্য)

- [ ] Release keystore এর SHA-256 বের করেছেন:
  ```bash
  keytool -list -v -keystore /path/to/release.keystore -alias your_alias
  ```
- [ ] `assetlinks.json` এ release fingerprint ও add করেছেন
- [ ] File save করেছেন

---

## 🍎 iOS Setup (15 minutes)

### Step 1: Apple Team ID

- [ ] Browser এ https://developer.apple.com open করেছেন
- [ ] Sign in করেছেন
- [ ] **Membership** section এ গিয়েছেন
- [ ] **Team ID** কপি করেছেন (looks like: `ABCD1234EF`)

### Step 2: Update AASA File

- [ ] File খুলেছেন: `web_fallback/.well-known/apple-app-site-association`
- [ ] `TEAM_ID` replace করেছেন actual Team ID দিয়ে (2 জায়গায়)
- [ ] File save করেছেন

### Step 3: Xcode Configuration

- [ ] Xcode open করেছেন
- [ ] `ios/Runner.xcworkspace` খুলেছেন (not .xcodeproj)
- [ ] **Runner** target select করেছেন (left sidebar)
- [ ] **Signing & Capabilities** tab এ click করেছেন
- [ ] **+ Capability** button click করেছেন
- [ ] **Associated Domains** খুঁজে select করেছেন
- [ ] এই domains add করেছেন:
  - [ ] `applinks:api.creepy-shorts.com`
  - [ ] `applinks:www.api.creepy-shorts.com`
- [ ] Xcode build করে দেখেছেন error নেই
- [ ] Xcode close করেছেন

---

## 🌐 Web Server Setup (20 minutes)

### Step 1: File Preparation

- [ ] `web_fallback` folder find করেছেন project এ
- [ ] Folder এর সব content check করেছেন:
  - [ ] `index.html`
  - [ ] `.well-known/assetlinks.json`
  - [ ] `.well-known/apple-app-site-association`

### Step 2: Update Store Links

- [ ] `web_fallback/index.html` খুলেছেন
- [ ] Play Store link এর line খুঁজেছেন (~line 137)
- [ ] URL verify করেছেন: `https://play.google.com/store/apps/details?id=com.victorsaulmendozamena.creepyshorts`
- [ ] App Store link এর line খুঁজেছেন (~line 145)
- [ ] `YOUR_APP_ID` replace করবেন actual App Store ID দিয়ে (published হলে)
- [ ] File save করেছেন

### Step 3: Server Upload

**Option A: cPanel File Manager**

- [ ] cPanel login করেছেন
- [ ] **File Manager** open করেছেন
- [ ] `public_html` folder এ গিয়েছেন
- [ ] `.well-known` folder তৈরি করেছেন (যদি না থাকে)
- [ ] `.well-known` folder এ ঢুকেছেন
- [ ] Upload করেছেন:
  - [ ] `assetlinks.json`
  - [ ] `apple-app-site-association` (no extension!)
- [ ] Back করে `public_html` এ ফিরেছেন
- [ ] `shorts` folder তৈরি করেছেন
- [ ] `shorts` folder এ `index.html` upload করেছেন

**Option B: FTP**

- [ ] FTP client open করেছেন (FileZilla/WinSCP)
- [ ] Server এ connect করেছেন
- [ ] `public_html` or root directory তে গিয়েছেন
- [ ] `.well-known` folder তৈরি করেছেন
- [ ] `.well-known` এ files upload করেছেন
- [ ] `shorts` folder তৈরি করেছেন
- [ ] `shorts` এ `index.html` upload করেছেন

### Step 4: Verify File Permissions

- [ ] `.well-known` folder permission: `755`
- [ ] `assetlinks.json` permission: `644`
- [ ] `apple-app-site-association` permission: `644`
- [ ] `shorts` folder permission: `755`
- [ ] `index.html` permission: `644`

### Step 5: Verify Files Are Accessible

Browser এ এই URLs open করে check করুন:

- [ ] https://api.creepy-shorts.com/.well-known/assetlinks.json
  - [ ] JSON দেখাচ্ছে (browser error না)
  - [ ] আপনার SHA-256 আছে
  
- [ ] https://api.creepy-shorts.com/.well-known/apple-app-site-association
  - [ ] JSON দেখাচ্ছে
  - [ ] আপনার Team ID আছে
  
- [ ] https://api.creepy-shorts.com/shorts/test
  - [ ] Beautiful landing page দেখাচ্ছে
  - [ ] Logo, buttons সব আছে

---

## 🧪 Testing - Android (15 minutes)

### Preparation

- [ ] Android device/emulator চালু আছে
- [ ] USB debugging enabled করেছেন
- [ ] Device computer এ connected আছে
- [ ] Terminal open করেছেন
- [ ] `adb devices` run করে device দেখাচ্ছে

### Test 1: App Installation

- [ ] Android Studio থেকে app install করেছেন
- [ ] App manually open করে চেক করেছেন
- [ ] Shorts tab এ কিছু videos আছে

### Test 2: Custom Scheme

Terminal এ run করুন (VIDEO_ID replace করুন):

```bash
adb shell am start -W -a android.intent.action.VIEW -d "creepyshorts://shorts/VIDEO_ID" com.victorsaulmendozamena.creepyshorts
```

- [ ] Command চালিয়েছেন
- [ ] App open হয়েছে
- [ ] Shorts screen দেখাচ্ছে
- [ ] Video navigate করছে (যদি valid ID হয়)

### Test 3: HTTPS Link

```bash
adb shell am start -W -a android.intent.action.VIEW -d "https://api.creepy-shorts.com/shorts/VIDEO_ID" com.victorsaulmendozamena.creepyshorts
```

- [ ] Command চালিয়েছেন
- [ ] App open হয়েছে
- [ ] Shorts screen দেখাচ্ছে

### Test 4: Domain Verification

```bash
adb shell pm get-app-links com.victorsaulmendozamena.creepyshorts
```

- [ ] Command চালিয়েছেন
- [ ] Output এ `api.creepy-shorts.com: verified` দেখাচ্ছে
  - [ ] যদি না দেখায়, 24-48 ঘন্টা wait করতে হবে

### Test 5: Share Functionality

- [ ] App এ Shorts video play করছে
- [ ] Share button tap করেছেন
- [ ] Bottom sheet open হয়েছে
- [ ] Video thumbnail এবং title দেখাচ্ছে
- [ ] "Copy Link" button tap করেছেন
- [ ] Link clipboard এ copy হয়েছে
- [ ] Link paste করে check করেছেন format সঠিক আছে

### Test 6: Web Fallback (Browser Test)

- [ ] Chrome browser open করেছেন Android এ
- [ ] Address bar এ টাইপ করেছেন: `https://api.creepy-shorts.com/shorts/test`
- [ ] Landing page load হয়েছে
- [ ] "Open in App" button দেখাচ্ছে
- [ ] Button tap করেছেন
- [ ] App open হওয়ার চেষ্টা করছে

---

## 🧪 Testing - iOS (15 minutes)

### Preparation

- [ ] iPhone/iPad ready আছে
- [ ] Device computer এ connected আছে
- [ ] Xcode open করেছেন
- [ ] App build করে device এ install করেছেন

### Test 1: Custom Scheme (Safari)

- [ ] iPhone এ Safari open করেছেন
- [ ] Address bar এ টাইপ করেছেন: `creepyshorts://shorts/VIDEO_ID`
- [ ] Go/Enter press করেছেন
- [ ] "Open in Creepy Shorts?" prompt দেখাচ্ছে
- [ ] "Open" tap করেছেন
- [ ] App open হয়েছে

### Test 2: Universal Link

- [ ] Safari এ নতুন tab open করেছেন
- [ ] টাইপ করেছেন: `https://api.creepy-shorts.com/shorts/VIDEO_ID`
- [ ] Page load হচ্ছে
- [ ] App install থাকলে automatically open হওয়ার চেষ্টা করছে

### Test 3: Notes App Test

- [ ] Notes app open করেছেন
- [ ] New note তৈরি করেছেন
- [ ] Link টাইপ করেছেন: `https://api.creepy-shorts.com/shorts/test`
- [ ] Link এ tap করেছেন
- [ ] App open হয়েছে অথবা Safari এ page open হয়েছে

### Test 4: Share Functionality

- [ ] App এ Shorts video play করছে
- [ ] Share button tap করেছেন
- [ ] Bottom sheet open হয়েছে সঠিকভাবে
- [ ] "Copy Link" tap করেছেন
- [ ] Link copied হয়েছে
- [ ] Messages/Notes এ paste করে verify করেছেন

### Test 5: AASA Validation

Browser এ open করুন:
https://branch.io/resources/aasa-validator/

- [ ] Site খুলেছেন
- [ ] Input box এ টাইপ করেছেন: `api.creepy-shorts.com`
- [ ] "Validate" click করেছেন
- [ ] ✅ Valid দেখাচ্ছে
- [ ] Your app ID match করছে

---

## 📱 Cross-Platform Testing (10 minutes)

### Share Flow Complete Test

**Device 1 (Sender):**
- [ ] App open করেছেন
- [ ] Video play করছে
- [ ] Share → WhatsApp select করেছেন
- [ ] Contact select করেছেন
- [ ] Link send করেছেন

**Device 2 (Receiver - App Installed):**
- [ ] WhatsApp message receive করেছেন
- [ ] Link এ tap করেছেন
- [ ] App directly open হয়েছে
- [ ] Video play হচ্ছে

**Device 3 (Receiver - App NOT Installed):**
- [ ] WhatsApp message receive করেছেন
- [ ] Link এ tap করেছেন
- [ ] Browser এ landing page open হয়েছে
- [ ] "Download" button দেখাচ্ছে
- [ ] Correct store button দেখাচ্ছে (Play Store/App Store)

---

## 🔍 Final Verification (10 minutes)

### Android Verification

- [ ] Custom scheme কাজ করছে
- [ ] HTTPS links কাজ করছে
- [ ] Share functionality perfect
- [ ] Domain verified (or will be in 24-48h)
- [ ] Web fallback accessible

### iOS Verification

- [ ] Custom scheme কাজ করছে
- [ ] Universal links কাজ করছে
- [ ] Share functionality perfect
- [ ] Associated Domains configured
- [ ] AASA file valid

### Web Verification

- [ ] assetlinks.json accessible
- [ ] apple-app-site-association accessible
- [ ] Landing page perfect
- [ ] Auto-detect OS working
- [ ] Store links working

### Documentation

- [ ] Setup guide পড়েছেন
- [ ] Testing commands try করেছেন
- [ ] Known issues note করেছেন

---

## 🚀 Production Release (Final Steps)

### Before Publishing

- [ ] সব tests pass করেছে
- [ ] Domain verified (24-48h wait করেছেন)
- [ ] Release build test করেছেন
- [ ] Store links updated করেছেন
- [ ] Privacy policy updated করেছেন (যদি লাগে)

### Play Store Release

- [ ] APK/AAB build করেছেন
- [ ] Release notes এ deep linking feature mention করেছেন
- [ ] Screenshots updated করেছেন (যদি লাগে)
- [ ] Upload করেছেন Play Console এ

### App Store Release

- [ ] IPA build করেছেন
- [ ] Associated Domains entitlement আছে
- [ ] Release notes এ feature mention করেছেন
- [ ] Upload করেছেন App Store Connect এ

---

## 📊 Post-Launch Monitoring

### First Week

- [ ] Deep link opens track করছেন
- [ ] Share button clicks monitor করছেন
- [ ] Web fallback visits check করছেন
- [ ] User feedback পাচ্ছেন
- [ ] Crash reports check করছেন

### Analytics Setup (Optional)

- [ ] Firebase/Analytics integrated করেছেন
- [ ] Deep link events track করছেন
- [ ] Share events track করছেন
- [ ] Conversion tracking setup করেছেন

---

## ✅ Completion Summary

**Total Time Required:** ~2 hours

**Breakdown:**
- Pre-setup: 5 min
- Android setup: 10 min
- iOS setup: 15 min
- Web setup: 20 min
- Android testing: 15 min
- iOS testing: 15 min
- Cross-platform test: 10 min
- Final verification: 10 min
- Production release: 20 min

---

## 🎉 Congratulations!

যদি সব checkboxes tick করা থাকে, তাহলে:

✅ Deep linking সম্পূর্ণভাবে configured
✅ Share functionality working perfectly
✅ Web fallback ready
✅ Production ready

**Next:** Launch করুন এবং users কে amazing experience দিন! 🚀

---

## 📞 Need Help?

যদি কোন step এ আটকে যান:

1. সেই step এর details `DEEP_LINKING_SETUP_GUIDE.md` এ দেখুন
2. `DEEP_LINKING_SETUP_BANGLA.md` পড়ুন বাংলায় বুঝতে
3. `DEEP_LINKING_QUICK_REFERENCE.md` এ quick solution খুঁজুন
4. Troubleshooting section check করুন

---

**Domain:** api.creepy-shorts.com
**Status:** Ready to Launch 🎊

Good luck! 🌟
