#!/bin/bash
# In Falsus / Unity 6 入力修正 — Sikarugir (Wine 10.0) 用インストーラ
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"

APP="${1:-}"
if [ -z "$APP" ]; then
  echo "使い方: ./install.sh /Applications/あなたのラッパー.app"
  echo "例:     ./install.sh /Applications/Windows.app"
  exit 1
fi

E="$APP/Contents/SharedSupport/wine"
[ -d "$E" ] || { echo "エラー: Sikarugir のラッパーではないようです: $APP"; exit 1; }

VER="$("$E/bin/wine" --version 2>/dev/null || echo unknown)"
case "$VER" in
  wine-10.0*) ;;
  *) echo "エラー: エンジンが Wine 10.0 ではありません ($VER)"
     echo "この修正は WS12WineSikarugir10.0_* 専用です。"; exit 1 ;;
esac

echo "対象: $APP  ($VER)"

BK="$APP/Contents/SharedSupport/wine-input-fix-backup"
if [ ! -d "$BK" ]; then
  mkdir -p "$BK"
  cp "$E/lib/wine/x86_64-windows/user32.dll" "$BK/"
  cp "$E/lib/wine/x86_64-windows/win32u.dll" "$BK/"
  cp "$E/lib/wine/x86_64-unix/win32u.so"     "$BK/"
  echo "元のファイルを $BK に保存しました"
fi

echo "wine を停止しています..."
pkill -9 -f "wineserver|steam.exe|steamwebhelper|\.exe" 2>/dev/null || true
sleep 3

cp "$HERE/bin/user32.dll" "$E/lib/wine/x86_64-windows/"
cp "$HERE/bin/win32u.dll" "$E/lib/wine/x86_64-windows/"
cp "$HERE/bin/win32u.so"  "$E/lib/wine/x86_64-unix/"

echo "完了しました。Steam を起動してゲームを試してください。"
echo "元に戻す場合: ./uninstall.sh \"$APP\""
