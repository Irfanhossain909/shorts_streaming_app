#!/bin/bash

# 🧪 Deep Linking Testing Commands
# Creepy Shorts App
# Domain: api.creepy-shorts.com

echo "🧪 Deep Linking Testing Commands for Creepy Shorts"
echo "=================================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Package name
PACKAGE="com.victorsaulmendozamena.creepyshorts"

# Test video ID (replace with actual video ID)
VIDEO_ID="67920e5c51d46fa7f99f3dff"

echo "${YELLOW}📱 Testing Android Deep Links${NC}"
echo "================================"
echo ""

# Test 1: Custom Scheme
echo "${GREEN}Test 1: Custom Scheme (creepyshorts://)${NC}"
echo "Command:"
echo "adb shell am start -W -a android.intent.action.VIEW -d \"creepyshorts://shorts/$VIDEO_ID\" $PACKAGE"
echo ""
read -p "Press Enter to run this test..."
adb shell am start -W -a android.intent.action.VIEW -d "creepyshorts://shorts/$VIDEO_ID" $PACKAGE
echo ""

# Test 2: HTTPS Link
echo "${GREEN}Test 2: HTTPS Link (https://api.creepy-shorts.com)${NC}"
echo "Command:"
echo "adb shell am start -W -a android.intent.action.VIEW -d \"https://api.creepy-shorts.com/shorts/$VIDEO_ID\" $PACKAGE"
echo ""
read -p "Press Enter to run this test..."
adb shell am start -W -a android.intent.action.VIEW -d "https://api.creepy-shorts.com/shorts/$VIDEO_ID" $PACKAGE
echo ""

# Test 3: HTTP Link (fallback)
echo "${GREEN}Test 3: HTTP Link (fallback)${NC}"
echo "Command:"
echo "adb shell am start -W -a android.intent.action.VIEW -d \"http://api.creepy-shorts.com/shorts/$VIDEO_ID\" $PACKAGE"
echo ""
read -p "Press Enter to run this test..."
adb shell am start -W -a android.intent.action.VIEW -d "http://api.creepy-shorts.com/shorts/$VIDEO_ID" $PACKAGE
echo ""

# Test 4: Verify App Links
echo "${GREEN}Test 4: Verify Domain${NC}"
echo "Command:"
echo "adb shell pm get-app-links $PACKAGE"
echo ""
read -p "Press Enter to run this test..."
adb shell pm get-app-links $PACKAGE
echo ""
echo "${YELLOW}Expected output: api.creepy-shorts.com: verified${NC}"
echo ""

# Test 5: Check if app is installed
echo "${GREEN}Test 5: Check if app is installed${NC}"
echo "Command:"
echo "adb shell pm list packages | grep creepyshorts"
echo ""
adb shell pm list packages | grep creepyshorts
echo ""

# Test 6: Open app normally
echo "${GREEN}Test 6: Open app normally${NC}"
echo "Command:"
echo "adb shell am start -n $PACKAGE/.MainActivity"
echo ""
read -p "Press Enter to run this test..."
adb shell am start -n $PACKAGE/.MainActivity
echo ""

# Test 7: Clear app data (for fresh test)
echo "${YELLOW}Test 7: Clear app data (use with caution!)${NC}"
echo "Command:"
echo "adb shell pm clear $PACKAGE"
echo ""
read -p "Press Enter to clear app data (or Ctrl+C to skip)..."
adb shell pm clear $PACKAGE
echo ""

# Test 8: Check logcat for deep link logs
echo "${GREEN}Test 8: Monitor logcat for deep link activity${NC}"
echo "Command:"
echo "adb logcat | grep -i 'deep.*link'"
echo ""
echo "${YELLOW}Press Ctrl+C to stop monitoring${NC}"
echo ""
read -p "Press Enter to start monitoring..."
adb logcat | grep -i "deep.*link"

echo ""
echo "${GREEN}✅ All tests completed!${NC}"
echo ""
echo "📝 Notes:"
echo "1. Make sure device/emulator is connected"
echo "2. App must be installed"
echo "3. Replace VIDEO_ID with actual video ID for testing"
echo "4. Domain verification may take 24-48 hours"
echo ""
echo "🔗 Test URLs:"
echo "   Custom: creepyshorts://shorts/$VIDEO_ID"
echo "   HTTPS:  https://api.creepy-shorts.com/shorts/$VIDEO_ID"
echo "   HTTP:   http://api.creepy-shorts.com/shorts/$VIDEO_ID"
echo ""
echo "🌐 Web Fallback:"
echo "   Open in browser: https://api.creepy-shorts.com/shorts/$VIDEO_ID"
echo ""
