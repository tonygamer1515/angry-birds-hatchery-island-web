# Angry Birds: Hatchery Island — Browser Preservation Port

A new browser port of Rovio's unreleased 2011 iPad prototype from the supplied IPA.

Live development build: https://tonygamer1515.github.io/angry-birds-hatchery-island-web/

Source repository: https://github.com/tonygamer1515/angry-birds-hatchery-island-web

This is an active preservation port. The playable Hatchery systems are available now; remaining native gameplay paths are tracked below and will be added incrementally.

## Current playable build

- Original Angry Birds HD/Hatchery title presentation.
- Exact 70×70 isometric Hatchery Island map.
- 6,000+ original map tiles, cliffs, water, foliage, rocks and animated decoration objects.
- Touch/mouse camera panning and pinch/wheel zoom.
- Original obstacle clearing and persistent world saves.
- Place, move and remove nests.
- Add eggs, wait for the original timer, spend stars to hurry, and hatch birds.
- 216 prototype bird combinations recovered from `hatcheryBirdsSaves.lua`.
- Layered body, eyes, beak and accessory rendering, blinking and idle motion.
- Bird designer, bird inventory and four recovered task tiers.
- Hatchery birds form the active slingshot roster—there are no pre-granted starter birds after save migration.
- All 325 bundled level Lua files converted to browser data with zero conversion failures.
- Matter.js slingshot physics, original level structures, pigs, block materials, damage, scoring and three-star results.
- Hatchery bird specialties mapped into level play: speed, explosion, split, boomerang and egg-drop abilities.
- Original Hatchery ambient audio, fanfares, UI effects, level sounds and title music.
- Responsive iPad landscape UI and service-worker caching.

## Source recovery

The IPA uses Rovio's native KA3D/Lua 5.1 engine rather than Unity. The original assets contain:

- 462 AES-encrypted Lua files, all successfully decrypted to readable source.
- 895 named sprites from 33 KA3D sprite atlases.
- Original PVR v2 RGBA4444/RGB565 textures converted without vertical flipping.
- A 70×70 Tiled-style Lua map with 5 layers and 1,500+ decoration objects.
- 164 Hatchery object definitions.
- 26 original keyframe animation definitions.
- 216 prototype bird recipes.
- Four original Hatchery task groups.

The decrypted source is preserved under `reference/decrypted-lua/`. Conversion tools are under `tools/`.

## Included original IPA

`Angry-Birds-Hatchery-Island.ipa`

SHA-1: `b1505cd3d9f433bcbe4ac3079263ebdf8e73b685`

## Run locally

```bash
python3 -m http.server 8080
```

Then open <http://localhost:8080>.

## Remaining translation work

- Remaining Hatchery dialogs and exact menu panel layouts.
- Egg Painter canvas and saved egg textures.
- Nest and egg accessory designers.
- Exact episode-specific parallax/ground artwork for later packs; all 325 converted levels are already exposed through the episode selector.
- Remaining bird-specialty edge cases and native camera timing.
- Exact KA3D composite-sprite definitions and remaining animation edge cases.
- Full regression test pass, iPad performance pass, then the new public GitHub repository and Pages deployment.
