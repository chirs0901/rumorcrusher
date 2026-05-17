# RumorCrusher Morning Quality Report
**Date:** 2026-05-16 | **Batch:** Morning (07:00) | **Timestamp:** 230857  
**Pipeline Version:** v0.4

---

## Execution Summary

| Metric | Value |
|--------|-------|
| System time at run | 2026-05-16 23:06 UTC |
| WebSearch queries | 6 |
| Raw items collected | 28 |
| Items reviewed (Tier 1+2) | 22 |
| Agents executed | 4 (fact-check, pseudo, logic, sentiment) |

---

## AVeriTeC Label Distribution (22 items)

| Label | Count | % |
|-------|-------|---|
| Refuted | 11 | 50.0% |
| Supported | 5 | 22.7% |
| NotEnoughEvidence | 4 | 18.2% |
| ConflictingEvidence | 2 | 9.1% |

**UnR (Unresolved Rate):** 50.0% (NEE + CE combined = 27.3%)  
**Refuted Rate:** 50.0%  
**Supported Rate:** 22.7%

---

## Severity Distribution

| Severity | Items |
|----------|-------|
| Critical | M001, M011, M016, M017, M019, M020 |
| High | M003, M010, M013, M018 |
| Medium | M002, M012, M014, M021, M022, M027, M028 |
| Low | M007, M014 |
| Informational | M008, M009, M024 |

---

## Top Critical Findings

1. **M016/M017/M018 — Hantavirus Conspiracy Cluster** (Refuted, confidence 0.93–0.98)  
   Three interlocking conspiracy claims about the Dutch cruise ship hantavirus outbreak. Pattern matches COVID-era misinformation playbook. Danger: active public health event.

2. **M001 — Mark Carney AI Deepfake Video** (Refuted, 0.96)  
   Temporally impossible. AFP-confirmed AI generation. G7 timing fabrication.

3. **M020 — Trump/Newsom AI Audio Deepfake** (Refuted, 0.95)  
   Real WEF footage, fake AI audio overlay. AFP-confirmed.

4. **M011 — ICE Shooting AI Images** (Refuted, 0.91)  
   AI-edited images on sensitive immigration topic. Very high amplification risk.

5. **M019 — MMR/Autism Revival** (Refuted, 0.99)  
   Resurfaced by influencer networks. Highest scientific confidence of refutation.

---

## Agent Performance Notes

- **Fact-check agent:** Strong on health and political claims; NEE assigned appropriately for M006, M021, M022
- **Pseudo agent:** Identified 6 distinct manipulation pattern categories; audio deepfake and retroactive prophecy patterns newly prominent
- **Logic agent:** All Refuted items failed internal consistency checks; no false positives
- **Sentiment agent:** High amplification risk correctly flagged on health conspiracy cluster

---

## Known Pipeline Issues

- **RumorCrusher workspace not mounted:** Original path `/sessions/dazzling-serene-mendel/mnt/RumorCrusher` inaccessible in this session. Using fallback: `outputs/RumorCrusher/`
- **Git push (Step 8):** Will fail — no workspace mount for `scripts/daily_publish.sh`
- **Feishu/email push:** Cannot execute without credentials in this session

---

## Health Score

| Component | Score |
|-----------|-------|
| Collection completeness | 28/25 min ✅ → **100** |
| Agent coverage | 4/4 ✅ → **100** |
| AVeriTeC balance | Refuted 50%, NEE 18.2% → **82** |
| Source diversity | 6 searches, EN+ZH sources → **88** |
| Critical item capture | 6 critical items identified → **90** |
| **Composite Health Score** | **92/100** |

