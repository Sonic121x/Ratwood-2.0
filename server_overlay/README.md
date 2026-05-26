# Server Overlay

This folder lets you start a clean upstream Ratwood source tree and automatically
re-apply the local mod integration layer before build or server launch.

## What It Stores

- `core-files.txt`
  - Relative paths for core files that must override upstream source.
- `core/`
  - Snapshots of the core integration files listed in `core-files.txt`.
- `patches/`
  - Patch files for the core integration layer. `auto_update.py` applies these after repo patches and before `mods/`.
- `mods/`
  - Snapshot of the local `mods/` tree, excluding `mods/_autogen.dm`.

## Main Scripts

- `refresh-overlay-from-current-workspace.ps1`
  - Rebuilds `core/` and `mods/` snapshots from the current workspace.
- `apply-overlay.ps1`
  - Copies overlay files into an existing workspace.
- `start-server.ps1`
  - Creates or refreshes a workdir from upstream, applies the overlay, and runs build/server commands.

## Typical Flow

1. Keep one clean upstream source tree elsewhere on disk.
2. Maintain your modded working copy here.
3. When the integration layer changes, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\server_overlay\refresh-overlay-from-current-workspace.ps1
```

4. Start from upstream into a generated workdir:

```powershell
powershell -ExecutionPolicy Bypass -File .\server_overlay\start-server.ps1 `
  -UpstreamRoot D:\ratwood-runtime\upstream `
  -WorkdirRoot D:\ratwood-runtime\workdir `
  -RunBuildFirst
```

## Notes

- `start-server.ps1` replaces the listed core files, then overlays `mods/`.
- `auto_update.py` can use `server_overlay/patches/` to apply the mod prelude as patch files instead of copying core files directly.
- `mods/_autogen.dm` is intentionally not stored; build regenerates it.
- The generated workdir is disposable. Delete it anytime and rebuild from upstream.
