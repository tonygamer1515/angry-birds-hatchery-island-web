#!/usr/bin/env python3
from pathlib import Path
import argparse, json
from lupa import LuaRuntime, lua_type


def convert(value):
    kind=lua_type(value)
    if kind=='function':return None
    if kind!='table':return value
    keys=list(value.keys());numeric=keys and all(isinstance(k,(int,float)) and int(k)==k and k>=1 for k in keys)
    if numeric and sorted(int(k) for k in keys)==list(range(1,len(keys)+1)):
        return [convert(value[i]) for i in range(1,len(keys)+1)]
    return {str(k):convert(value[k]) for k in keys if lua_type(value[k])!='function'}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('decrypted',type=Path);ap.add_argument('output',type=Path);a=ap.parse_args();levels=[];fail=[]
    for path in sorted((a.decrypted/'levels').rglob('*.lua')):
        try:
            lua=LuaRuntime(unpack_returned_tuples=True);lua.execute(path.read_text());g=lua.globals();world=convert(g.world)
            if not world:continue
            levels.append({'id':path.stem,'pack':path.parent.name,'world':world,'counts':convert(g.counts),'camera':convert(g.castleCameraData)})
        except Exception as e:fail.append((str(path),str(e)))
    a.output.write_text(json.dumps({'levels':levels,'failures':fail},separators=(',',':')));print('levels',len(levels),'failures',len(fail))
if __name__=='__main__':main()
