# SilverSpoon desktop host

The new desktop host is branded SilverSpoon at the project and window level. Its safe integration surface is:

- Steam installation detection and settings.
- Localized settings and onboarding views.
- Public Steam metadata and app information.
- Millennium companion/plugin installation and reload support.
- SilverSpoon companion settings and store-page integration.

## Features

### Core Features

- **Depot Downloading**: Download Steam depot content via the Builds page. Select depots, choose download destination, monitor progress with pause/resume/cancel support. Uses `DepotDownloaderService` with CDN fetching and manifest validation.

- **Unlocker Controls**: Select and switch between OpenSteamTools (OST), BetterSteamTools (Bst), or Custom unlocker modes. Auto-detect existing installations. Install/switch requires Steam shutdown then relaunch for mode to take effect. Mode status displayed on Home dashboard. CloudRedirect add-on management for BST/OST modes.

- **SteamAutoCrack**: Launch SteamAutoCrack from Home dashboard or Downloads page. Fast path: if already installed and runtime present, opens immediately without queue row. Full path: downloads tool + .NET 10 Desktop runtime via Velopack Runtimes API, earns a queue row with progress tracking. Throttled update probe checks for newer builds every 6 hours.

- **Steamless DRM Removal**: Remove SteamStub DRM from games via Manage page. Progress tracking with user confirmation. Shows outcomes: failed, no-install, no-exe, success with patched/unchanged file counts.

- **Plugin Installation**: Install store-page plugins from the SilverSpoon companion. Confirm Steam restart, install, toast outcomes, refresh tiles.

- **Game Library Management**: Home dashboard shows game count and "recently added" cover strip. Live refresh after any install (drag-drop, plugin, Add page, Fixes). Warm cover resolution for interactive priority.

- **Mode Selection**: Home dashboard displays current unlocker mode status. Navigation to dedicated Mode page for mode selection, installation, and switching. Auto-detects active mode on first page load.

- **Protocol Handling**: Support for `luatools://` URLs for game installation, silent installs, protocol URLs from command line or temp files. Cold startup exit after silent install when configured.

- **Discord Key Donation**: Anonymous key donation system when setting is enabled. Runs silently in background with deduplication.

- **Update Flow**: Silent app+plugin update flow on Steam-open (--tray-locked). App updates apply first unconditionally before plugin updates. No manual "Restart" prompt - applies on next Steam open.

### Build

Build `LuaToolsGui.csproj` with the .NET 8 Windows SDK on a Windows development machine:

```powershell
dotnet restore .\LuaToolsGui.csproj
dotnet build .\LuaToolsGui.csproj --configuration Release
```

The current workspace does not include a .NET SDK, so compilation must be performed on a machine with the Windows desktop workload installed.

## Credits

### luatools

[OpenSteamTool](https://github.com/OpenSteam001/OpenSteamTool) - The Steam emulator/loader library that provides the core unpacking, manifest fetching, DRM removal, and ticket spoofing functionality. This desktop host integrates with OpenSteamTool through well-defined services and hooks.

- Repository: https://github.com/OpenSteam001/OpenSteamTool
- Used for: Depot decryption, manifest fetching, ticket management, achievement/stats, online fix, Denuvo/SteamStub compatibility
- License: See LICENSE in original repository

### OpenSteamTools

The OpenSteamTool project and ecosystem - Provides the underlying Steam client emulation, API access, and runtime services that this desktop host integrates with.

- Used for: All Steam interaction, library management, depot handling, plugin system
- Community contributions and pattern database (OpenSteam001/steam-monitor)

### Millennium

[Millennium Store Companion](https://github.com/millennium-silverspoon/millennium-store-companion) - The browser extension/plugin that provides the SilverSpoon companion experience on Steam game store pages.

- Repository: https://github.com/millennium-silverspoon/millennium-store-companion
- Used for: Store-page integration, companion panel, frontend flow
- Managed separately from this desktop host - the frontend (luatools.js) is fetched from GitHub releases by PluginInstallerService

## Build

Build `LuaToolsGui.csproj` with the .NET 8 Windows SDK on a Windows development machine:

```powershell
dotnet restore .\LuaToolsGui.csproj
dotnet build .\LuaToolsGui.csproj --configuration Release
```

The current workspace does not include a .NET SDK, so compilation must be performed on a machine with the Windows desktop workload installed.