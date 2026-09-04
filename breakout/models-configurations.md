# Models — Router Configurations (Breakout test subset)

> Source: router presets INI dump. Parsed 2026-09-02. Filtered to the 11 models tested for Breakout (`results.json:5`, `report.md:12`). Commented `;` lines removed. Each section below is the **full resolved configuration** (defaults + overrides merged).

Links: `prompt.md` · `report.md` / `report.html` · `results.json` · `index.html` (gallery) · `models-configurations.html` · `models/*/index.html`

## Environment · Hardware

Captured via `fastfetch` on the inference host.

| Component | Value |
|-----------|-------|
| Host | `A320M-HD2` |
| OS | `CachyOS x86_64` · Kernel `7.2.0-1-cachyos` |
| CPU | `AMD Ryzen 5 1600 (12) @ 3.70 GHz` — 6c/12t Zen 1 |
| GPU | `NVIDIA GeForce RTX 4060 Ti [Discrete]` (16GB) |
| Memory | `15.53 GiB` (3.87 used) + Swap `15.53 GiB` |
| Disk | `295.40 GiB btrfs` (221.38 used — 75%) |
| Display | `G27F 1920×1080 @ 60 Hz` |

See also `report.md` / `report.html` for implications (16GB VRAM → `n-gpu-layers 26` + heavy quants; Zen 1 → MTP draft).

---

## Tested for Breakout (11) — rank order

| Rank | Breakout dir | Router section | Score · Verdict | Hugging Face |
|-----:|--------------|----------------|-----------------|--------------|
| 1 | `models/qwen3-8-RIDGE/index.html` | `[qwen3.8-27b-ridge-3.7bpw]` | 9.5 · pass | [Qwen3.8-27B-Ridge-3.7bpw](https://huggingface.co/empero-ai/Qwen3.8-27B-Ridge-GGUF) |
| 2 | `models/qwen3-8-Q4XS/index.html` | `[qwen3.8-27b-Q4XS-unsloth]` | 9.4 · pass | [Qwen3.8-27B-UD-Q4_XS](https://huggingface.co/unsloth/Qwen3-30B-A3B-GGUF) |
| 3 | `models/qwen3-8-Q3S/index.html` | `[qwen3.8-27b-Q3S-unsloth]` | 9.3 · pass | [Qwen3.8-27B-UD-IQ3_S](https://huggingface.co/unsloth/Qwen3-30B-A3B-GGUF) |
| 4 | `models/qwen3-8-Q2/index.html` | `[qwen3.8-27-Q2_K_XL-unsloth]` | 9.2 · pass | [Qwen3.8-27B-UD-Q2_K_XL](https://huggingface.co/unsloth/Qwen3-30B-A3B-GGUF) |
| 5 | `models/qwen3-8-Q3XL/index.html` | `[qwen3.8-27b-Q3XL-unsloth]` | 9.1 · pass | [Qwen3.8-27B-UD-Q3_K_XL](https://huggingface.co/unsloth/Qwen3-30B-A3B-GGUF) |
| 6 | `models/tiel-coder-35b-IQ3_XXS/index.html` | `[tiel-coder-35b-IQ3_XXS]` | 7.5 · partial | [Tiel-Coder-35B-A3B](https://huggingface.co/peculiar-ragdoll/Tiel-Coder-35B-A3B-GGUF) |
| 7 | `models/gemma4-26A4B/index.html` | `[gemma4-26B-A4B-Q4]` | 7.0 · partial | [Gemma-4-26B-A4B-it](https://huggingface.co/unsloth/gemma-4-26B-A4B-it-qat-GGUF) |
| 8 | `models/ornith-1-5-9b/index.html` | `[ornith-1.5-9b]` | 6.5 · fail | [Ornith-1.5-9B](https://huggingface.co/ornith-ai/Ornith-1.5-9B) |
| 9 | `models/qwen3-5-9b-Q8/index.html` | `[qwen3.5-9b-Q8-unsloth]` | 4.0 · fail | [Qwen3.5-9B](https://huggingface.co/unsloth/Qwen3.5-9B-GGUF) |
| 10 | `models/gemma4-E4B/index.html` | `[gemma4-E4B-Q8-uncensored]` | 3.5 · fail | [Gemma-4-E4B-Uncensored](https://huggingface.co/HauhauCS/Gemma-4-E4B-Uncensored-HauhauCS-Aggressive) |
| 11 | `models/gpt-20-Q8/index.html` | `[gpt-20b-unsloth-Q8-UD]` | 2.5 · fail | [gpt-oss-20b](https://huggingface.co/unsloth/gpt-oss-20b-GGUF) |

> Naming: `gemma4-26A4B` on disk = `gemma4-26B-A4B-Q4` in router; `qwen3-8-Q2` = `qwen3.8-27-Q2_K_XL-unsloth` (router typo `27` vs `27b`). HF links point to the base model / GGUF repo; quantization is the local `*.gguf` file.

Excluded (4 INI sections not tested): `[gpt-20b-Q5-unsloth]`, `[lfm2.5-2.6b]`, `[qwen3.5-9b-heretic-neomax-Q4]`, `[qwen3.5-9b-heretic-neomax-Q8]`.

---

## 1) qwen3-8-RIDGE — `[qwen3.8-27b-ridge-3.7bpw]` — 9.5 pass

- **Breakout:** `models/qwen3-8-RIDGE/index.html` (324 lines) — rank 1
- **GGUF:** `qwen3.8-27b-ridge-3.7bpw/Qwen3.8-27B-Ridge-3.7bpw.gguf`
- **Hugging Face:** [empero-ai/Qwen3.8-27B-Ridge-GGUF](https://huggingface.co/empero-ai/Qwen3.8-27B-Ridge-GGUF) · base [Qwen/Qwen3-30B-A3B](https://huggingface.co/Qwen/Qwen3-30B-A3B)

Full resolved config (commented lines filtered):

| Key | Value |
|-----|-------|
| `model` | `qwen3.8-27b-ridge-3.7bpw/Qwen3.8-27B-Ridge-3.7bpw.gguf` |
| `spec-type` | `draft-mtp` |
| `spec-draft-n-max` | `2` |
| `reasoning-effort` | `medium` |
| `reasoning-preserve` | `true` |
| `reasoning-budget` | `4096` |
| `ctx-size` | `65536` |
| `parallel` | `1` |
| `n-gpu-layers` | `99` |
| `flash-attn` | `on` |
| `cache-type-k` | `q8_0` |
| `cache-type-v` | `q8_0` |
| `batch-size` | `2048` |
| `ubatch-size` | `512` |
| `temp` | `0.6` |
| `top-p` | `0.95` |
| `top-k` | `20` |
| `min-p` | `0.0` |
| `repeat-penalty` | `1.0` |
| `presence-penalty` | `0.0` |

Raw INI (filtered):
```ini
[qwen3.8-27b-ridge-3.7bpw]
model              = qwen3.8-27b-ridge-3.7bpw/Qwen3.8-27B-Ridge-3.7bpw.gguf
spec-type          = draft-mtp
spec-draft-n-max   = 2
reasoning-effort   = medium
ctx-size           = 65536
parallel           = 1
reasoning-preserve = true
reasoning-budget   = 4096
top-p              = 0.95
top-k              = 20
min-p              = 0.0
presence-penalty   = 0.0
repeat-penalty     = 1.0
```

Notes: 27B Ridge 3.7 bpw, MTP draft-2 speculative decoding, reasoning 4096.

---

## 2) qwen3-8-Q4XS — `[qwen3.8-27b-Q4XS-unsloth]` — 9.4 pass

- **Breakout:** `models/qwen3-8-Q4XS/index.html` (309 lines) — rank 2
- **GGUF:** `qwen3.8-27b-Q4XS-unsloth/Qwen3.8-27B-UD-Q4_XS.gguf`
- **Hugging Face:** [unsloth/Qwen3-30B-A3B-GGUF](https://huggingface.co/unsloth/Qwen3-30B-A3B-GGUF) · base [Qwen/Qwen3-30B-A3B](https://huggingface.co/Qwen/Qwen3-30B-A3B)

Full resolved config (commented lines filtered):

| Key | Value |
|-----|-------|
| `model` | `qwen3.8-27b-Q4XS-unsloth/Qwen3.8-27B-UD-Q4_XS.gguf` |
| `spec-type` | `draft-mtp` |
| `spec-draft-n-max` | `2` |
| `reasoning-effort` | `medium` |
| `reasoning-preserve` | `true` |
| `reasoning-budget` | `4096` |
| `ctx-size` | `65536` |
| `parallel` | `1` |
| `n-gpu-layers` | `99` |
| `flash-attn` | `on` |
| `cache-type-k` | `q8_0` |
| `cache-type-v` | `q8_0` |
| `batch-size` | `2048` |
| `ubatch-size` | `512` |
| `temp` | `0.6` |
| `top-p` | `0.95` |
| `top-k` | `20` |
| `min-p` | `0.0` |
| `repeat-penalty` | `1.0` |
| `presence-penalty` | `0.0` |

Raw INI (filtered):
```ini
[qwen3.8-27b-Q4XS-unsloth]
model              = qwen3.8-27b-Q4XS-unsloth/Qwen3.8-27B-UD-Q4_XS.gguf
spec-type          = draft-mtp
spec-draft-n-max   = 2
reasoning-effort   = medium
ctx-size           = 65536
parallel           = 1
reasoning-preserve = true
reasoning-budget   = 4096
top-p              = 0.95
top-k              = 20
min-p              = 0.0
presence-penalty   = 0.0
repeat-penalty     = 1.0
```

Notes: Qwen3.8 27B dense, Q4_XS quant — same MTP-2 / reasoning 4096 as RIDGE/Q3S. New #2, only needs two Spaces from START.

---

## 3) qwen3-8-Q3S — `[qwen3.8-27b-Q3S-unsloth]` — 9.3 pass

- **Breakout:** `models/qwen3-8-Q3S/index.html` (342 lines)
- **GGUF:** `qwen3.8-27b-Q3S-unsloth/Qwen3.8-27B-UD-IQ3_S.gguf`
- **Hugging Face:** [unsloth/Qwen3-30B-A3B-GGUF](https://huggingface.co/unsloth/Qwen3-30B-A3B-GGUF) · base [Qwen/Qwen3-30B-A3B](https://huggingface.co/Qwen/Qwen3-30B-A3B)

| Key | Value |
|-----|-------|
| `model` | `qwen3.8-27b-Q3S-unsloth/Qwen3.8-27B-UD-IQ3_S.gguf` |
| `spec-type` | `draft-mtp` |
| `spec-draft-n-max` | `2` |
| `reasoning-effort` | `medium` |
| `reasoning-preserve` | `true` |
| `reasoning-budget` | `4096` |
| `ctx-size` | `65536` |
| `parallel` | `1` |
| `n-gpu-layers` | `99` |
| `flash-attn` | `on` |
| `cache-type-k` | `q8_0` |
| `cache-type-v` | `q8_0` |
| `batch-size` | `2048` |
| `ubatch-size` | `512` |
| `temp` | `0.6` |
| `top-p` | `0.95` |
| `top-k` | `20` |
| `min-p` | `0.0` |
| `repeat-penalty` | `1.0` |
| `presence-penalty` | `0.0` |

```ini
[qwen3.8-27b-Q3S-unsloth]
model              = qwen3.8-27b-Q3S-unsloth/Qwen3.8-27B-UD-IQ3_S.gguf
spec-type          = draft-mtp
spec-draft-n-max   = 2
reasoning-effort   = medium
ctx-size           = 65536
parallel           = 1
reasoning-preserve = true
reasoning-budget   = 4096
top-p              = 0.95
top-k              = 20
min-p              = 0.0
presence-penalty   = 0.0
repeat-penalty     = 1.0
```

---

## 4) qwen3-8-Q2 — `[qwen3.8-27-Q2_K_XL-unsloth]` — 9.2 pass

- **Breakout:** `models/qwen3-8-Q2/index.html` (278 lines, most compact of Tier 1)
- **GGUF:** `qwen3.8-27-Q2_K_XL-unsloth/Qwen3.8-27B-UD-Q2_K_XL.gguf`
- **Hugging Face:** [unsloth/Qwen3-30B-A3B-GGUF](https://huggingface.co/unsloth/Qwen3-30B-A3B-GGUF)

| Key | Value |
|-----|-------|
| `model` | `qwen3.8-27-Q2_K_XL-unsloth/Qwen3.8-27B-UD-Q2_K_XL.gguf` |
| `spec-type` | `draft-mtp` |
| `spec-draft-n-max` | `2` |
| `reasoning-effort` | `medium` |
| `reasoning-preserve` | `true` |
| `reasoning-budget` | `4096` |
| `ctx-size` | `65536` |
| `parallel` | `2` |
| `n-gpu-layers` | `99` |
| `flash-attn` | `on` |
| `cache-type-k` | `q8_0` |
| `cache-type-v` | `q8_0` |
| `batch-size` | `2048` |
| `ubatch-size` | `512` |
| `temp` | `0.6` |
| `top-p` | `0.95` |
| `top-k` | `20` |
| `min-p` | `0.0` |
| `repeat-penalty` | `1.0` |
| `presence-penalty` | `0.0` |

```ini
[qwen3.8-27-Q2_K_XL-unsloth]
model              = qwen3.8-27-Q2_K_XL-unsloth/Qwen3.8-27B-UD-Q2_K_XL.gguf
spec-type          = draft-mtp
spec-draft-n-max   = 2
reasoning-effort   = medium
ctx-size           = 65536
parallel           = 2
reasoning-preserve = true
reasoning-budget   = 4096
top-p              = 0.95
top-k              = 20
min-p              = 0.0
presence-penalty   = 0.0
repeat-penalty     = 1.0
```

Distinctive: `parallel 2` (only model with 2 slots).

---

## 5) qwen3-8-Q3XL — `[qwen3.8-27b-Q3XL-unsloth]` — 9.1 pass

- **Breakout:** `models/qwen3-8-Q3XL/index.html` (342 lines)
- **GGUF:** `qwen3.8-27b-Q3XL-unsloth/Qwen3.8-27B-UD-Q3_K_XL.gguf`
- **Hugging Face:** [unsloth/Qwen3-30B-A3B-GGUF](https://huggingface.co/unsloth/Qwen3-30B-A3B-GGUF)

| Key | Value |
|-----|-------|
| `model` | `qwen3.8-27b-Q3XL-unsloth/Qwen3.8-27B-UD-Q3_K_XL.gguf` |
| `spec-type` | `draft-mtp` |
| `spec-draft-n-max` | `2` |
| `reasoning-preserve` | `true` |
| `reasoning-effort` | `medium` |
| `reasoning-budget` | `5000` |
| `ctx-size` | `32768` |
| `batch-size` | `1024` |
| `ubatch-size` | `512` |
| `parallel` | `1` |
| `n-gpu-layers` | `99` |
| `flash-attn` | `on` |
| `cache-type-k` | `q8_0` |
| `cache-type-v` | `q8_0` |
| `temp` | `0.6` |
| `top-p` | `0.95` |
| `top-k` | `20` |
| `min-p` | `0.0` |
| `repeat-penalty` | `1.0` |
| `presence-penalty` | `0.0` |

```ini
[qwen3.8-27b-Q3XL-unsloth]
model              = qwen3.8-27b-Q3XL-unsloth/Qwen3.8-27B-UD-Q3_K_XL.gguf
spec-type          = draft-mtp
spec-draft-n-max   = 2
ctx-size           = 32768
batch-size         = 1024
reasoning-preserve = true
reasoning-effort   = medium
reasoning-budget   = 5000
```

Distinctive: smallest `ctx-size 32768`, `batch-size 1024`, largest `reasoning-budget 5000`.

---

## 6) tiel-coder-35b-IQ3_XXS — `[tiel-coder-35b-IQ3_XXS]` — 7.5 partial

- **Breakout:** `models/tiel-coder-35b-IQ3_XXS/index.html` (465 lines, largest)
- **GGUF:** `tiel-coder-35b-IQ3_XXS/Tiel-Coder-35B-A3B-UD-IQ3_XXS.gguf`
- **mmproj:** `tiel-coder-35b-IQ3_XXS/mmproj-BF16.gguf`
- **Hugging Face:** [peculiar-ragdoll/Tiel-Coder-35B-A3B-GGUF](https://huggingface.co/peculiar-ragdoll/Tiel-Coder-35B-A3B-GGUF)

| Key | Value |
|-----|-------|
| `model` | `tiel-coder-35b-IQ3_XXS/Tiel-Coder-35B-A3B-UD-IQ3_XXS.gguf` |
| `mmproj` | `tiel-coder-35b-IQ3_XXS/mmproj-BF16.gguf` |
| `ctx-size` | `131072` |
| `jinja` | `true` |
| `reasoning-preserve` | `true` |
| `reasoning-budget` | `4096` |
| `n-gpu-layers` | `99` |
| `parallel` | `1` |
| `flash-attn` | `on` |
| `cache-type-k` | `q8_0` |
| `cache-type-v` | `q8_0` |
| `batch-size` | `2048` |
| `ubatch-size` | `512` |
| `temp` | `0.6` |
| `top-p` | `0.95` |
| `top-k` | `20` |
| `min-p` | `0.0` |
| `repeat-penalty` | `1.0` |
| `presence-penalty` | `0.0` |

```ini
[tiel-coder-35b-IQ3_XXS]
model              = tiel-coder-35b-IQ3_XXS/Tiel-Coder-35B-A3B-UD-IQ3_XXS.gguf
mmproj             = tiel-coder-35b-IQ3_XXS/mmproj-BF16.gguf
ctx-size           = 131072
jinja              = true
reasoning-preserve = true
reasoning-budget   = 4096
```

Only 35B MoE in test, has `mmproj` (vision). No speculative decoding.

---

## 7) gemma4-26A4B — `[gemma4-26B-A4B-Q4]` — 7.0 partial

- **Breakout:** `models/gemma4-26A4B/index.html` (337 lines)
- **GGUF:** `gemma4-26B-A4B-Q4/gemma-4-26B-A4B-it-qat-UD-Q4_K_XL.gguf`
- **mmproj:** `gemma4-26B-A4B-Q4/mmproj-F16.gguf`
- **draft:** `gemma4-26B-A4B-Q4/mtp-gemma-4-26B-A4B-it.gguf`
- **Hugging Face:** [unsloth/gemma-4-26B-A4B-it-qat-GGUF](https://huggingface.co/unsloth/gemma-4-26B-A4B-it-qat-GGUF)

| Key | Value |
|-----|-------|
| `model` | `gemma4-26B-A4B-Q4/gemma-4-26B-A4B-it-qat-UD-Q4_K_XL.gguf` |
| `mmproj` | `gemma4-26B-A4B-Q4/mmproj-F16.gguf` |
| `model-draft` | `gemma4-26B-A4B-Q4/mtp-gemma-4-26B-A4B-it.gguf` |
| `spec-type` | `draft-mtp` |
| `spec-draft-n-max` | `4` |
| `n-gpu-layers` | `26` |
| `ctx-size` | `65536` |
| `jinja` | `true` |
| `top-k` | `64` |
| `parallel` | `1` |
| `flash-attn` | `on` |
| `cache-type-k` | `q8_0` |
| `cache-type-v` | `q8_0` |
| `batch-size` | `2048` |
| `ubatch-size` | `512` |
| `temp` | `0.6` |
| `top-p` | `0.95` |
| `min-p` | `0.0` |
| `repeat-penalty` | `1.0` |
| `presence-penalty` | `0.0` |

```ini
[gemma4-26B-A4B-Q4]
model            = gemma4-26B-A4B-Q4/gemma-4-26B-A4B-it-qat-UD-Q4_K_XL.gguf
mmproj           = gemma4-26B-A4B-Q4/mmproj-F16.gguf
model-draft      = gemma4-26B-A4B-Q4/mtp-gemma-4-26B-A4B-it.gguf
spec-type        = draft-mtp
spec-draft-n-max = 4
n-gpu-layers     = 26
ctx-size         = 65536
jinja            = true
top-k            = 64
```

Distinctive: only `n-gpu-layers 26` and `spec-draft-n-max 4` + explicit `model-draft`.

---

## 8) ornith-1-5-9b — `[ornith-1.5-9b]` — 6.5 fail

- **Breakout:** `models/ornith-1-5-9b/index.html` (442 lines)
- **GGUF:** `ornith-1.5-9b/Ornith-1.5-9B-Q8_0.gguf`
- **mmproj:** `ornith-1.5-9b/mmproj-Ornith-1.5-9B-BF16.gguf`
- **Hugging Face:** [ornith-ai/Ornith-1.5-9B](https://huggingface.co/ornith-ai/Ornith-1.5-9B)

| Key | Value |
|-----|-------|
| `model` | `ornith-1.5-9b/Ornith-1.5-9B-Q8_0.gguf` |
| `mmproj` | `ornith-1.5-9b/mmproj-Ornith-1.5-9B-BF16.gguf` |
| `ctx-size` | `131072` |
| `reasoning-preserve` | `true` |
| `reasoning-budget` | `4096` |
| `presence-penalty` | `1.5` |
| `n-gpu-layers` | `99` |
| `parallel` | `1` |
| `flash-attn` | `on` |
| `cache-type-k` | `q8_0` |
| `cache-type-v` | `q8_0` |
| `batch-size` | `2048` |
| `ubatch-size` | `512` |
| `temp` | `0.6` |
| `top-p` | `0.95` |
| `top-k` | `20` |
| `min-p` | `0.0` |
| `repeat-penalty` | `1.0` |

```ini
[ornith-1.5-9b]
model              = ornith-1.5-9b/Ornith-1.5-9B-Q8_0.gguf
mmproj             = ornith-1.5-9b/mmproj-Ornith-1.5-9B-BF16.gguf
ctx-size           = 131072
reasoning-preserve = true
reasoning-budget   = 4096
presence-penalty   = 1.5
```

Would have been #1 — one missing `checkBallFell()` call.

---

## 9) qwen3-5-9b-Q8 — `[qwen3.5-9b-Q8-unsloth]` — 4.0 fail

- **Breakout:** `models/qwen3-5-9b-Q8/index.html` (385 lines)
- **GGUF:** `qwen3.5-9b-Q8-unsloth/Qwen3.5-9B-Q8_0.gguf`
- **Hugging Face:** [unsloth/Qwen3.5-9B-GGUF](https://huggingface.co/unsloth/Qwen3.5-9B-GGUF)

| Key | Value |
|-----|-------|
| `model` | `qwen3.5-9b-Q8-unsloth/Qwen3.5-9B-Q8_0.gguf` |
| `spec-type` | `draft-mtp` |
| `spec-draft-n-max` | `3` |
| `reasoning-preserve` | `true` |
| `reasoning-budget` | `4096` |
| `ctx-size` | `131072` |
| `n-gpu-layers` | `99` |
| `parallel` | `1` |
| `flash-attn` | `on` |
| `cache-type-k` | `q8_0` |
| `cache-type-v` | `q8_0` |
| `batch-size` | `2048` |
| `ubatch-size` | `512` |
| `temp` | `0.6` |
| `top-p` | `0.95` |
| `top-k` | `20` |
| `min-p` | `0.0` |
| `repeat-penalty` | `1.0` |
| `presence-penalty` | `0.0` |

```ini
[qwen3.5-9b-Q8-unsloth]
model              = qwen3.5-9b-Q8-unsloth/Qwen3.5-9B-Q8_0.gguf
ctx-size           = 131072
spec-type          = draft-mtp
spec-draft-n-max   = 3
reasoning-preserve = true
reasoning-budget   = 4096
```

MTP-3.

---

## 10) gemma4-E4B — `[gemma4-E4B-Q8-uncensored]` — 3.5 fail

- **Breakout:** `models/gemma4-E4B/index.html` (426 lines)
- **GGUF:** `gemma4-E4B-Q8-uncensored/Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-Q8_K_P.gguf`
- **mmproj:** `gemma4-E4B-Q8-uncensored/mmproj-Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-f16.gguf`
- **Hugging Face:** [HauhauCS/Gemma-4-E4B-Uncensored](https://huggingface.co/HauhauCS/Gemma-4-E4B-Uncensored-HauhauCS-Aggressive) · base [google/gemma-3-4b-it](https://huggingface.co/google/gemma-3-4b-it)

| Key | Value |
|-----|-------|
| `model` | `gemma4-E4B-Q8-uncensored/Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-Q8_K_P.gguf` |
| `mmproj` | `gemma4-E4B-Q8-uncensored/mmproj-Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-f16.gguf` |
| `ctx-size` | `65536` |
| `jinja` | `true` |
| `top-k` | `64` |
| `n-gpu-layers` | `99` |
| `parallel` | `1` |
| `flash-attn` | `on` |
| `cache-type-k` | `q8_0` |
| `cache-type-v` | `q8_0` |
| `batch-size` | `2048` |
| `ubatch-size` | `512` |
| `temp` | `0.6` |
| `top-p` | `0.95` |
| `min-p` | `0.0` |
| `repeat-penalty` | `1.0` |
| `presence-penalty` | `0.0` |

```ini
[gemma4-E4B-Q8-uncensored]
model       = gemma4-E4B-Q8-uncensored/Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-Q8_K_P.gguf
mmproj      = gemma4-E4B-Q8-uncensored/mmproj-Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-f16.gguf
ctx-size    = 65536
jinja       = true
top-k       = 64
```

Simplest config, no reasoning/spec.

---

## 11) gpt-20-Q8 — `[gpt-20b-unsloth-Q8-UD]` — 2.5 fail

- **Breakout:** `models/gpt-20-Q8/index.html` (244 lines, smallest)
- **GGUF:** `gpt-20b-unsloth-Q8-UD/gpt-oss-20b-UD-Q8_K_XL.gguf`
- **Hugging Face:** [unsloth/gpt-oss-20b-GGUF](https://huggingface.co/unsloth/gpt-oss-20b-GGUF)

| Key | Value |
|-----|-------|
| `model` | `gpt-20b-unsloth-Q8-UD/gpt-oss-20b-UD-Q8_K_XL.gguf` |
| `ctx-size` | `131072` |
| `jinja` | `true` |
| `reasoning-effort` | `medium` |
| `n-gpu-layers` | `99` |
| `parallel` | `1` |
| `flash-attn` | `on` |
| `cache-type-k` | `q8_0` |
| `cache-type-v` | `q8_0` |
| `batch-size` | `2048` |
| `ubatch-size` | `512` |
| `temp` | `0.6` |
| `top-p` | `0.95` |
| `top-k` | `20` |
| `min-p` | `0.0` |
| `repeat-penalty` | `1.0` |
| `presence-penalty` | `0.0` |

```ini
[gpt-20b-unsloth-Q8-UD]
model            = gpt-20b-unsloth-Q8-UD/gpt-oss-20b-UD-Q8_K_XL.gguf
ctx-size         = 131072
jinja            = true
reasoning-effort = medium
```

Minimal overrides.

---

---

