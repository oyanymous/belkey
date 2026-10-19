#Requires AutoHotkey v2.0
#SingleInstance Force
if A_Args.Length && A_Args[1] = "--check"
    ExitApp
; Enable the numeric keypad when the helper starts.
SetNumLockState "On"
; Keep Logitech in Mac mode: Command emits Win, Option emits Alt.
; Both Command keys become Ctrl. Physical left Control opens Windows Start.
LWin::LCtrl
RWin::RCtrl
LCtrl::LWin
; Swap the ISO key beside left Shift (< >) with the key below Esc (@ #).
; Scan-code remaps also carry Shift and Option symbol combinations.
SC029::SC056
SC056::SC029
; Right Option is native AltGr. Left Option remains Windows Alt (Alt+Tab).
; Both Option keys type braces on the physical ( and ) keys.
; AltGr includes Windows' synthetic left Ctrl; keep Shift layers native.
<!SC006::SendText "{"
<!SC00C::SendText "}"
>!SC006::SendText "{"
>!SC00C::SendText "}"
<^>!SC006::SendText "{"
<^>!SC00C::SendText "}"
; Ctrl+Alt+F12 exits this helper immediately.
^!F12::ExitApp
