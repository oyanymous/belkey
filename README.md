# Belkey

Belgian keys. Mac keyboard. Windows shortcuts.

A small Windows x64 configuration for the **Logitech MX Keys for Mac with Belgian AZERTY**: a native Belgian Apple character layout, plus an AutoHotkey helper.

## What changes

| Key | Result |
| --- | --- |
| Letters, accents and punctuation | Belgian Apple AZERTY |
| Left and right ⌘ | Ctrl — copy, paste, undo and other Windows shortcuts |
| Left Control | Windows key |
| Left Option | Alt |
| Right Option | AltGr — symbols such as `{ } [ ]` and `€` |
| Key below Esc | `<` / `>` |
| Key beside left Shift | `@` / `#` |
| Numeric keypad | Num Lock enabled when the helper starts |

The `< >` and `@ #` keys are swapped, including their modifier layers.

## Install

1. Install [AutoHotkey v2](https://www.autohotkey.com/), then download or clone this repository into a permanent folder.
2. Keep the keyboard in **Mac mode**. If your model supports it, hold **Fn+O** for three seconds, or check the Mac-layout setting in Logi Options+.
3. Run **Install.cmd** and accept the administrator prompt.
4. Sign out and back in. Select **Belgian Mac (MX Keys)** in the taskbar keyboard menu if needed.

Keep the folder in place: the modifier helper starts from it at sign-in.

## Undo

Run **Undo.cmd**, then sign out and back in. Keep the generated `before-install.xml`; undo restores the keyboard settings saved at first install, including overwriting later changes to those settings.

To stop only the helper, exit it from its tray menu or press Ctrl+Alt+F12.

## Notes

For **x64 Windows**. The layout and remaps affect all attached keyboards, not only the MX Keys. The helper runs in the desktop session; elevated apps may need an elevated helper. Fn and Easy-Switch remain controlled by Logitech.

Experimental: installer syntax has been checked, but installation and physical typing have not been verified. An AutoHotkey runtime failed to launch in the preparation environment with a Windows DLL-relocation error.

## Credits

The native layout comes from [Windows Keyboard Layouts v1.6](https://github.com/lelegard/winkbdlayouts/releases/tag/v1.6) by Thierry Lelegard, under the [BSD 2-Clause license](Layout-LICENSE.txt). Its original C source is included; `mxbelmac.dll` is the upstream x64 `kbdbeapple.dll`, renamed without binary changes.

The helper requires [AutoHotkey v2](https://www.autohotkey.com/) ([source](https://github.com/AutoHotkey/AutoHotkey)), installed separately. The Belkey scripts and documentation use the [MIT license](LICENSE).
