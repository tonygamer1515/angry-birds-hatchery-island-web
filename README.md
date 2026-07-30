# Angry Birds: Hatchery Island — Browser Preservation Port

A new browser port of Rovio's unreleased 2011 iPad prototype from the supplied IPA.

Live development build: https://tonygamer1515.github.io/angry-birds-hatchery-island-web/

Source repository: https://github.com/tonygamer1515/angry-birds-hatchery-island-web

This is an active preservation port. The playable Hatchery systems are available now; remaining native gameplay paths are tracked below and will be added incrementally.

## Current playable build

- Original Angry Birds HD/Hatchery title presentation.
- Exact 70×70 isometric Hatchery Island map.
- 6,000+ original map tiles, cliffs, water, foliage, rocks and animated decoration objects.
- Touch/mouse camera panning and pinch/wheel zoom with pointer-cancel, lost-capture, app-backgrounding and multi-touch recovery so the map cannot become stuck.
- Original obstacle clearing and persistent world saves.
- Place, move and remove nests.
- Add eggs, wait for the original timer, spend stars to hurry, then choose exactly one gender and one of 12 original voice packs before hatching.
- Gender and voice persist per bird; male/female task achievements only advance for the selected gender.
- 216 prototype bird combinations recovered from `hatcheryBirdsSaves.lua`.
- Layered body, eyes, beak and accessory rendering, blinking and idle motion.
- Bird designer, full-flock inventory and four recovered task tiers.
- Every hatched bird forms the active slingshot roster—there are no pre-granted starter birds, no authored-level slot truncation, and waiting birds render behind the sling.
- All 325 bundled level Lua files are distinct, converted with zero failures and shown in the authored `episodes.lua` order with original pack/level icons and Lua filenames.
- All 34,394 world objects and 1,787 joint records are retained.
- Slingshot physics uses the KA3D 20-pixel scale, 0.92 body factor, authored radii/polygons, materials, gravity, defence, strength, mass/impulse damage and active block-crush damage.
- Original score rules restored: 5,000 points per pig, 500/default block bonuses, 10,000 per unused bird, and each level's silver/gold thresholds from `starLimits.lua`.
- Impulse/mass collision damage and active crush handling let moving wood, glass and stone blocks damage and kill pigs.
- Hatchery-bird shape/colour specialty combinations are used in level play, including boost, explosion, split-bombling and egg-drop variants.
- Eleven original sky/parallax/foreground/floor themes, authored opening cameras, camera follow and manual pan.
- Original Hatchery and gameplay ambience, fanfares, UI effects, 12 Hatchery voices, and complete bird/select/launch/collision plus pig/wood/stone/glass sound packs.
- Six-page first-run tutorial covers island controls, nests, gender/voice hatching, the complete flock, pack selection and slingshot physics.
- Mobile Safari uses lazy atlas decoding and versioned service-worker caching.

## Source recovery

The IPA uses Rovio's native KA3D/Lua 5.1 engine rather than Unity. The original assets contain:

- 462 AES-encrypted Lua files, all successfully decrypted to readable source.
- 1,620 named sprites registered from 66 DAT-linked atlases (73 texture sheets converted).
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
- Remaining composite-sprite placement refinements for some multi-part parallax decorations; every theme's underlying original sheets are now converted and selected.
- Remaining bird-specialty edge cases and exact vertical/zoom camera interpolation.
- Exact KA3D composite-sprite definitions and remaining animation edge cases.
- Full regression test pass, iPad performance pass, then the new public GitHub repository and Pages deployment.
