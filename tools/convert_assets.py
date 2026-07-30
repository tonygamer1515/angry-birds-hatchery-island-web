#!/usr/bin/env python3
"""Convert Rovio KA3D sprite DATs and uncompressed PVR v2 textures for the web port."""
from pathlib import Path
from PIL import Image
import argparse, json, struct


def decode_pvr(path: Path) -> Image.Image:
    blob = path.read_bytes()
    header = struct.unpack('<13I', blob[:52])
    header_size, height, width, _, flags, _, bpp, *_ = header
    if header_size != 52 or blob[44:48] != b'PVR!':
        raise ValueError(f'Unsupported PVR header: {path}')
    fmt = flags & 0xFF
    data = memoryview(blob)[52:]
    pixels = []
    if fmt == 16 and bpp == 16:  # RGBA4444
        for i in range(0, width * height * 2, 2):
            value = data[i] | (data[i + 1] << 8)
            pixels.append(((value >> 12 & 15) * 17, (value >> 8 & 15) * 17,
                           (value >> 4 & 15) * 17, (value & 15) * 17))
    elif fmt == 19 and bpp == 16:  # RGB565
        for i in range(0, width * height * 2, 2):
            value = data[i] | (data[i + 1] << 8)
            pixels.append((round((value >> 11 & 31) * 255 / 31),
                           round((value >> 5 & 63) * 255 / 63),
                           round((value & 31) * 255 / 31), 255))
    elif fmt == 22 and bpp == 8:  # intensity/grayscale
        pixels = [(value, value, value, 255) for value in data[:width * height]]
    elif fmt in (24, 25):  # PVRTC 2bpp / 4bpp
        try:
            import texture2ddecoder
        except ImportError as exc:
            raise ValueError('PVRTC conversion requires texture2ddecoder') from exc
        is_2bpp = fmt == 24
        level_size = max(width, 16 if is_2bpp else 8) * max(height, 8) * (2 if is_2bpp else 4) // 8
        decoded = texture2ddecoder.decode_pvrtc(bytes(data[:level_size]), width, height, is_2bpp)
        return Image.frombytes('RGBA', (width, height), decoded)
    else:
        raise ValueError(f'Unsupported PVR format {fmt}, {bpp} bpp: {path}')
    image = Image.new('RGBA', (width, height))
    image.putdata(pixels)
    return image


def parse_dat(path: Path) -> dict:
    blob = path.read_bytes()
    if blob[:4] != b'KA3D' or blob[8:12] != b'SPRT':
        raise ValueError(f'Not a KA3D SPRT file: {path}')
    offset = 16
    version = struct.unpack_from('>H', blob, offset)[0]; offset += 2
    length = struct.unpack_from('>H', blob, offset)[0]; offset += 2
    texture = blob[offset:offset + length].decode(); offset += length
    count = struct.unpack_from('>H', blob, offset)[0]; offset += 2
    sprites = {}
    for _ in range(count):
        length = struct.unpack_from('>H', blob, offset)[0]; offset += 2
        name = blob[offset:offset + length].decode(); offset += length
        x, y, w, h = struct.unpack_from('>4H', blob, offset); offset += 8
        ox, oy = struct.unpack_from('>2h', blob, offset); offset += 4
        sprites[name] = {'x': x, 'y': y, 'w': w, 'h': h, 'ox': ox, 'oy': oy}
    return {'version': version, 'texture': texture, 'sprites': sprites}


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument('app', type=Path, help='Path to AngryBirdsIslandHD.app')
    ap.add_argument('output', type=Path, help='Web project root')
    args = ap.parse_args()
    data = args.app / 'data_ipad'
    atlas_out = args.output / 'assets' / 'atlases'
    atlas_out.mkdir(parents=True, exist_ok=True)

    selected = list((data / 'hatchery').rglob('*.pvr'))
    selected += [data / 'images/1024x768' / name for name in (
        'BACKGROUNDS_MAIN_1.pvr', 'MENU_ELEMENTS_1.pvr', 'BUTTONS_SHEET_1.pvr',
        'BUTTONS_HATCHERY_1.pvr', 'MENU_HATCHERY_1.pvr', 'LEVELSELECTION_HATCHERY_1.pvr',
        'INGAME_BIRDS_1.pvr', 'INGAME_BIRDS_2.pvr', 'INGAME_BLOCKS_1.pvr', 'INGAME_BLOCKS_2.pvr',
        'INGAME_GROUNDS_1.pvr', 'INGAME_SKIES_1.pvr', 'INGAME_SKIES_2.pvr', 'INGAME_SKIES_3.pvr',
        'LEVELSELECTION_SHEET_1.pvr', 'LEVELSELECTION_SHEET_2.pvr', 'LEVELSELECTION_SHEET_3.pvr', 'LEVELSELECTION_SHEET_4.pvr',
        'MENU_RESULT_SCREEN_1.pvr', 'THEME_01_PARALLAX_1.pvr', 'THEME_01_THEME_GROUND_1.pvr')]
    selected += [data / 'images/1024x768' / name for name in (
        'MENU_ELEMENTS_2.png', 'MENU_ELEMENTS_3.png', 'POPUPS_SHEET_1.png')]

    atlas_urls = {}
    for source in selected:
        if not source.exists():
            continue
        target = atlas_out / (source.stem + '.webp')
        image = Image.open(source).convert('RGBA') if source.suffix.lower() == '.png' else decode_pvr(source)
        image.save(target, 'WEBP', quality=92, method=6)
        atlas_urls[source.name] = f'assets/atlases/{target.name}'

    registry = {'atlases': {}, 'sprites': {}}
    dats = list((data / 'hatchery').rglob('*.dat')) + list((data / 'images/1024x768').glob('*.dat'))
    for dat in dats:
        try:
            parsed = parse_dat(dat)
        except ValueError:
            continue
        texture = parsed['texture']
        if texture not in atlas_urls:
            continue
        registry['atlases'][texture] = atlas_urls[texture]
        for name, sprite in parsed['sprites'].items():
            registry['sprites'][name] = {'atlas': texture, **sprite}
    (args.output / 'assets/data/sprites.json').write_text(json.dumps(registry, separators=(',', ':')))
    print(f'Converted {len(atlas_urls)} atlases and {len(registry["sprites"])} sprites')


if __name__ == '__main__':
    main()
