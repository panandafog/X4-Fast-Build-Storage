Fast Build Storage MVP v0.1
===========================

Purpose
-------
Remote-unload PLAYER-OWNED ships that are currently executing a TradePerform
SELL delivery to a station build storage. This is a proof-of-concept intended
to remove L/XL docking queues at construction storage.

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
* Only player-owned ships.
* Only the CURRENT order, and only if its id is TradePerform.
* Only deliveries where the trade deal buyer/owner is class.buildstorage.
* Transfers only the ware from that trade deal.
* Amount is capped by:
    - cargo actually on the ship,
    - trade-deal amount,
    - amount currently needed by the build processor.
* Cancels that TradePerform order after the remote transfer.
* Does not touch the ship currently occupied by the player.

Not implemented yet
-------------------
* NPC sellers and payment handling.
* Config UI / configurable range.
* Queue-length detection.
* Compatibility handling for alternative trade-order implementations.
* Explicit trade-completed event synthesis (we cancel the order after transfer).

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

  -debug scripts -logfile debuglog.txt

Search the resulting debuglog.txt for:

  [FBS]

If it does not work, send the lines around any [FBS] message and any script/XML
errors mentioning FastBuildStorageMVP.

IMPORTANT MVP WARNING
---------------------
This has been checked for XML well-formedness, but NOT validated against your
exact X4 9.0 md.xsd/common.xsd. If the game reports an MD schema/runtime error,
that log is exactly what we need for the next iteration.
