#!/bin/sh
set -eu
python3 - <<'PY'
import hashlib,json,pathlib
r=pathlib.Path('.'); files=[]
for p in sorted(r.rglob('*')):
 if p.is_file() and '.git' not in p.parts and p.name!='manifest.json': files.append({'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
pathlib.Path('manifest.json').write_text(json.dumps({'schema':1,'source_date_epoch':__import__('os').environ.get('SOURCE_DATE_EPOCH'),'files':files,'licenses':'See LICENSES.txt'},indent=2)+'\n')
PY
