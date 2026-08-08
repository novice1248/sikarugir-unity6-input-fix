# サードパーティ表記

## Wine (LGPL v2.1 or later)

本パッケージの `bin/user32.dll` `bin/win32u.dll` `bin/win32u.so` は
Wine 10.0 を改変してビルドしたバイナリです。

- 上流ソース: wine-10.0 タグ
  https://gitlab.winehq.org/wine/wine
  https://github.com/wine-mirror/wine
- 本パッケージによる変更点: 同梱の `wine10-enable-mouse-in-pointer.patch`
- ライセンス全文: 上流ソースの `COPYING.LIB` を参照

## peak-crossover-mouse-fix (MIT)

WM_MOUSE → WM_POINTER 変換の実装は下記を参考にしています。

    MIT License
    Copyright (c) 2026 Nick
    https://github.com/kiku-jw/peak-crossover-mouse-fix

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR OTHER DEALINGS IN THE SOFTWARE.

上流の同種の議論・実装:
- WineHQ Bug #59415 (In Falsus demo cannot be interacted with)
  → RESOLVED FIXED: https://gitlab.winehq.org/wine/wine/-/merge_requests/10120
    (Wine 11.3 に取り込み、11.7 でクローズ)
- 関連: Bug #59429（修正後、リズムゲーム部分でカーソルが壊れる報告）
