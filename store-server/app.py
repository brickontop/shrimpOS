#!/usr/bin/env python3
"""Static signed-manifest development server. Terminate TLS upstream in production."""
from flask import Flask, send_from_directory
from pathlib import Path
app=Flask(__name__); ROOT=Path(__file__).parent/'public'
@app.get('/<path:name>')
def get(name): return send_from_directory(ROOT,name,conditional=True)
if __name__=='__main__': app.run(host='127.0.0.1',port=8080)
