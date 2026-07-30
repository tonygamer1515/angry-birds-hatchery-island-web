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
| 325 level Lua tables | Browser level database |
| Native rigid-body world | Matter.js circles, boxes, materials and collisions |
| Bird specialty dispatch | Speed, explosion, split, boomerang and egg drop |
| KA3D audio calls | HTML Audio using original files |

## Verified tests

- Title and world enter with no browser console errors.
- Exact island map renders from original sprites and object definitions.
- Nest → egg → hurry → hatch flow succeeds.
- Currency deductions and local persistence verified.
- Bird object appears after hatch.
- Fresh/legacy saves no longer receive two synthetic starter birds.
- Hatched custom bird becomes the level-launch projectile.
- Pack 1 level loads original blocks and pigs with no browser errors.
- Slingshot drag/release and Matter.js simulation verified.
- Pointer cancellation, lost capture, blur/background recovery and post-pinch single-pointer panning handled.
- Level camera now fits each Lua level’s authored coordinate extent and follows launched birds.
- All 325 converted levels are exposed through the episode selector.

## Not yet declared complete

The public GitHub repository and Pages development build are now enabled. Remaining native gameplay and UI paths will be translated and regression-tested through incremental repository updates.
