# Breakout 3D — Model Comparison Report

**Spec:** `prompt.md` · **Date:** 2026-09-03 · **Models:** 11 (all submitted; tiel arrived late and got the same harness) · **Method:** Static code review **+ headless-Chromium runtime test**

> Single-file 3D Breakout (Three.js 0.160.0 via importmap + `requestAnimationFrame` + `Clock.getDelta()` clamped to `0.05`). Unlike the 2D edition, these games need **internet access** (three.js loads from `unpkg.com` CDN).

---

## Contents

1. [Ranking](#tldr--ranking) — who is actually playable?
2. [How This Was Tested](#how-this-was-tested)
3. [Scoring Rubric](#scoring-rubric)
4. [Compliance Matrix](#compliance-matrix) — criterion-by-criterion
5. [Detailed Breakdown](#detailed-breakdown) — tiered analysis
6. [Environment](#environment--hardware)

---

## TL;DR — Ranking

| Rank | Model | Score | Verdict | Runtime proof | LOC |
|-----:|-------|------:|---------|---------------|----:|
| **1** | **qwen3-8-RIDGE** | **9.6** | ✅ Pass | launches, score 20, life lost, CAM MANUAL, 0 errors | 906 |
| **2** | **qwen3-8-Q4XS** | **9.5** | ✅ Pass | START→READY→PLAYING per spec, score 80, trail, 0 errors | 1023 |
| **3** | **qwen3-8-Q3S** | **9.4** | ✅ Pass | score 10, life lost, 0 errors | 1056 |
| **4** | **qwen3-8-Q2** | **9.2** | ✅ Pass | score 20, 0 errors | 888 |
| **5** | **qwen3-8-Q3XL** | **9.1** | ✅ Pass | score 30, burst particles, 0 errors | 975 |
| **6** | **gemma4-26A4B** | **8.8** | ✅ Pass | score 70, ball+trail flying, CAM MANUAL, 0 errors | 696 |
| 7 | qwen3-5-9b-Q8 | 3.0 | ❌ Fail | `reading 'mesh'` at load; menu-only, click doesn't start | 1163 |
| 8 | gpt-20-Q8 | 2.5 | ❌ Fail | `diff.abs is not a function` every frame; black screen | 657 |
| 9 | ornith-1-5-9b | 2.0 | ❌ Fail | `THREE.RoundedBoxGeometry is not a constructor`; black screen | 902 |
| 10 | tiel-coder-35b-IQ3_XXS | 1.8 | ❌ Fail | `THREE is not defined` (addon imported, THREE itself not); no canvas | 963 |
| 11 | gemma4-E4B-Q8-uncesored | 1.5 | ❌ Fail | `THREE is not defined`; no `<canvas>` at all | 1506 |

> **Takeaway:** Static review lied — the prettiest code (`ornith`, `E4B`) doesn't run. **Use `qwen3-8-RIDGE` as reference** (verified: launch, scoring, life loss, manual camera, mute, zero errors). `gemma4-26A4B` is the comeback story: statically the weakest (7.0), at runtime a rock-solid 8.8 with the highest test score (70). Late arrival `tiel` mirrors `ornith`'s bug in reverse (imports the addon, forgets `THREE` itself). Every failure is a **one-line-class bug** (missing import / wrong API call) — see footnotes. Open the `index.html` gallery to play the 6 working builds (needs internet for the three.js CDN).

---

## How This Was Tested

**Static analysis + runtime execution** (this is what demoted 5 models).

Runtime setup: local `http.server` + headless Chromium (SwiftShader WebGL) via Playwright, CDN reachable. Per model: load → wait → screenshot → `Space` → arrows → `Space` → screenshot → `C`/`R`/`M`; second round captured error stacks, tried click fallback, and sanity-checked camera/mute. Evidence is screenshots + console errors:

| Model | Runtime observation |
|-------|---------------------|
| RIDGE | overlay hides, ball plays, **score 20**, a life is lost (♥♥·), `CAM: MANUAL` after `C`, 0 errors |
| Q4XS | `START→READY→PLAYING` on successive Spaces (spec-correct), **score 80**, trail ghosts, 0 errors |
| Q3S | **score 10**, life lost (2 hearts), 0 errors |
| Q2 | **score 20**, 0 errors |
| Q3XL | **score 30**, green burst particles mid-flight, 0 errors |
| gemma26A | **score 70**, ball + trail in flight, `CAM: MANUAL`, 0 errors |
| qwen3-5 | `Cannot read properties of undefined (reading 'mesh')` at load; frozen `Press Space to Start` menu; click also fails; no 3D scene |
| gpt-20 | `diff.abs is not a function` ×29 (per frame); overlay reaches READY then loop dies before `render` → black |
| ornith | `THREE.RoundedBoxGeometry is not a constructor` at init (paddle creation); black screen, menu only |
| E4B | `THREE is not defined` at load (zero `import` statements); no canvas element created |
| tiel | `THREE is not defined` at load (imports only `{ RoundedBoxGeometry }`, never `THREE` itself); polished menu, no canvas, Space/click dead |

Static checks (same as before, now secondary): exact shims+importmap, `Math.min(clock.getDelta(), 0.05)`, ACES + PCFSoft, fog/camera constants, playfield/physics constants, 6-state machine, light rig, canvas-texture sizes, effects, manual-cam clamps, octave audio, HUD.

> **Runtime check not done:** full playthrough to victory/game-over + restart (too slow to bot-play); life loss was observed live (RIDGE, Q3S), which exercises the same path.

---

## Scoring Rubric

`10` = perfect spec **and** runs clean.

- **−6 to −8.5** fatal runtime error: stuck at menu / black screen / nothing renders (unplayable ⇒ fail, regardless of static polish)
- **−1** per missing polish group in a *working* build (octave audio / victory jingle / frozen particles / border frame / manual-cam jump)
- **−0.5** structure/clarity nit among otherwise identical builds

> Playability dominates: a working 8.8 beats a beautiful 3.0. Gallery cards show `func` (compliance), `quality` (structure/loop/fidelity), `LOC` (`wc -l`). All 11 models submitted and were runtime-tested.

---

## Compliance Matrix

**Legend:** `✅` Pass — meets spec / works · `❌` Fail — broken at runtime · `⚠️` Partial — deviation but playable

*Columns:* `RIDGE`=qwen3-8-RIDGE · `Q4XS`=Q4XS · `Q3S`=Q3S · `Q2`=Q2 · `Q3XL`=Q3XL · `26A`=gemma4-26A4B · `Q5`=qwen3-5-9b-Q8 · `gpt`=gpt-20-Q8 · `orn`=ornith-1.5-9b · `E4B`=gemma4-E4B-uncesored · `tiel`=tiel-coder-35b

| Criterion | RIDGE | Q4XS | Q3S | Q2 | Q3XL | 26A | Q5 | gpt | orn | E4B | tiel |
|-----------|-------|------|-----|----|------|-----|----|-----|-----|-----|------|
| ▶ **Runtime: renders + launches + scores, 0 errors** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌§ | ❌¶ | ❌‖ | ❌⋆ | ❌†† |
| importmap + shims exact | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌* | ✅ |
| rAF + `getDelta()` clamp 0.05 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | —† | —† | —† | ❌‡ | —† |
| ACES + PCFSoft shadows | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | —† | —† | —† | ❌ | —† |
| Playfield + physics (static) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | —† | ⚠️# | ✅ | ✅ | —† |
| 6 states + reset (static) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | —† | —† | —† | ✅ | —† |
| Lights + textures + starfield | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | —† | —† | —† | ✅ | —† |
| Effects (death/pulse/trail/burst/shake) | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️° | —† | —† | —† | ✅ | —† |
| Manual cam (takeover/clamps/R) | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️# | —† | —† | —† | ✅ | —† |
| Audio octave + jingles + mute | ✅ | ✅ | ✅ | ✅ | ✅ | ❌✚ | —† | —† | —† | ✅ | —† |
| HUD + 4 screens | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ | ✅ | ✅ |
| Single file, no ext libs / TODO | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

`—†` = unverifiable: init/loop dies before the feature can execute (code may look right, game never runs).

**Footnotes — plain language:**

* `*` **E4B:** no `es-module-shims@1.8.0` script tag — but that hardly matters, since the module has **zero `import` statements**: `THREE is not defined` at load, no canvas is ever created. Only static DOM is visible. Worst failure.
* `§` **qwen3-5:** `Cannot read properties of undefined (reading 'mesh')` at load. Nicest menu/HUD of the failures, but Space *and* click both dead — no 3D scene.
* `¶` **gpt-20:** `diff.abs()` — `THREE.Vector3` has no `.abs()`. Thrown in brick collision every frame *before* `renderer.render`, so the screen stays black at READY. Fix: component-wise `Math.abs`.
* `‖` **ornith:** calls `new THREE.RoundedBoxGeometry(...)` for paddle + bricks but only ever runs `import * as THREE from 'three'` — the addon is never imported. Dies at paddle creation (canvas exists, stays black). Fix: one import line. (Ironic repeat of its 2D one-line bug, where `checkBallFell()` was never *called*.)
* `††` **tiel:** the exact mirror — imports only `{ RoundedBoxGeometry }` from `three/addons/...` but never `import * as THREE from 'three'`. Dies even earlier (no canvas at all). Fix: one import line. Ranked a hair below ornith for that reason.
* `°` **26A4B:** particle bursts spawn but are never updated (frozen); no `LineLoop` border.
* `#` **26A4B:** manual camera snaps to defaults instead of taking over (jump). gpt-20's static physics row is `⚠️` independently (octave at full gain etc.) — moot, it never runs.
* `✚` **26A4B:** single-oscillator beeps (no `freq*2` layer), no `523/659/784` victory arpeggio — yet it plays flawlessly, hence still **pass**.

---

## Detailed Breakdown

### Tier 1 — Verified playable (headless Chromium, screenshots + 0 errors)

#### 1) qwen3-8-RIDGE — 9.6 · 906 lines

**Why #1:** the only build verified end-to-end in one session — launch, **score 20**, life loss (♥♥·), `C` → `CAM: MANUAL`, `M` mute, zero console errors. Octave-correct `beep()`, `atan2` no-jump takeover, all textures + 260 stars, `exp()` auto-cam decay. **Reference.**

#### 2) qwen3-8-Q4XS — 9.5 · 1023 lines

Highest test score (**80**, 8 bricks) with visible trail ghosts. `START→READY→PLAYING` across two Spaces is exactly what the spec demands. Zero errors.

#### 3) qwen3-8-Q3S — 9.4 · 1056 lines

**Score 10** plus an observed life loss (2 hearts) — the lose-a-life path works. Soft-attack audio envelopes. Zero errors.

#### 4) qwen3-8-Q2 — 9.2 · 888 lines

**Score 20**, zero errors. Most compact of the working set; ranked below Q3S only for leaner structure.

#### 5) qwen3-8-Q3XL — 9.1 · 975 lines

**Score 30** with a green particle burst caught mid-flight in the screenshot. Zero errors. Launch inline in the Space handler — structure nit only.

#### 6) gemma4-26A4B — 8.8 · 696 lines — RUNTIME COMEBACK

Static review ranked it last (7.0). Runtime says otherwise: **score 70 — the highest of all**, ball + trail flying, manual camera toggling, **zero errors**. The static deductions are real (mono beeps, no victory jingle, frozen burst particles, no border, cam jump) but none stop gameplay. Playable beats pretty: **pass**.

### Tier 2 — Broken at runtime (fatal JS errors, never playable — 5 builds)

#### 7) qwen3-5-9b-Q8 — 3.0 · 1163 lines

The most deceptive: polished gradient menu, complete HUD, OOP architecture — and `reading 'mesh'` at load. Neither Space nor click starts it; no 3D scene ever appears. Static 8.5 → runtime 3.0.

#### 8) gpt-20-Q8 — 2.5 · 657 lines

Smallest file; init succeeds, overlay even reaches READY — then `diff.abs()` throws **every frame before render**. Black screen. One-line fix (`Math.abs` per component).

#### 9) ornith-1-5-9b — 2.0 · 902 lines

Was #4 statically. Dies at paddle creation: addon never imported. Black screen + menu only. One-line fix (the import). Second one-line-bug contest in a row for this model.

#### 10) tiel-coder-35b-IQ3_XXS — 1.8 · 963 lines — LATE, TESTED

Arrived after the first pass and got the same harness: `THREE is not defined` at load — the mirror of ornith's bug (imports the addon, forgets `THREE` itself). Exact shims+importmap, polished rainbow menu, but no canvas is created and Space/click are dead. One-line fix. (Its 2D entry scored 7.5.)

#### 11) gemma4-E4B-Q8-uncesored — 1.5 · 1506 lines

Largest file, least runtime: `THREE is not defined`, **no canvas element**. (Dir keeps upstream typo `uncesored`.)

---

## Environment · Hardware

> Same inference host as the 2D edition (`breakout/report.md`). Captured via `fastfetch`. Runtime tests ran here in headless Chromium (SwiftShader) with the unpkg CDN reachable.

| Component | Value |
|-----------|-------|
| Host | `A320M-HD2` |
| OS | `CachyOS x86_64` · Kernel `7.2.0-1-cachyos` |
| CPU | `AMD Ryzen 5 1600 (12) @ 3.70 GHz` — 6c/12t Zen 1 |
| GPU | `NVIDIA GeForce RTX 4060 Ti [Discrete]` (16GB) |
| Memory | `15.53 GiB` (3.87 used) + Swap `15.53 GiB` (0.6 used) |
| Disk | `295.40 GiB btrfs` (221.38 used — 75%) |
| Display | `G27F 1920×1080 @ 60 Hz` |
| Shell | `fish 4.8.1` · `10.5p1` · Uptime `2h 7m` |
| Packages | `1404 pacman + 11 flatpak` |

Implications: 16GB VRAM → `gemma4-26B-A4B-Q4` needs `n-gpu-layers 26` + heavy quants; Zen 1 → benefits from `draft-mtp` 2–4. Results are for **RTX 4060 Ti 16GB + R5 1600**.

> **Repro note:** the 3D gallery needs internet (three.js 0.160.0 via `unpkg.com` + ES modules, so serve with `python -m http.server`, not `file://`). Runtime harness: Playwright + headless Chromium, Space/arrows/C/R/M + click, screenshots + console capture.
