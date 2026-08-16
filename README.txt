Fast Build Storage 1.0
======================

Fast Build Storage removes construction-storage docking bottlenecks for the
player's freighters. When a player ship carrying construction materials reaches
the target build storage, the mod delivers the contracted wares remotely and
releases its active docking orders.

Installation
------------
Extract the release ZIP into:

  <X4 Foundations>/extensions/

The final path must be:

  <X4 Foundations>/extensions/fast_build_storage/content.xml

Enable **Fast Build Storage** in the Extensions menu, then load a save. Make a
backup save before updating or uninstalling any mod.

Current behaviour
-----------------
* Scans player-owned ships every 5 seconds.
* Handles player-owned ships delivering to player-owned build storages only.
* Works within 5 km of the build storage.
* Inspects every active order layer, so an active `DockAt` / `DockAndWait` does
  not hide the parent `TradePerform` delivery.
* Transfers only the contracted ware and only when the ship carries the full
  trade-deal amount and construction still needs that full amount.
* Releases only the matching `DockAt` / `DockAndWait` children and their
  `TradePerform` parent. Other queued player orders are preserved.
* Never handles NPC deliveries or payments.
* Does not act on the ship currently occupied by the player.

The 5 km trigger is deliberate. Version 1.0 does not check dock availability or
queue length before remote unloading.

Debugging
---------
For detailed diagnostics, launch X4 with:

  -debug all -logfile fbs-debug.txt -scriptlogfiles

The concise mod log is written to:

  <X4 user profile>/logs/FastBuildStorage/fbs.txt

Successful delivery looks like:

  [FBS] commit: ...
  [FBS] releasing dock child: ... id=DockAt ...
  [FBS] completed: ...

`skipped incomplete deal` is expected protection: the ship does not have the
entire contracted cargo, or the construction no longer needs the full amount.

Development
-----------
On macOS, build a clean installation archive with:

  ./build_mod_zip.sh

The script creates `dist/fast_build_storage_v1.0.zip` and includes only files
needed by the mod. GitHub Actions runs the same script automatically for every
push to `master` and uploads the ZIP as a workflow artifact.
