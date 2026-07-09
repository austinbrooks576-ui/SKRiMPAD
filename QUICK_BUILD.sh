#!/bin/bash

# SKRiMPAD Quick APK Builder
# Usage: bash QUICK_BUILD.sh [debug|release]

set -e

BUILD_TYPE="${1:-release}"
ANDROID_DIR="android"

echo "🎵 SKRiMPAD APK Builder"
echo "━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Build Type: $BUILD_TYPE"
echo ""

# Check if Android directory exists
if [ ! -d "$ANDROID_DIR" ]; then
    echo "❌ Android directory not found!"
    exit 1
fi

cd "$ANDROID_DIR"

# Clean (optional)
echo "🧹 Cleaning previous builds..."
./gradlew clean

# Build APK
if [ "$BUILD_TYPE" = "debug" ]; then
    echo "🔨 Building debug APK..."
    ./gradlew assembleDebug
    APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
else
    echo "🔨 Building release APK..."
    ./gradlew assembleRelease
    APK_PATH="app/build/outputs/apk/release/app-release.apk"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "$APK_PATH" ]; then
    SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo "✅ Build successful!"
    echo "📦 APK: $APK_PATH"
    echo "📊 Size: $SIZE"
    echo ""
    echo "📱 To install on device:"
    echo "   adb install -r $APK_PATH"
else
    echo "❌ Build failed - APK not found"
    exit 1
fi