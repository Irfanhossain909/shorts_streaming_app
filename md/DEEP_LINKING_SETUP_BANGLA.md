# 🔗 Deep Linking ও Share Setup গাইড (বাংলা)
## Creepy Shorts App - সম্পূর্ণ Implementation

এই গাইড আপনাকে সাহায্য করবে আপনার Creepy Shorts app এর জন্য deep linking এবং sharing functionality সেটআপ করতে। Domain: `api.creepy-shorts.com`

---

## 📱 কী কী Implement করা হয়েছে

✅ **Android Deep Linking** (Custom Scheme + HTTPS)
✅ **iOS Deep Linking** (Custom Scheme + Universal Links)
✅ **Share Functionality** (Facebook, Twitter, WhatsApp, System Share)
✅ **Web Fallback Page** (Auto-detect করে mobile থেকে app/store এ নিয়ে যায়)
✅ **Domain Verification Files** (Android Asset Links + iOS AASA)

---

## 🚀 দ্রুত শুরু করুন

### 1. Android Setup

#### ধাপ ১.১: SHA-256 Fingerprint বের করুন

আপনার app এর SHA-256 fingerprint পেতে এই command চালান:

```bash
# Debug keystore এর জন্য
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Release keystore এর জন্য
keytool -list -v -keystore /path/to/your/release.keystore -alias your_alias_name
```

**SHA256** fingerprint কপি করুন (এরকম দেখতে: `14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5`)

#### ধাপ ১.২: Asset Links File আপডেট করুন

ফাইল খুলুন: `web_fallback/.well-known/assetlinks.json`

`YOUR_SHA256_FINGERPRINT_HERE` কে আপনার actual SHA-256 fingerprint দিয়ে replace করুন।

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.victorsaulmendozamena.creepyshorts",
      "sha256_cert_fingerprints": [
        "এখানে আপনার SHA-256 দিন"
      ]
    }
  }
]
```

#### ধাপ ১.৩: আপনার Domain এ Upload করুন

নিচের files আপনার domain এ upload করুন:

```
https://api.creepy-shorts.com/.well-known/assetlinks.json
https://api.creepy-shorts.com/.well-known/apple-app-site-association
https://api.creepy-shorts.com/shorts/[VIDEO_ID]  (web fallback page)
```

**গুরুত্বপূর্ণ:** 
- Files অবশ্যই HTTPS দিয়ে accessible হতে হবে
- `assetlinks.json` এর `Content-Type: application/json` থাকতে হবে
- `apple-app-site-association` এ `.json` extension থাকবে না

---

### 2. iOS Setup

#### ধাপ ২.১: Team ID বের করুন

1. [Apple Developer Portal](https://developer.apple.com) এ যান
2. **Membership** section এ যান
3. আপনার **Team ID** কপি করুন (এরকম দেখতে: `ABCD1234EF`)

#### ধাপ ২.২: Apple App Site Association আপডেট করুন

ফাইল খুলুন: `web_fallback/.well-known/apple-app-site-association`

`TEAM_ID` কে আপনার actual Team ID দিয়ে replace করুন:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "আপনার_TEAM_ID.com.victorsaulmendozamena.creepyshorts",
        "paths": ["/shorts/*", "/video/*"]
      }
    ]
  }
}
```

#### ধাপ ২.৩: Xcode Configure করুন

1. Xcode এ `ios/Runner.xcworkspace` খুলুন
2. **Runner** target select করুন
3. **Signing & Capabilities** tab এ যান
4. **+ Capability** ক্লিক করুন → **Associated Domains** add করুন
5. এই domains গুলো add করুন:
   ```
   applinks:api.creepy-shorts.com
   applinks:www.api.creepy-shorts.com
   ```

---

### 3. App Store Links আপডেট করুন

#### ধাপ ৩.১: Play Store

আপনার app Google Play তে publish হলে, এটা আপডেট করুন:

`web_fallback/index.html` → Play Store link এর line

```html
<a href="https://play.google.com/store/apps/details?id=com.victorsaulmendozamena.creepyshorts">
```

#### ধাপ ৩.২: App Store

আপনার app Apple App Store এ publish হলে, এটা আপডেট করুন:

`web_fallback/index.html` → App Store link এর line

`YOUR_APP_ID` কে আপনার actual App Store ID দিয়ে replace করুন:

```html
<a href="https://apps.apple.com/app/id1234567890">
```

---

## 🧪 Deep Links Test করুন

### Android Testing

#### পদ্ধতি ১: ADB Command

```bash
# Custom scheme test করুন
adb shell am start -W -a android.intent.action.VIEW -d "creepyshorts://shorts/VIDEO_ID_HERE" com.victorsaulmendozamena.creepyshorts

# HTTPS link test করুন
adb shell am start -W -a android.intent.action.VIEW -d "https://api.creepy-shorts.com/shorts/VIDEO_ID_HERE" com.victorsaulmendozamena.creepyshorts
```

#### পদ্ধতি ২: Chrome Browser

1. Android এ Chrome খুলুন
2. Address bar এ টাইপ করুন: `creepyshorts://shorts/VIDEO_ID_HERE`
3. অথবা visit করুন: `https://api.creepy-shorts.com/shorts/VIDEO_ID_HERE`

#### পদ্ধতি ৩: App Links Verify করুন

```bash
# আপনার domain verified কিনা check করুন
adb shell pm get-app-links com.victorsaulmendozamena.creepyshorts

# এরকম দেখাবে: "api.creepy-shorts.com: verified"
```

### iOS Testing

#### পদ্ধতি ১: Safari

1. iPhone এ Safari খুলুন
2. Visit করুন: `https://api.creepy-shorts.com/shorts/VIDEO_ID_HERE`
3. App এ open করার জন্য banner দেখাবে (app installed থাকলে)

#### পদ্ধতি ২: Notes App

1. Notes app খুলুন
2. Link টাইপ করুন: `https://api.creepy-shorts.com/shorts/VIDEO_ID_HERE`
3. Link এ tap করুন → App এ open হবে

#### পদ্ধতি ৩: Custom Scheme

1. Safari খুলুন
2. টাইপ করুন: `creepyshorts://shorts/VIDEO_ID_HERE`
3. App open করার prompt দেখাবে

---

## 🌐 Web Server Configuration

### Server এ Files Upload করুন

আপনার domain এ এই files serve করতে হবে:

```
https://api.creepy-shorts.com/
├── .well-known/
│   ├── assetlinks.json                    (Android verification)
│   └── apple-app-site-association         (iOS verification)
└── shorts/
    └── [VIDEO_ID]/                        (Web fallback page)
        └── index.html
```

### cPanel/Hosting এ Upload করার নিয়ম

1. **cPanel File Manager** খুলুন
2. `public_html` folder এ যান
3. `.well-known` নামে একটা folder তৈরি করুন
4. সেখানে `assetlinks.json` এবং `apple-app-site-association` upload করুন
5. `shorts` নামে আরেকটা folder তৈরি করুন
6. সেখানে `index.html` (web fallback page) upload করুন

### File Permissions

- Files এর permission `644` হতে হবে
- Folders এর permission `755` হতে হবে

---

## 📤 Sharing কিভাবে কাজ করে

### User Flow

1. **User Share button এ tap করে** app এ
2. **Share bottom sheet দেখায়** এই options সহ:
   - Facebook
   - Twitter/X
   - WhatsApp
   - More (System Share Sheet)
   - Copy Link

3. **Link generate হয়**: 
   ```
   https://api.creepy-shorts.com/shorts/VIDEO_ID
   ```

4. **যে link receive করে সে click করলে**:
   - **App installed থাকলে**: Directly app এ সেই video open হয়
   - **App installed না থাকলে**: Web fallback page খুলে যেখানে download button আছে

### Share Link Format

```
https://api.creepy-shorts.com/shorts/[VIDEO_ID]
```

উদাহরণ:
```
https://api.creepy-shorts.com/shorts/67920e5c51d46fa7f99f3dff
```

---

## 🔍 Verification ও Troubleshooting

### Android App Links Verify করুন

```bash
# Domain verification status check করুন
adb shell pm get-app-links com.victorsaulmendozamena.creepyshorts

# Output এ এরকম থাকবে:
# api.creepy-shorts.com: verified
```

যদি verified না হয়:
1. Check করুন assetlinks.json accessible কিনা
2. Verify করুন SHA-256 fingerprint সঠিক কিনা
3. ২৪-৪৮ ঘন্টা অপেক্ষা করুন Google এর re-crawl এর জন্য

### iOS Universal Links Verify করুন

1. Visit করুন: https://branch.io/resources/aasa-validator/
2. Enter করুন: `api.creepy-shorts.com`
3. Check করুন AASA file valid কিনা

### সাধারণ সমস্যা ও সমাধান

#### ❌ "Link browser এ open হচ্ছে, app এ না"

**Android:**
- Check করুন `android:autoVerify="true"` আছে কিনা
- Domain verify করুন: `adb shell pm get-app-links`
- App data clear করে reinstall করুন

**iOS:**
- Verify করুন Associated Domains Xcode এ আছে কিনা
- Check করুন AASA file accessible কিনা (.json extension ছাড়া)
- Safari তে test করুন, Chrome এ না

#### ❌ "assetlinks.json 404 error দিচ্ছে"

- নিশ্চিত করুন file এখানে আছে: `https://api.creepy-shorts.com/.well-known/assetlinks.json`
- File permissions check করুন (readable হতে হবে)
- Verify করুন Content-Type header `application/json` আছে কিনা

#### ❌ "App video ID receive করছে না"

- Check করুন `DeepLinkService` initialize হয়েছে `main.dart` এ
- Verify করুন route registered আছে `AppRoutes` এ
- Check করুন `ShortsScontroller` arguments receive করছে কিনা

---

## 🎯 Testing Checklist

Production এ release করার আগে:

### Android
- [ ] SHA-256 fingerprint add করেছেন assetlinks.json এ
- [ ] assetlinks.json সঠিক URL এ accessible
- [ ] Custom scheme কাজ করছে (`creepyshorts://`)
- [ ] HTTPS links কাজ করছে
- [ ] Shared links click করলে app open হচ্ছে
- [ ] Video ID correctly pass হচ্ছে এবং video play হচ্ছে

### iOS
- [ ] Team ID update করেছেন apple-app-site-association এ
- [ ] AASA file accessible (.json extension ছাড়া)
- [ ] Associated Domains configured আছে Xcode এ
- [ ] Universal Links কাজ করছে Safari এ
- [ ] Custom scheme কাজ করছে
- [ ] Shared links থেকে app open হচ্ছে

### Web Fallback
- [ ] Page সঠিকভাবে load হচ্ছে
- [ ] Mobile OS auto-detect করছে
- [ ] সঠিক store button দেখাচ্ছে (Play Store/App Store)
- [ ] App installed থাকলে open করছে
- [ ] App না থাকলে store এ redirect করছে

### Share Functionality
- [ ] সব share button কাজ করছে (Facebook, Twitter, WhatsApp)
- [ ] System share sheet কাজ করছে
- [ ] Copy link কাজ করছে
- [ ] Shared link format সঠিক

---

## 📝 সারাংশ

**কী কী Ready:**
1. ✅ Android deep linking configured
2. ✅ iOS deep linking configured
3. ✅ Share functionality implemented
4. ✅ Web fallback page তৈরি
5. ✅ Domain verification files ready

**আপনাকে কী কী করতে হবে:**
1. SHA-256 fingerprint বের করে `assetlinks.json` update করুন
2. Apple Team ID বের করে `apple-app-site-association` update করুন
3. Files upload করুন আপনার domain এ: `api.creepy-shorts.com`
4. Xcode এ Associated Domains configure করুন
5. Play Store এবং App Store links update করুন
6. Android এবং iOS device এ thoroughly test করুন

**গুরুত্বপূর্ণ নোট:**
- Files অবশ্যই HTTPS দিয়ে accessible হতে হবে
- Domain verification এ ২৪-৪৮ ঘন্টা লাগতে পারে
- Production এ release করার আগে thoroughly test করুন
- Deep link usage track করার জন্য analytics monitor করুন

---

## 🎉 সব সেটআপ সম্পন্ন!

উপরের setup steps complete করলে, users পারবে:
- App থেকে videos share করতে
- Shared links directly app এ open করতে
- App installed না থাকলে app stores এ redirect হতে
- সব platforms এ seamless sharing experience পেতে

শুভকামনা! 🚀

---

## 📞 সাহায্যের জন্য

যদি কোন সমস্যা হয়, তাহলে:
1. প্রথমে এই guide carefully পড়ুন
2. Common issues section check করুন
3. Testing commands সঠিকভাবে চালান
4. Domain verification status check করুন

All the best! 🎯
