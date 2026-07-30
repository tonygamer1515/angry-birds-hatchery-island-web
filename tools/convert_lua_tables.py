#!/usr/bin/env python3
"""Execute data-only decrypted Lua files with Lupa and emit browser JSON."""
from pathlib import Path
import argparse, json
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


def run(path: Path, global_name: str):
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.execute(path.read_text())
    return convert(lua.globals()[global_name])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('decrypted', type=Path)
    ap.add_argument('output', type=Path)
    args = ap.parse_args()
    h = args.decrypted / 'hatchery/scripts'
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.execute((h / 'hatcheryAnimations.lua').read_text())
    lua.execute((h / 'hatcheryObjects.lua').read_text())
    task_lua = LuaRuntime(unpack_returned_tuples=True)
    task_lua.execute((h / 'birdDefinitions.lua').read_text())
    task_lua.execute((h / 'eggAccessory.lua').read_text())
    task_lua.execute((h / 'TaskManager.lua').read_text())
    data = {
        'map': run(h / 'hatcheryDefaultMap.lua', 'hatcheryMap'),
        'objects': convert(lua.globals().hatcheryObjects),
        'animations': convert(lua.globals().hatcheryAnimations),
        'animationIds': convert(lua.globals().hatcheryAnimationID),
        'birdDefinitions': run(h / 'birdDefinitions.lua', 'Bird'),
        'prototypeBirds': run(h / 'hatcheryBirdsSaves.lua', 'hatcheryBirds'),
        'tasks': convert(task_lua.globals().TaskManager.TASKS),
    }
    args.output.write_text(json.dumps(data, separators=(',', ':')))
    print('Wrote', args.output)


if __name__ == '__main__':
    main()
