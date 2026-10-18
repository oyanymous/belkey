# Repository Guidelines

## Project Structure & Module Organization

Belkey configures Belgian AZERTY Logitech MX Keys for Mac keyboards on x64 Windows. Files live at the repository root:

- `Modifiers.ahk`: AutoHotkey v2 modifier remaps, the `<` / `@` swap, and startup Num Lock state.
- `Setup.ps1`: native layout registration, user settings backup, startup shortcut, and undo logic.
- `Install.cmd` and `Undo.cmd`: interactive installer entry points.
- `layout-source.c` and `mxbelmac.dll`: upstream Belgian Apple layout source and renamed x64 binary.
- `README.md`, `LICENSE`, and `Layout-LICENSE.txt`: usage and licensing.

There is no test directory, CI pipeline, or local native build system.

## Build, Test, and Development Commands

Run commands from the repository root on Windows:

- `git diff --check`: detect whitespace errors before committing.
- `& "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe" /ErrorStdOut .\Modifiers.ahk --check`: parse the helper and exit before changing key states. Adjust the executable path for per-user installations.
- `Install.cmd`: install and activate the configuration; requires an administrator prompt and sign-out/sign-in.
- `Undo.cmd`: restore saved settings and remove registration and the startup helper.

No compilation is required for script changes. Changing C source alone does not update the DLL; document the upstream build process and binary provenance when replacing it.

## Coding Style & Naming Conventions

Use four-space indentation in PowerShell and AutoHotkey blocks. Preserve descriptive PowerShell variable names and AutoHotkey v2 syntax. Use scan-code names such as `SC029` for physical key positions. Explain modifier interactions in comments. No formatter or linter is configured.

## Testing Guidelines

No automated framework or coverage threshold exists. Check syntax, then manually verify AZERTY letters, accents, Shift/AltGr symbols, Command shortcuts, swapped keys, and keypad digits. Test installation, startup after sign-in, and undo on x64 Windows. Record actual results and distinguish untested behavior. Installation changes system settings; do not run it merely to check syntax.

## Commit & Pull Request Guidelines

Always use Conventional Commits: `<type>(<optional scope>): <description>`. Use types such as `feat`, `fix`, `docs`, `refactor`, and `chore`; for example, `fix(keypad): enable Num Lock when helper starts`. Keep subjects short, imperative, and focused. PRs should explain the problem, affected keys, expected behavior, Windows/AutoHotkey versions, and checks performed. Link relevant issues; screenshots are optional for UI behavior.

## Configuration & Licensing

Never commit `before-install.xml`, credentials, logs, or personal shortcuts. Preserve backup and undo behavior. Update README mappings with remap changes, retain third-party notices, and identify the source/version of replacement binaries.
