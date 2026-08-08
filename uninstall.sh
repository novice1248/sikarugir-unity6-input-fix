#!/bin/bash
set -e
APP="${1:-}"
[ -n "$APP" ] || { echo "使い方: ./uninstall.sh /Applications/あなたのラッパー.app"; exit 1; }
E="$APP/Contents/SharedSupport/wine"
BK="$APP/Contents/SharedSupport/wine-input-fix-backup"
[ -d "$BK" ] || { echo "バックアップが見つかりません: $BK"; exit 1; }
pkill -9 -f "wineserver|steam.exe|steamwebhelper|\.exe" 2>/dev/null || true
sleep 3
cp "$BK/user32.dll" "$E/lib/wine/x86_64-windows/"
cp "$BK/win32u.dll" "$E/lib/wine/x86_64-windows/"
cp "$BK/win32u.so"  "$E/lib/wine/x86_64-unix/"
echo "元に戻しました。"
