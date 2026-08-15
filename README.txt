Fast Build Storage v0.2
===========================

Purpose
-------
Remote-unload PLAYER-OWNED ships that are currently executing a TradePerform
delivery to a PLAYER-OWNED station build storage. This is a proof-of-concept
intended to remove L/XL docking queues at construction storage.

Install
-------
Copy the whole folder "fast_build_storage_mvp" into:

  <X4 Foundations>/extensions/

Final path must be:

  <X4 Foundations>/extensions/fast_build_storage_mvp/content.xml

Test on a backup save first.

Current behaviour
-----------------
* Poll interval: 5 seconds.
* Trigger radius: 5 km from build storage.
* The radius trigger is deliberate: v0.2 does NOT check whether docks are busy
  or whether a queue exists.
* Only player-owned ships.
* Only player-owned build storages: NPC trades are ignored completely.
* Only the CURRENT order, and only if its id is TradePerform.
* Only deliveries where the trade deal buyer/owner is a build storage.
* Transfers only the ware from that trade deal.
* Transfers only a complete deal: cargo on the ship and current construction
  need must each be at least the whole trade-deal amount. Partial deals are
  logged and left to vanilla.
* Cancels that TradePerform order after the remote transfer.
* Does not touch the ship currently occupied by the player.

Not implemented yet
-------------------
* NPC trading and payment handling.
* Config UI / configurable range.
* Queue-length / free-dock detection (intentionally not planned for this build).
* Compatibility handling for alternative trade-order implementations.
* Explicit trade-completed event synthesis. The mod still cancels the order;
  this is limited to player-to-player transfers until vanilla reservation cleanup
  can be verified from the game scripts.

How to test
-----------
1. Make a manual save.
2. Pick one player L freighter carrying e.g. Hull Parts.
3. Give it a normal delivery/sell order to the BUILD STORAGE of a station that
   currently needs those wares.
4. Watch the ship as it gets within 5 km of the build storage.
5. Within ~5 seconds, expected result:
   - cargo decreases on the ship;
   - build storage receives the ware;
   - the TradePerform order disappears/cancels;
   - the ship should not wait for the build-storage dock.

Debug
-----
Launch X4 with:

  -debug all -logfile fbs-debug.txt -scriptlogfiles

Search the resulting fbs-debug.txt for:

  FastBuildStorageMVP
  [FBS]
  Property lookup failed
  [=ERROR=]

With -scriptlogfiles, the mod also creates a concise trace at:

  <X4 user profile>/logs/FastBuildStorageMVP/fbs.txt

The trace reports scan heartbeat, matching candidates, a pending transfer,
completion, and skipped incomplete deals. It is intentionally verbose for
testing; disable the debug_to_file nodes once the MVP is validated.

If it does not work, send the lines around any [FBS] message and any script/XML
errors mentioning FastBuildStorageMVP.

IMPORTANT MVP WARNING
---------------------
This has been checked for XML well-formedness, but NOT validated against your
exact X4 9.0 md.xsd/common.xsd. If the game reports an MD schema/runtime error,
that log is exactly what we need for the next iteration.
