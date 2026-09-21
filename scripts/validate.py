#!/usr/bin/env python3
"""Validate the benchmark results and gallery files for both suites."""
import json
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
SUITES = ["breakout", "breakout-3d"]

errors = []

for suite in SUITES:
    suite_dir = ROOT / suite
    results_path = suite_dir / "results.json"
    if not results_path.exists():
        errors.append(f"{suite}: missing results.json")
        continue

    data = json.loads(results_path.read_text(encoding="utf-8"))
    models = data.get("models", [])
    if not models:
        errors.append(f"{suite}: results.json has no models")

    for entry in models:
        rel = entry.get("file")
        if not rel:
            errors.append(f"{suite}: a model entry has no 'file' field")
            continue
        if not (suite_dir / rel).exists():
            errors.append(f"{suite}/{rel}: referenced by results.json but missing")

    if not (suite_dir / "index.html").exists():
        errors.append(f"{suite}: missing gallery index.html")

if errors:
    print("Validation failed:")
    for error in errors:
        print(f" - {error}")
    sys.exit(1)

print("OK: results.json and galleries are consistent.")
