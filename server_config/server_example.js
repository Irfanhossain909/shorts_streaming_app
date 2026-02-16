/**
 * 🔗 Deep Linking Server Example
 * 
 * এই server টি আপনার existing API server এ integrate করতে হবে
 * অথবা আলাদা static file server হিসেবে run করতে পারেন
 * 
 * npm install express
 * node server_example.js
 */

const express = require('express');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 5000;

// ============================================
// 📱 CONFIGURATION - এই values গুলো update করুন
// ============================================

const CONFIG = {
  // Android App
  android: {
    packageName: 'com.victorsaulmendozamena.creepyshorts',
    // keytool -list -v -keystore your-keystore.jks দিয়ে পাবেন
    sha256Fingerprints: [
      // Debug fingerprint - development এ test করার জন্য
      'YOUR_DEBUG_SHA256_FINGERPRINT_HERE',
      // Release fingerprint - Play Store build এর জন্য
      'YOUR_RELEASE_SHA256_FINGERPRINT_HERE'
    ]
  },

  // iOS App  
  ios: {
    // developer.apple.com → Membership থেকে পাবেন
    teamId: 'YOUR_APPLE_TEAM_ID',
    bundleId: 'com.victorsaulmendozamena.creepyshorts'
  },

  // App Store URLs
  stores: {
    playStore: 'https://play.google.com/store/apps/details?id=com.victorsaulmendozamena.creepyshorts',
    appStore: 'https://apps.apple.com/app/idYOUR_APP_STORE_ID'
  }
};

// ============================================
// 🔐 .well-known/assetlinks.json (Android)
// ============================================

app.get('/.well-known/assetlinks.json', (req, res) => {
  const assetlinks = [
    {
      relation: ['delegate_permission/common.handle_all_urls'],
      target: {
        namespace: 'android_app',
        package_name: CONFIG.android.packageName,
        sha256_cert_fingerprints: CONFIG.android.sha256Fingerprints
      }
    }
  ];

  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.json(assetlinks);
});

// ============================================
// 🍎 .well-known/apple-app-site-association (iOS)
// ============================================

app.get('/.well-known/apple-app-site-association', (req, res) => {
  const aasa = {
    applinks: {
      apps: [],
      details: [
        {
          appID: `${CONFIG.ios.teamId}.${CONFIG.ios.bundleId}`,
          paths: ['/shorts/*', '/video/*', '/v/*']
        }
      ]
    },
    webcredentials: {
      apps: [`${CONFIG.ios.teamId}.${CONFIG.ios.bundleId}`]
    }
  };

  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.json(aasa);
});

// ============================================
// 🎬 /shorts/:videoId - Smart Redirect Handler
// ============================================

app.get('/shorts/:videoId', (req, res) => {
  const videoId = req.params.videoId;
  const userAgent = req.headers['user-agent'] || '';

  // Detect platform
  const isAndroid = /android/i.test(userAgent);
  const isIOS = /iPhone|iPad|iPod/i.test(userAgent);

  // Custom scheme URL
  const appSchemeUrl = `creepyshorts://shorts/${videoId}`;

  // Generate dynamic HTML
  const html = generateDeepLinkHtml({
    videoId,
    appSchemeUrl,
    isAndroid,
    isIOS,
    config: CONFIG
  });

  res.setHeader('Content-Type', 'text/html');
  res.send(html);
});

// ============================================
// 📄 Generate Deep Link HTML
// ============================================

function generateDeepLinkHtml({ videoId, appSchemeUrl, isAndroid, isIOS, config }) {
  // Android Intent URL - More reliable than custom scheme
  const androidIntentUrl = `intent://shorts/${videoId}#Intent;` +
    `scheme=creepyshorts;` +
    `package=${config.android.packageName};` +
    `S.browser_fallback_url=${encodeURIComponent(config.stores.playStore)};` +
    `end`;

  return `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Creepy Shorts</title>
    
    <!-- iOS Smart App Banner -->
    <meta name="apple-itunes-app" content="app-id=YOUR_APP_STORE_ID, app-argument=${appSchemeUrl}">
    
    <!-- Open Graph -->
    <meta property="og:title" content="Watch on Creepy Shorts">
    <meta property="og:description" content="Watch this amazing video on Creepy Shorts!">
    <meta property="og:image" content="https://api.creepy-shorts.com/images/thumbnail/${videoId}.jpg">
    <meta property="og:url" content="https://api.creepy-shorts.com/shorts/${videoId}">
    <meta property="og:type" content="video.other">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
        }
        .container { text-align: center; padding: 40px 20px; max-width: 400px; }
        .logo {
            width: 100px; height: 100px; margin: 0 auto 24px;
            background: linear-gradient(135deg, #e94560 0%, #ff6b6b 100%);
            border-radius: 24px;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 10px 40px rgba(233, 69, 96, 0.3);
        }
        .logo svg { width: 50px; height: 50px; fill: white; }
        h1 { font-size: 24px; margin-bottom: 8px; }
        .subtitle { color: rgba(255,255,255,0.7); margin-bottom: 32px; }
        .spinner {
            width: 40px; height: 40px; margin: 0 auto 20px;
            border: 4px solid rgba(255,255,255,0.2);
            border-top-color: #e94560;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
        .btn {
            display: block; padding: 16px 24px; margin: 12px 0;
            border-radius: 14px; text-decoration: none;
            font-weight: 600; font-size: 16px; color: white;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(0,0,0,0.3); }
        .btn-android { background: linear-gradient(135deg, #34a853 0%, #1e7e34 100%); }
        .btn-ios { background: linear-gradient(135deg, #333 0%, #000 100%); }
        .fallback { opacity: 0; animation: fadeIn 0.5s ease forwards; animation-delay: 2s; }
        @keyframes fadeIn { to { opacity: 1; } }
        .divider { color: rgba(255,255,255,0.4); margin: 20px 0; font-size: 14px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">
            <svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
        </div>
        <h1>Creepy Shorts</h1>
        <p class="subtitle">Opening video...</p>
        <div class="spinner" id="spinner"></div>
        
        <div class="fallback">
            <p class="divider">— App not installed? —</p>
            ${isAndroid ? `
            <a href="${config.stores.playStore}" class="btn btn-android">
                📱 Get it on Play Store
            </a>
            ` : ''}
            ${isIOS ? `
            <a href="${config.stores.appStore}" class="btn btn-ios">
                🍎 Download on App Store
            </a>
            ` : ''}
            ${!isAndroid && !isIOS ? `
            <a href="${config.stores.playStore}" class="btn btn-android">
                📱 Get it on Play Store
            </a>
            <a href="${config.stores.appStore}" class="btn btn-ios">
                🍎 Download on App Store
            </a>
            ` : ''}
        </div>
    </div>
    
    <script>
        (function() {
            var appUrl = '${appSchemeUrl}';
            var androidIntent = '${androidIntentUrl}';
            var isAndroid = ${isAndroid};
            
            // Try to open app
            if (isAndroid) {
                // Android Intent is more reliable
                window.location.href = androidIntent;
            } else {
                // iOS: try custom scheme
                window.location.href = appUrl;
            }
            
            // If still here after 2.5s, show fallback
            setTimeout(function() {
                document.getElementById('spinner').style.display = 'none';
            }, 2500);
        })();
    </script>
</body>
</html>`;
}

// ============================================
// 🚀 Start Server
// ============================================

app.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════════════════════════╗
║           🔗 Deep Linking Server Started!                  ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  Server running on port ${PORT}                              ║
║                                                            ║
║  📱 Test URLs:                                             ║
║  • Android: /.well-known/assetlinks.json                   ║
║  • iOS:     /.well-known/apple-app-site-association        ║
║  • Video:   /shorts/test-video-id                          ║
║                                                            ║
║  ⚠️  Don't forget to update CONFIG with your:              ║
║  • SHA-256 fingerprints (Android)                          ║
║  • Team ID (iOS)                                           ║
║  • App Store ID                                            ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
  `);
});

module.exports = app;
