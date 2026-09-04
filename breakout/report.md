# Breakout — Model Comparison Report

**Spec:** `prompt.md` · **Date:** 2026-09-02 · **Models:** 11 · **Method:** Static code review (no browser execution)

> Single-file `800×600` Breakout (Canvas + `requestAnimationFrame` + `deltaTime`). Tests verify the prompt spec without running the games — see “How This Was Tested”.

---

## Contents

1. [Ranking](#tldr--ranking) — who passed?
2. [How This Was Tested](#how-this-was-tested)
3. [Scoring Rubric](#scoring-rubric)
4. [Compliance Matrix](#compliance-matrix) — criterion-by-criterion
5. [Detailed Breakdown](#detailed-breakdown) — tiered analysis
6. [Environment](#environment--hardware)

---

## TL;DR — Ranking

| Rank | Model | Score | Verdict | File | LOC |
|-----:|-------|------:|---------|------|----:|
| **1** | **qwen3-8-RIDGE** | **9.5** | ✅ Pass | `models/qwen3-8-RIDGE/index.html` | 324 |
| **2** | **qwen3-8-Q4XS** | **9.4** | ✅ Pass | `models/qwen3-8-Q4XS/index.html` | 309 |
| **3** | **qwen3-8-Q3S** | **9.3** | ✅ Pass | `models/qwen3-8-Q3S/index.html` | 342 |
| **4** | **qwen3-8-Q2** | **9.2** | ✅ Pass | `models/qwen3-8-Q2/index.html` | 278 |
| **5** | **qwen3-8-Q3XL** | **9.1** | ✅ Pass | `models/qwen3-8-Q3XL/index.html` | 342 |
| 6 | tiel-coder-35b-IQ3_XXS | 7.5 | ⚠️ Partial | `models/tiel-coder-35b-IQ3_XXS/index.html` | 465 |
| 7 | gemma4-26A4B | 7.0 | ⚠️ Partial | `models/gemma4-26A4B/index.html` | 337 |
| 8 | ornith-1.5-9b | 6.5 | ❌ Fail | `models/ornith-1-5-9b/index.html` | 442 |
| 9 | qwen3-5-9b-Q8 | 4.0 | ❌ Fail | `models/qwen3-5-9b-Q8/index.html` | 385 |
| 10 | gemma4-E4B | 3.5 | ❌ Fail | `models/gemma4-E4B/index.html` | 426 |
| 11 | gpt-20-Q8 | 2.5 | ❌ Fail | `models/gpt-20-Q8/index.html` | 244 |

> **Takeaway:** `ornith` would be #1 with one fix. **Use `qwen3-8-RIDGE` as reference** — new `Q4XS` (9.4) is the closest challenger, `Q3S` / `Q2` / `Q3XL` remain drop-ins. Open the `index.html` gallery to play all 11 side-by-side.

---

## How This Was Tested

**Static analysis only** — `grep` + `read`, no browser.

| What was checked | How it was checked |
|------------------|--------------------|
| Canvas `800×600` | `width="800" height="600"` |
| Single file, no `src` / `<img>` / `TODO` | `grep <script src / <img / TODO` |
| `rAF` + `deltaTime` | `requestAnimationFrame` + `dt=(now-last)/1000` + clamp |
| 8×5 bricks + row colors | `COLS/ROWS` + `ROW_COLORS` length |
| Controls (Arrows / A-D / Space) | `ArrowLeft / KeyA / Space` + state machine |
| Paddle angle | `relative/hit * π/3` + `Math.sin/cos` |
| Lives & reset on paddle | `lives--` → `resetBall` / `stuck=true` |
| Win/lose + 4 screens + restart | `every(!alive)` + `gameover/victory` + click |
| HUD (10 pts + lives) | `Score / Lives` + `+=10` |

> **Runtime check not done:** open `file://` in Chrome, press `Space`/`←`, assert `y>H` loses a life, bricks add 10, 40 bricks → victory.

---

## Scoring Rubric

`10` = perfect spec.

- **−2** unplayable / critical
- **−1.5** broken `dt`
- **−1** per missing `pause` / `wait` / inverted physics
- **−0.5** visual / layout deviation

> Gallery cards add `func` (compliance), `quality` (structure/rAF/tunnel), `LOC` (`wc -l`).

---

## Compliance Matrix

**Legend:** `✅` Pass — meets spec fully · `⚠️` Partial — minor deviation but playable · `❌` Fail — breaks spec · `➖` clamp only (dt clamped, still can tunnel) · `✅ sub` — sub-stepped movement (no tunneling)

*Columns:* `RIDGE`=qwen3-8-RIDGE · `Q4XS`=qwen3-8-Q4XS · `Q3S`=qwen3-8-Q3S · `Q2`=qwen3-8-Q2 · `Q3XL`=qwen3-8-Q3XL · `tiel`=tiel-coder-35b · `g26A`=gemma4-26A4B · `ornith`=ornith-1.5-9b · `Q5-9b`=qwen3-5-9b-Q8 · `gE4B`=gemma4-E4B · `gpt20`=gpt-20-Q8

| Criterion (from `prompt.md`) | RIDGE | Q4XS | Q3S | Q2 | Q3XL | tiel | g26A | ornith | Q5-9b | gE4B | gpt20 |
|------------------------------|-------|------|-----|----|------|------|------|--------|-------|------|-------|
| 800×600 canvas | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 8×5 bricks | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️* | ✅ | ✅ | ⚠️† | ✅ |
| Row colors (5) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| ←→ / A-D controls | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Space: launch + pause | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ⚠️‡ | ✅ | ❌ | ❌ | ❌ |
| Paddle angle (±60°) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| 3 lives + wait on paddle | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌§ | ❌ | ❌ | ❌ |
| Win / lose conditions | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌§ | ✅ | ✅ | ❌ |
| 4 screens + restart | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ | ⚠️ | ⚠️ | ✅ |
| HUD: 10 pts + lives | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌¶ | ✅ | ✅ | ✅ |
| rAF + deltaTime | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ⚠️ |
| Anti-tunneling | ✅ sub | ✅ sub | ✅ sub | ➖ clamp | ➖ | ➖ | ➖ | ➖ | ❌ | ❌ | ❌ |

**What is “Anti-tunneling”?** At high speed, the ball can “tunnel” through bricks/paddle between frames. `✅ sub` = ball movement is split into small sub-steps (`ceil(speed*dt / (radius/2))`) so it checks collision multiple times per frame — no tunneling. `➖ clamp` = only caps `dt` to `0.05` — safe at low speed but can still tunnel if very fast. `❌` = no protection.

**Footnotes — plain language:**

* `*` **gemma4-26A4B:** Brick width calc ignores gap/padding — 8 bricks overflow the 800 px canvas.
* `†` **gemma4-E4B:** Brick width `(800-10)/8` = 880 px total → bricks clipped off-screen.
* `‡` **gemma4-26A4B:** Pressing Space while paused calls `launch()` and resets ball direction instead of resuming.
* `§` **ornith-1.5-9b:** `checkBallFell()` / `loseLife()` exist but are never called in `update()` → ball falling never costs a life, so you can never lose.
* `¶` **ornith-1.5-9b:** Score is `10 * (5 - row)` (10–50) instead of flat `10` per brick as spec requires.

---

## Detailed Breakdown

### Tier 1 — Fully Compliant

#### 1) qwen3-8-RIDGE — 9.5 · 324 lines

**Why #1:** Only impl with clamped `rAF` + sub-step tunnel fix + separate `ready` state. `MAX_DT 0.033`, `ceil(dist/(R*0.9))`, `BRICK_MARGIN` with gap, 5 colors. Space `start/ready→launch` / `playing→paused` exact, paddle `hit*π/3`, lives → `ready` wait, 5 screens + click/any-key. **No bugs.** `Q4XS` is the same tier but needs two presses from START.

#### 2) qwen3-8-Q4XS — 9.4 · 309 lines — NEW

**New entry — #2:** Clean `rAF` clamp `0.05` + fine sub-step `ceil((SPEED*dt)/(R/2))`, correct `BRICK_W` with margin/gap, 5 row colors. Paddle `rel*π/3` sin/cos, overlap-based brick bounce, lives `resetBall` + `stuck` wait, `paused` flag + `PLAYING` state. Minor: `START` → `PLAYING` (stuck) requires **two** Spaces to launch (vs RIDGE one) — `launch()` uses `−π/2 ±0.3` variance (allowed). Otherwise fully compliant, shadows/gloss, hearts HUD, `click` + any-key restart.

#### 3) qwen3-8-Q3S — 9.3 · 342 lines

Clamp `0.05` + sub-step, Space correct, `loseLife→resetBallOnPaddle`, paddle `rel*π/3`. Minor: `WIN` vs `victory`, duplicate `preventDefault`.

#### 4) qwen3-8-Q2 — 9.2 · 278 lines

`vx*dt`, `PADDLE_SPEED*dt`, clamp `0.05`, `stuck=true` wait. No sub-step but `430*0.05=21 < 24` safe. Most compact of Tier 1.

#### 5) qwen3-8-Q3XL — 9.1 · 342 lines

Clamp, angle `−π/2+rel*π/3`, launch variance `±π/6`, side test `px<py`.

### Tier 2 — Playable with Deviations

#### 6) tiel-coder-35b-IQ3_XXS — 7.5 · 465 lines

`PLAYING→launchBall` never enters `PAUSED` → Space can't pause. Otherwise solid (clamp, sin/cos, wait). Largest due to `mousemove`.

#### 7) gemma4-26A4B — 7.0 · 337 lines

Clamp `0.1` ok, but brickW ignores gap → overflow. `PAUSED→launch()` overwrites velocity; `START` hides board.

#### 8) ornith-1.5-9b — 6.5 · 442 lines

**Best code, one-line bug:** `checkBallFell()` never called → can't lose. Fix: call it after `collideBricks()`. Weighted score `10*(ROWS-row)` ≠ 10.

### Tier 3 — Broken

#### 9) qwen3-5-9b-Q8 — 4.0 · 385 lines

No `dt`, `if(!playing) return` stops render, paddle only on `keydown`, no pause, `resetBall` auto-launches.

#### 10) gemma4-E4B — 3.5 · 426 lines

Faux `dt` `*16.666`, instant `dx`, inverted `cos/sin` → center shoots sideways, Space never pauses, brick 880>800.

#### 11) gpt-20-Q8 — 2.5 · 244 lines

No clamp (`lastTime=0` → 1.5 s teleport), dead Space `start→playing` leaves `vx/vy=0` → **ball never moves**. Shortest but unplayable.

---

## Environment · Hardware

> Captured via `fastfetch` on the inference host. Relevant for reproducibility.

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
