# local-llm — Local LLM Coding Benchmark

A small, reproducible test harness for evaluating **locally-hosted LLMs on end-to-end code generation**.

Each test gives every model the same natural-language spec — *"write a complete Breakout game in a single HTML file"* — and scores whether the returned file actually runs, plays, and meets the spec. No API models, no scaffolding, no fix-ups: one prompt in, one `index.html` out.

Current suites:

- [`breakout/`](breakout/) — 2D Breakout on Canvas (vanilla JS, offline)
- [`breakout-3d/`](breakout-3d/) — 3D Breakout on Three.js 0.160.0 (importmap + CDN)

Each suite contains its own `prompt.md`, per-model outputs in `models/*/index.html`, `report.md` / `report.html` with full analysis, `results.json` with machine-readable scores, and an `index.html` gallery to play all outputs side-by-side.

## Hardware & Environment

All inference and testing ran on the same consumer desktop (captured via `fastfetch`).

| Component | Value |
|-----------|-------|
| Host | `A320M-HD2` |
| OS | `CachyOS x86_64`, Kernel `7.2.0-1-cachyos` |
| CPU | `AMD Ryzen 5 1600` — 6c/12t Zen 1 @ 3.70 GHz |
| GPU | `NVIDIA GeForce RTX 4060 Ti 16GB` [Discrete] |
| Memory | `15.53 GiB` DDR4 + `15.53 GiB` swap |
| Disk | `295.40 GiB` btrfs (75% used) |
| Display | `G27F 1920×1080 @ 60 Hz` |

Practical implications:

- 16 GB VRAM fits 9–35B MoE/dense models with heavy GGUF quants (`Q2_K_XL` → `Q8_0`), mostly fully offloaded (`n-gpu-layers 99`). The exception is `gemma4-26B-A4B-Q4`, which needed `n-gpu-layers 26`.
- The older Zen 1 CPU makes speculative decoding worthwhile — most configs use `spec-type draft-mtp` with `spec-draft-n-max 2–4`.
- Common runtime defaults: `ctx-size 32768–131072`, `temp 0.6`, `top-p 0.95`, `top-k 20` (64 for Gemma), `flash-attn on`, `cache-type-k/v q8_0`.

See `*/models-configurations.md` / `*.html` for the full resolved router configs per model.

## Models Tested (11)

The same 11 local GGUF models were tested in both suites (4 additional router presets were defined but not tested).

| # | Family / Base | Variant tested | Quant | HF repo |
|---|---------------|----------------|-------|---------|
| 1–5 | Qwen3 30B-A3B (MoE) | `qwen3-8-RIDGE` (Ridge 3.7bpw), `qwen3-8-Q4XS`, `qwen3-8-Q3S`, `qwen3-8-Q2`, `qwen3-8-Q3XL` | `3.7bpw` / `Q4_XS` / `IQ3_S` / `Q2_K_XL` / `Q3_K_XL` | [empero-ai/Qwen3.8-27B-Ridge-GGUF](https://huggingface.co/empero-ai/Qwen3.8-27B-Ridge-GGUF), [unsloth/Qwen3-30B-A3B-GGUF](https://huggingface.co/unsloth/Qwen3-30B-A3B-GGUF) |
| 6 | Qwen3.5 9B (dense) | `qwen3-5-9b-Q8` | `Q8_0` | [unsloth/Qwen3.5-9B-GGUF](https://huggingface.co/unsloth/Qwen3.5-9B-GGUF) |
| 7 | Gemma 4 26B-A4B (MoE) | `gemma4-26A4B` (+ `mmproj` + MTP draft) | `Q4_K_XL` (QAT) | [unsloth/gemma-4-26B-A4B-it-qat-GGUF](https://huggingface.co/unsloth/gemma-4-26B-A4B-it-qat-GGUF) |
| 8 | Gemma 4 E4B (uncensored) | `gemma4-E4B` (+ `mmproj`) | `Q8_K_P` | [HauhauCS/Gemma-4-E4B-Uncensored](https://huggingface.co/HauhauCS/Gemma-4-E4B-Uncensored-HauhauCS-Aggressive) |
| 9 | gpt-oss 20B | `gpt-20-Q8` | `Q8_K_XL` (UD) | [unsloth/gpt-oss-20b-GGUF](https://huggingface.co/unsloth/gpt-oss-20b-GGUF) |
| 10 | Ornith 1.5 9B | `ornith-1-5-9b` (+ `mmproj`) | `Q8_0` | [ornith-ai/Ornith-1.5-9B](https://huggingface.co/ornith-ai/Ornith-1.5-9B) |
| 11 | Tiel-Coder 35B-A3B (MoE coder) | `tiel-coder-35b-IQ3_XXS` (+ `mmproj`) | `IQ3_XXS` | [peculiar-ragdoll/Tiel-Coder-35B-A3B-GGUF](https://huggingface.co/peculiar-ragdoll/Tiel-Coder-35B-A3B-GGUF) |

Reasoning models generally ran with `reasoning-effort medium`, `reasoning-preserve true`, `reasoning-budget 4096` (5000 for Q3XL).

## Test Suites

- **Breakout (2D)** — `breakout/` — classic Arkanoid in one offline HTML file (vanilla Canvas + `requestAnimationFrame`). See `breakout/prompt.md`, `breakout/report.md`, `breakout/results.json`.
- **Breakout 3D** — `breakout-3d/` — 3D Arkanoid in one HTML file (Three.js 0.160.0 via importmap + CDN). See `breakout-3d/prompt.md`, `breakout-3d/report.md`, `breakout-3d/results.json`.

Detailed rankings, compliance matrices, and per-model analysis live inside each suite's `report.md` / `report.html`.

## Repository Layout

```text
.
├── README.md
├── breakout/
│   ├── prompt.md                  # 2D spec
│   ├── report.md / report.html    # full 2D analysis
│   ├── results.json               # machine-readable 2D scores
│   ├── models-configurations.md / .html
│   ├── index.html                 # gallery — play all 11 in browser
│   └── models/<name>/index.html   # one output per model
└── breakout-3d/
    ├── prompt.md                  # 3D spec
    ├── report.md / report.html    # full 3D analysis + runtime evidence
    ├── results.json               # machine-readable 3D scores
    ├── models-configurations.md / .html
    ├── index.html                 # gallery (needs internet for three.js CDN)
    └── models/<name>/index.html
```
