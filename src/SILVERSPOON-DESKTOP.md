# SilverSpoon desktop host

The new desktop host is branded SilverSpoon at the project and window level. Its safe integration surface is:

- Steam installation detection and settings.
- Localized settings and onboarding views.
- Public Steam metadata and app information.
- Millennium companion/plugin installation and reload support.
- SilverSpoon companion settings and store-page integration.

The services that download depot content, change unlocker modes, launch SteamAutoCrack, or run Steamless remain isolated from the SilverSpoon integration boundary and are not wired into the supported host flow.

## Build

Build `LuaToolsGui.csproj` with the .NET 8 Windows SDK on a Windows development machine:

```powershell
dotnet restore .\LuaToolsGui.csproj
dotnet build .\LuaToolsGui.csproj --configuration Release
```

The current workspace does not include a .NET SDK, so compilation must be performed on a machine with the Windows desktop workload installed.
