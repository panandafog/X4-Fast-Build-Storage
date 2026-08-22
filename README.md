# Fast Build Storage

Fast Build Storage removes construction-storage docking bottlenecks for player
freighters in X4: Foundations. When a player ship carrying construction
materials reaches its target build storage, the mod delivers the contracted
wares remotely and releases the active docking orders.

- [Nexus Mods page](https://www.nexusmods.com/x4foundations/mods/2324)
- [Download version 1.01](https://github.com/panandafog/X4-Fast-Build-Storage/releases/download/v1.01/fast_build_storage_v1.01.zip)
- [All GitHub releases](https://github.com/panandafog/X4-Fast-Build-Storage/releases)

## Requirements

- X4: Foundations 9.00 or newer.
- [Mod Support APIs](https://www.nexusmods.com/x4foundations/mods/503)
  by SirNukes. It provides the in-game Extension Options menu used by this mod.

## Installation

1. Download and extract the release ZIP into:

   ```text
   <X4 Foundations>/extensions/
   ```

2. Confirm the final path is:

   ```text
   <X4 Foundations>/extensions/fast_build_storage/content.xml
   ```

3. Install and enable **Mod Support APIs** by SirNukes.
4. Enable **Fast Build Storage** in X4's Extensions menu, then load a save.

Make a backup save before updating or uninstalling any mod.

## Settings

After loading a save, open **Settings → Extension Options → Fast Build
Storage**. Changes are saved by Mod Support APIs and apply immediately, except
that a changed scan interval takes effect after the current wait finishes.

- **Remote unload radius:** 1–50 km; default 5 km.
- **Scan interval:** 1–60 seconds; default 5 seconds.
- **Maximum unloads per scan:** 1–99 or unlimited (`∞`); default unlimited.

The per-scan limit counts successful remote unloads, not ships merely inspected.
Ships left after reaching the limit are eligible again on the next scan.

## Features

- Scans player-owned ships at the configured interval.
- Handles player-owned ships delivering to player-owned build storages only.
- Works within the configured distance of the build storage.
- Finds the parent `TradePerform` delivery even while `DockAt` or `DockAndWait`
  is active.
- Transfers only the contracted ware when the ship carries, and construction
  still needs, the full trade-deal amount.
- Releases only matching `DockAt` / `DockAndWait` children and their parent
  `TradePerform`; unrelated queued player orders are preserved.
- Never handles NPC deliveries or payments.
- Does not act on the ship currently occupied by the player.

The default trigger distance is 5 km. Version 1.01 does not check dock
availability or queue length before remote unloading.

## Debugging

For detailed diagnostics, launch X4 with:

```text
-debug all -logfile fbs-debug.txt -scriptlogfiles
```

The concise mod log is written to:

```text
<X4 user profile>/logs/FastBuildStorage/fbs.txt
```

A successful delivery contains:

```text
[FBS] commit: ...
[FBS] releasing dock child: ... id=DockAt ...
[FBS] completed: ...
[FBS] scan completed: deliveries=..., limit=...
```

`skipped incomplete deal` is expected protection: the ship does not have the
entire contracted cargo, or construction no longer needs the full amount.

## Development

Build a clean installation archive on macOS or Linux with:

```bash
./build_mod_zip.sh
```

The script creates `dist/fast_build_storage_v1.01.zip` and includes only the
files needed by the mod.

Every push to `master` builds the archive, uploads it to the workflow run, and
creates or updates the GitHub Release matching the version in `content.xml`.
