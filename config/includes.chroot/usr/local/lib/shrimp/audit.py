#!/usr/bin/env python3
"""Approval gate and audit record utility; no operation is automatic."""
import datetime, hashlib, json, os, sys
from pathlib import Path

ROOT=Path('/var/lib/shrimp/proposals'); LOG=Path('/var/log/shrimp-audit.log')
def propose(action, reason, before='', after=''):
    import difflib
    now=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    diff=''.join(difflib.unified_diff(before.splitlines(True),after.splitlines(True),'before','after'))
    digest=hashlib.sha256((action+reason+diff).encode()).hexdigest()
    ROOT.mkdir(parents=True,exist_ok=True)
    (ROOT/f'{now}-{digest}.diff').write_text(diff)
    record={'timestamp':now,'author':os.environ.get('SUDO_USER',os.environ.get('USER','unknown')),'action':action,'reason':reason,'sha256':digest,'diff':str(ROOT/f'{now}-{digest}.diff')}
    (ROOT/f'{now}-{digest}.json').write_text(json.dumps(record,sort_keys=True)+'\n')
    print(json.dumps(record,indent=2)); return record
def approve(record, phrase):
    if os.environ.get('SHRIMP_TEST_SANDBOX') != '1':
        if input(f"Type exactly {phrase!r} to approve: ") != phrase: raise SystemExit('Not approved; no change made.')
    with LOG.open('a') as f: f.write(json.dumps(record,sort_keys=True)+'\n')
