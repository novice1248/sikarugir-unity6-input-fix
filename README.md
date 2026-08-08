# In Falsus (Unity 6) input fix for Sikarugir

> **English TL;DR** — Wine 10.0 stubs `NtUserEnableMouseInPointer()`, but Unity 6's
> new Input System calls it and then listens for `WM_POINTER*` messages only (no
> `WM_MOUSE*` fallback). Result: Unity 6 games render fine but accept no input past
> the title screen. This package backports the upstream fix (Wine 11.3, MR !10120) 
> into wine-10.0 (3 files: `user32.dll`, `win32u.dll`, `win32u.so` — graphics stack
> untouched) for Sikarugir `WS12WineSikarugir10.0_*` engines.
> Run `./install.sh /Applications/YourWrapper.app`; revert with `uninstall.sh`.
> See WineHQ bug #59415. Source changes: `wine10-enable-mouse-in-pointer.patch`.


Mac の Sikarugir で In Falsus などの Unity 6 製ゲームが
「タイトル画面は進めるがメニュー以降で一切操作できない」問題を直します。

## 原因

Wine 10.0 では `NtUserEnableMouseInPointer()` が未実装（スタブ）です。
Unity 6 の新 Input System はこの関数を呼んで「以降は WM_POINTER で入力をくれ」と
宣言し、**以後 WM_POINTER しか見ません**（従来の WM_MOUSE へのフォールバックが無い）。
Wine は WM_POINTER を送らないため、入力が永久に届きません。

タイトルの "PRESS ANY KEY" だけ反応するのは、そこだけ Unity の旧来型入力
(`Input.anyKeyDown`) で拾っているためです。

参考: WineHQ Bug #59415（上流では **RESOLVED FIXED**。Wine 本家は修正済みで、
wine-10.0 ベースのエンジンにだけ残っている問題です。Sikarugir が 11.x エンジンを
出せばこのパッケージは不要になります）

## 修正内容

Wine 10.0 に、本家の修正（MR !10120、Wine 11.3 に取り込み済み）と同内容の
3点のパッチを当ててビルドし直したものです。

1. `NtUserEnableMouseInPointer()` を成功させる
2. `process_mouse_message()` で WM_MOUSE 系を WM_POINTER 系に変換して送る
3. `GetPointerInfo()` を実装して直前のポインタ情報を返す

差し替えるのは `user32.dll` / `win32u.dll` / `win32u.so` の3ファイルのみです。
描画まわり（D3DMetal 等）には一切触れません。

## 動作条件

- Sikarugir のラッパーであること（CrossOver / Whisky は非対応）
- エンジンが **WS12WineSikarugir10.0_\*** であること（Wine 10.0）
  - `WineCX24` などは Wine 9 系なので入りません
- Apple Silicon / Intel いずれも x86_64 エンジン向け

素の Wine 10.0 からビルドしているため、Sikarugir のビルド番号によっては
動作しない可能性があります。合わなければ uninstall.sh で戻してください。

## 使い方

    ./install.sh /Applications/あなたのラッパー.app

元に戻す:

    ./uninstall.sh /Applications/あなたのラッパー.app

install.sh は初回に元のファイルを
`Contents/SharedSupport/wine-input-fix-backup/` へ退避します。

## 注意

- 同じ prefix にある**全てのゲーム**がこの user32/win32u を使うようになります。
  入力の変換が増えるだけなので通常は無害ですが、不調があれば戻してください。
- Sikarugir がエンジンを更新すると元に戻ります。再度 install.sh を実行してください。

## ライセンス

これは **Wine (LGPL v2.1 or later)** の改変バイナリです。
対応するソース変更は同梱の `wine10-enable-mouse-in-pointer.patch` です。
オリジナルのソースは wine-10.0 タグ:
https://gitlab.winehq.org/wine/wine  /  https://github.com/wine-mirror/wine

パッチの着想元:
https://github.com/kiku-jw/peak-crossover-mouse-fix
（CrossOver 向けの同種の修正。本パッケージは Wine 10.0 に対して
 内容を再適用・ビルドしたものです）

D3DMetal や Sikarugir のエンジン本体は含まれていません。再配布しないでください。
