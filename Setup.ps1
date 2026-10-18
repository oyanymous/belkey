param([switch]$Undo, [switch]$System)
$ErrorActionPreference = 'Stop'
$key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\A9B0080C'
$tip = '080C:A9B0080C'
$name = 'Belgian Mac (MX Keys)'
$dll = "$env:WINDIR\System32\mxbelmac.dll"
$backup = Join-Path $PSScriptRoot 'before-install.xml'
$startup = Join-Path ([Environment]::GetFolderPath('Startup')) 'Belgian Mac MX Keys.lnk'
if ($System) {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    if (-not ([Security.Principal.WindowsPrincipal]$identity).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { throw 'Administrator access is required for the layout DLL.' }
    if (Test-Path $key) {
        $existing = Get-ItemProperty $key
        if ($existing.'Layout File' -ne 'mxbelmac.dll' -or $existing.'Layout Text' -ne $name) { throw 'Layout registry identifier is already in use.' }
    }
    if ($Undo) {
        if (Test-Path $key) { Remove-Item -LiteralPath $key }
        # Windows can retain a loaded layout until sign-out; leaving its small DLL is harmless.
        try { if (Test-Path $dll) { Remove-Item -LiteralPath $dll } } catch { }
    } else {
        $conflict = Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts' | Get-ItemProperty | Where-Object { $_.'Layout Id' -eq '0fb0' -and $_.PSPath -notlike '*A9B0080C' }
        if ($conflict) { throw 'Layout Id 0fb0 is already in use.' }
        if (-not (Test-Path $dll)) { Copy-Item -LiteralPath "$PSScriptRoot\mxbelmac.dll" -Destination $dll }
        New-Item $key -Force | Out-Null
        New-ItemProperty $key -Name 'Layout File' -Value 'mxbelmac.dll' -PropertyType String -Force | Out-Null
        New-ItemProperty $key -Name 'Layout Text' -Value $name -PropertyType String -Force | Out-Null
        New-ItemProperty $key -Name 'Layout Id' -Value '0fb0' -PropertyType String -Force | Out-Null
    }
    exit
}
if (-not [Environment]::Is64BitOperatingSystem -or $env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { throw 'This package is for x64 Windows.' }
$ahk = @("$PSScriptRoot\runtime\AutoHotkey64.exe", "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe", "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe") | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
if (-not $Undo -and -not $ahk) { throw 'Install AutoHotkey v2 from https://www.autohotkey.com/ and run Install.cmd again.' }
if ($Undo -and -not (Test-Path $backup)) { throw 'No saved keyboard settings found in this folder.' }
if (-not $Undo -and -not (Test-Path $backup)) {
    @{Languages=(Get-WinUserLanguageList); Override=(Get-WinDefaultInputMethodOverride)} | Export-Clixml $backup
}
if ($Undo) {
    Get-CimInstance Win32_Process -Filter "Name='AutoHotkey64.exe'" | Where-Object { $_.CommandLine -like "*$PSScriptRoot\Modifiers.ahk*" } | ForEach-Object { Stop-Process -Id $_.ProcessId -ErrorAction SilentlyContinue }
    if (Test-Path $startup) { Remove-Item -LiteralPath $startup }
    $saved = Import-Clixml $backup
    $restored = New-WinUserLanguageList $saved.Languages[0].LanguageTag
    $restored.Clear()
    foreach ($lang in $saved.Languages) {
        $entry = (New-WinUserLanguageList $lang.LanguageTag)[0]
        $entry.InputMethodTips.Clear()
        foreach ($inputTip in $lang.InputMethodTips) { $entry.InputMethodTips.Add([string]$inputTip) }
        $entry.Spellchecking = $lang.Spellchecking
        $entry.Handwriting = $lang.Handwriting
        $restored.Add($entry)
    }
    Set-WinUserLanguageList $restored -Force
    if ($saved.Override.InputMethodTip) { Set-WinDefaultInputMethodOverride -InputTip $saved.Override.InputMethodTip } else { Set-WinDefaultInputMethodOverride }
}
$argsForAdmin = '-NoProfile -ExecutionPolicy Bypass -File "' + $PSCommandPath + '" -System'
if ($Undo) { $argsForAdmin += ' -Undo' }
$admin = Start-Process powershell.exe -Verb RunAs -WindowStyle Hidden -ArgumentList $argsForAdmin -Wait -PassThru
if ($admin.ExitCode -ne 0) { throw 'System layout setup failed or was cancelled. No user layout was activated.' }
if ($Undo) { Write-Host 'Original keyboard settings restored. Sign out and in to finish.'; exit }
$langs = Get-WinUserLanguageList
$french = $langs | Where-Object LanguageTag -eq 'fr-BE' | Select-Object -First 1
if (-not $french) { $langs.Add('fr-BE'); $french = $langs | Where-Object LanguageTag -eq 'fr-BE' | Select-Object -First 1 }
if (-not $french.InputMethodTips.Contains($tip)) { $french.InputMethodTips.Add($tip) }
Set-WinUserLanguageList $langs -Force
Set-WinDefaultInputMethodOverride -InputTip $tip
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($startup)
$shortcut.TargetPath = $ahk
$shortcut.Arguments = '"' + "$PSScriptRoot\Modifiers.ahk" + '"'
$shortcut.WorkingDirectory = $PSScriptRoot
$shortcut.Save()
Start-Process $ahk -ArgumentList ('"' + "$PSScriptRoot\Modifiers.ahk" + '"') -WindowStyle Hidden
Write-Host 'Installed. Sign out and in, then select Belgian Mac (MX Keys) with Windows+Space if needed.'
Write-Host 'Keep this folder here: the Command-key helper starts from it at sign-in.'
