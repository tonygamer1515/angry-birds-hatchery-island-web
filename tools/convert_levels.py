#!/usr/bin/env python3
"""Convert every original IPA level and its authored episode metadata to JSON.

The level files contain the exact KA3D object coordinates. episodes.lua supplies the
original (non-numeric) presentation order, and starLimits.lua supplies Rovio's score
thresholds.  Keep all files in the IPA, including content commented out in this test
build, because the preservation port intentionally exposes all 325 shipped levels.
"""
from pathlib import Path
import argparse
import json
import re
from lupa import LuaRuntime, lua_type


def convert(value):
    kind = lua_type(value)
    if kind == 'function':
        return None
    if kind != 'table':
        return value
    keys = list(value.keys())
    numeric = keys and all(isinstance(k, (int, float)) and int(k) == k and k >= 1 for k in keys)
    if numeric and sorted(int(k) for k in keys) == list(range(1, len(keys) + 1)):
        return [convert(value[i]) for i in range(1, len(keys) + 1)]
    return {str(k): convert(value[k]) for k in keys if lua_type(value[k]) != 'function'}


def read_episode_order(path: Path):
    """Read order even from block-commented episode definitions shipped in the IPA."""
    orders = {}
    current_pack = None
    for line in path.read_text(errors='replace').splitlines():
        folder = re.search(r'folder_name\s*=\s*"([^"]+)"', line)
        if folder:
            current_pack = folder.group(1)
            orders.setdefault(current_pack, [])
            continue
        if current_pack:
            match = re.search(r'\{\s*name\s*=\s*"([^"]+)"', line)
            if match:
                name = match.group(1)
                if name not in orders[current_pack]:
                    orders[current_pack].append(name)
    return orders


def read_star_limits(path: Path):
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.execute(path.read_text())
    limits = {}
    globals_table = lua.globals()
    for key in globals_table.keys():
        if not isinstance(key, str) or not key.startswith('Level'):
            continue
        value = globals_table[key]
        if lua_type(value) != 'table':
            continue
        item = convert(value)
        if isinstance(item, dict) and ('silverScore' in item or 'goldScore' in item):
            limits[key] = item
    return limits


def natural_number(name):
    matches = re.findall(r'\d+', name)
    return int(matches[-1]) if matches else 999999


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('decrypted', type=Path)
    parser.add_argument('output', type=Path)
    args = parser.parse_args()

    episode_orders = read_episode_order(args.decrypted / 'scripts' / 'episodes.lua')
    star_limits = read_star_limits(args.decrypted / 'scripts' / 'starLimits.lua')
    order_maps = {pack: {name: i for i, name in enumerate(names)} for pack, names in episode_orders.items()}

    levels = []
    failures = []
    for path in sorted((args.decrypted / 'levels').rglob('*.lua')):
        try:
            lua = LuaRuntime(unpack_returned_tuples=True)
            lua.execute(path.read_text())
            globals_table = lua.globals()
            world = convert(globals_table.world)
            if not world:
                continue
            pack = path.parent.name
            authored_order = order_maps.get(pack, {}).get(path.stem)
            levels.append({
                'id': path.stem,
                'pack': pack,
                'order': authored_order if authored_order is not None else natural_number(path.stem),
                'world': world,
                'counts': convert(globals_table.counts),
                'camera': convert(globals_table.castleCameraData),
                'stars': star_limits.get(path.stem) or ({'silverScore': 1000, 'goldScore': 2000} if path.stem.startswith('LevelGE_') else None),
            })
        except Exception as exc:
            failures.append((str(path), str(exc)))

    args.output.write_text(json.dumps({
        'levels': levels,
        'episodeOrder': episode_orders,
        'failures': failures,
    }, separators=(',', ':')))
    print('levels', len(levels), 'failures', len(failures), 'star limits', sum(bool(x['stars']) for x in levels))


if __name__ == '__main__':
    main()
