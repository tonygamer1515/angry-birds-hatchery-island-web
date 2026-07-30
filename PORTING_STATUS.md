# Porting status

## Architecture identified

- Native executable: 32-bit ARMv7 Mach-O
- Engine: Rovio KA3D
- Script runtime: Lua 5.1
- Rendering: OpenGL ES sprite atlases
- Texture formats: PVR v2 RGBA4444, RGB565, I8, and some PVRTC
- Data format: KA3D `SPRT` sprite metadata plus Lua/Tiled map tables

## Code extraction

All 462 `.lua` resources were decrypted successfully using the original Angry Birds AES-256-CBC key. Each decrypted payload is a 7-Zip archive containing readable Lua source; this prototype does not require bytecode decompilation.

## Browser mappings completed

| Original system | Browser implementation |
|---|---|
| `createHatcheryMap` | Culled Canvas2D isometric renderer |
| `getWorldCoordinatesForTileMapIndexes` | Exact 196×97 isometric transform |
| `moveTileCameraPosition` | Pointer/touch panning |
| `setTileMapScale` | Pinch/wheel/button zoom |
| `WorldSelectionPanel` | Bottom inventory toolbar |
| `WorldSelectionView` | Snapped placement/movement mode |
| `HatcheryDynamicObject` | Persistent map object model |
| `HatcheryNestObject` | Nest lifecycle and context actions |
| `HatcheryEggObject` | Incubation timer, hurry and hatching |
| `HatcheryBirdObject` | Layered custom bird renderer |
| `BirdDesigner` | Interactive body/eyes/beak/accessory panel |
| `TaskManager` | Four recovered task tiers and rewards |
| `hatcheryAnimations` | Idle sway, blink, wobble and timer motion |
| Hatchery selected-bird list | Active slingshot roster |
| 325 level Lua tables + `episodes.lua` | Distinct browser levels in Rovio's authored world order |
| `physicsToWorld = 20` + `sizeFactor = 0.92` | Source-pixel-to-physics body sizing |
| Native circles/boxes/polygons | Matter.js bodies using authored radii and vertices |
| KA3D materials and collision damage | Original density/friction/restitution, defence, strength and colour damage factors |
| `starLimits.lua` and score constants | Original 1/2/3-star thresholds and pig/block/unused-bird bonuses |
| `checkLevelComplete` | Requires a fired bird, all goals cleared and a stable/timeout ending window |
| Hatchery `Bird:triggerSpecialty` | Shape/colour boost, explosion, split-bombling and egg-drop combinations |
| KA3D audio calls | Complete per-bird launch/select/collision, material, pig, ambience and Hatchery voice packs |
| First-run help flow | Six-page persistent tutorial plus sling reminder |

## Verified tests

- Title and world enter with no browser console errors.
- Exact island map renders from original sprites and object definitions.
- Nest → egg → hurry → gender/voice choice → hatch flow succeeds.
- A female-only hatch produced task progress `[1,0,0]` and achievements `{male:0,female:1}`—one bird no longer grants both genders.
- Currency deductions, bird gender, selected voice and local persistence verified.
- Bird object appears after hatch and plays its saved voice.
- Fresh/legacy saves no longer receive two synthetic starter birds.
- Hatched custom bird becomes the level-launch projectile.
- Pack 1 level loads original blocks and pigs with no browser errors.
- All 325 level records have distinct authored world signatures; all 325 have original star thresholds.
- A headless Matter.js stability pass over all 325 layouts reports no pre-shot goal loss with the corrected gravity/body scale.
- Slingshot pull length and launch impulse now use the original 5.4-unit maximum and KA3D force conversion.
- Pointer cancellation, lost capture, blur/background recovery and post-pinch single-pointer panning handled.
- Level camera now fits each Lua level’s authored coordinate extent and follows launched birds.
- All 18 normal worlds and Golden Eggs are exposed through the original-art pack selector.
- Automated browser pass opened the first authored level from all 19 packs with different IDs/object counts and no console errors.
- Joint-heavy `pack8/LevelP3_313` loaded 195 bodies and all four native constraints.
- Three-bird browser test reports `flock: 3`, visibly queues the waiting birds and launches the first with finite moving physics.
- Controlled mass-impact test dropped a 1.49-mass beam onto a pig and removed the pig goal through block damage.
- First-run tutorial opens at step 1/6 and persists completion.
- Lazy three-atlas loading removes the mobile-Safari all-at-once decode failure that produced `LOAD ERROR: undefined`.

## Not yet declared complete

The public GitHub repository and Pages development build are now enabled. Remaining native gameplay and UI paths will be translated and regression-tested through incremental repository updates.
