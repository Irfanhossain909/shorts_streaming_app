# 🔗 Deep Linking Server Configuration

এই folder এ সব files আছে যা সার্ভারে deploy করতে হবে যাতে Deep Linking (App Links / Universal Links) কাজ করে।

## 📋 সমস্যা কি ছিল?

যখন কেউ `https://api.creepy-shorts.com/shorts/VIDEO_ID` লিংকে ক্লিক করে:
- ❌ আগে: সরাসরি browser এ যেত (অ্যাপ install থাকলেও)
- ✅ এখন: সরাসরি অ্যাপে যাবে (যদি install থাকে)

## 🚀 Deploy করার ধাপ

### Step 1: SHA-256 Fingerprint বের করুন (Android)

**Debug key এর জন্য:**
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**Release key এর জন্য:**
```bash
keytool -list -v -keystore your-release-key.keystore -alias your-alias
```

**Output থেকে SHA256 কপি করুন**, যেমন:
```
SHA256: 14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
```

### Step 2: Apple Team ID বের করুন (iOS)

1. https://developer.apple.com/account এ যান
2. Membership section এ যান
3. **Team ID** কপি করুন (যেমন: `ABCD1234EF`)

### Step 3: Files Update করুন

#### `.well-known/assetlinks.json` (Android)
```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.victorsaulmendozamena.creepyshorts",
      "sha256_cert_fingerprints": [
        "আপনার_DEBUG_SHA256_এখানে",
        "আপনার_RELEASE_SHA256_এখানে"
      ]
    }
  }
]
```

#### `.well-known/apple-app-site-association` (iOS)
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

### Step 4: সার্ভারে Deploy করুন

এই files গুলো আপনার সার্ভারে এভাবে থাকতে হবে:

```
https://api.creepy-shorts.com/
├── .well-known/
│   ├── assetlinks.json          ← Android App Links
│   └── apple-app-site-association  ← iOS Universal Links
└── shorts/
    └── [VIDEO_ID]/              ← Fallback page (optional)
```

### Step 5: Server Configuration

#### Express.js (Node.js):
```javascript
const express = require('express');
const path = require('path');
const app = express();

// CRITICAL: Serve .well-known files with correct content-type
app.use('/.well-known', express.static(path.join(__dirname, '.well-known'), {
  setHeaders: (res, filePath) => {
    if (filePath.endsWith('assetlinks.json')) {
      res.setHeader('Content-Type', 'application/json');
    }
    if (filePath.endsWith('apple-app-site-association')) {
      res.setHeader('Content-Type', 'application/json');
    }
  }
}));

// Dynamic video redirect handler
app.get('/shorts/:videoId', (req, res) => {
  const videoId = req.params.videoId;
  
  // Serve the fallback HTML page
  res.sendFile(path.join(__dirname, 'shorts', 'index.html'));
});

app.listen(5000);
```

#### Nginx Configuration:
```nginx
server {
    listen 443 ssl;
    server_name api.creepy-shorts.com;
    
    # .well-known files
    location /.well-known/assetlinks.json {
        alias /var/www/creepy-shorts/.well-known/assetlinks.json;
        add_header Content-Type application/json;
        add_header Access-Control-Allow-Origin *;
    }
    
    location /.well-known/apple-app-site-association {
        alias /var/www/creepy-shorts/.well-known/apple-app-site-association;
        add_header Content-Type application/json;
        add_header Access-Control-Allow-Origin *;
    }
    
    # Shorts fallback page
    location /shorts/ {
        try_files $uri /shorts/index.html;
    }
}
```

## ✅ Verification Checklist

### Android App Links Test:
```bash
# Check if assetlinks.json is accessible
curl -I https://api.creepy-shorts.com/.well-known/assetlinks.json

# Google verification tool
# Visit: https://developers.google.com/digital-asset-links/tools/generator
```

### iOS Universal Links Test:
```bash
# Check if apple-app-site-association is accessible
curl -I https://api.creepy-shorts.com/.well-known/apple-app-site-association

# Apple CDN verification (after deploy, wait 24-48 hours)
curl https://app-site-association.cdn-apple.com/a/v1/api.creepy-shorts.com
```

### Device Test:
1. অ্যাপ install করুন
2. Notes/Email এ লিংক paste করুন: `https://api.creepy-shorts.com/shorts/test123`
3. লিংকে ক্লিক করুন
4. সরাসরি অ্যাপে যাওয়া উচিত! 🎉

## ⚠️ গুরুত্বপূর্ণ Notes

1. **HTTPS বাধ্যতামূলক** - HTTP কাজ করবে না
2. **SSL Certificate Valid হতে হবে** - Self-signed কাজ করবে না
3. **Content-Type সঠিক হতে হবে** - `application/json`
4. **iOS এ CDN Cache আছে** - Apple 24-48 ঘন্টা পর update করে
5. **Android এ Instant Verify** - কিন্তু app re-install করতে হতে পারে

## 🔧 Troubleshooting

### "এখনো ব্রাউজারে যাচ্ছে"

1. SHA-256 fingerprint সঠিক কিনা verify করুন
2. Release build এর জন্য release keystore এর fingerprint লাগবে
3. অ্যাপ uninstall করে আবার install করুন
4. iOS এ 24-48 ঘন্টা wait করুন

### "assetlinks.json পাচ্ছে না"

```bash
# Status check
curl -v https://api.creepy-shorts.com/.well-known/assetlinks.json

# Response headers check করুন:
# - Status: 200
# - Content-Type: application/json
# - No redirects
```

### "iOS এ কাজ করছে না"

1. Team ID সঠিক কিনা check করুন
2. Bundle ID সঠিক কিনা check করুন
3. App Store/TestFlight থেকে install করা app এ কাজ করবে
4. Debug build এ কাজ নাও করতে পারে

## 📱 App Store ID Update করুন

`shorts/index.html` ফাইলে এই জায়গাগুলো update করুন:
- `YOUR_APP_STORE_ID` → আপনার actual App Store ID দিয়ে

## 🎯 Expected Result

Deploy করার পর:
- ✅ অ্যাপ install থাকলে → সরাসরি অ্যাপে যাবে
- ✅ অ্যাপ install না থাকলে → Play Store/App Store page দেখাবে
- ✅ Facebook/YouTube এর মতো seamless experience!
