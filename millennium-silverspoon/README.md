# SilverSpoon Store Companion

A small Millennium webview plugin that adds a SilverSpoon panel and local settings to Steam game store pages. It displays the current Steam App ID, copies it to the clipboard, and supports compact layout and App ID visibility preferences.

The panel runs entirely in the Steam webview. Settings are kept in local webview storage. It does not contact a remote service, download manifests, or write to Steam's game or depot directories.

## Installer

Run `install_silverspoon.lua` with a standard Lua 5.1+ interpreter on Windows. The Lua command uses the included PowerShell installer to:

- Find the Steam installation from the registry or ask for its location.
- Ask before downloading Millennium's official Windows installer, then require a valid Authenticode signature before launching it.
- Ask before installing the SilverSpoon Store Companion through the bundled Starlight compiler.
- Ask before closing and restarting Steam; it never force-kills Steam.

The installer installs the companion only. It does not install or replace the SilverSpoon core application.

## Build

Requires Node.js and npm.

```powershell
npm install
npm run bundle
```

The Starlight release package is written to `dist`, then bundled with the source files into `SilverSpoon-Store-Companion.zip`. To have Starlight install it into a detected local Millennium setup, set `output_path = "auto"` in `millennium.toml` and run `npm run build -- --release`.

## Package

The delivered `SilverSpoon-Store-Companion.zip` includes the source, the unsigned compiled Starlight release output, the Lua installer, and the Windows installer helper.

## Behavior

- Adds the SilverSpoon panel to Steam store app pages.
- Shows the app's numeric Steam App ID.
- Copies that ID when the button is clicked.
- Uses no backend, network requests, or filesystem access.
