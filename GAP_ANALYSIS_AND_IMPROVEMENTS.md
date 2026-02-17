# Gap Analysis and Module Enhancement Plan

**Date**: 2026-02-17
**Context**: 基於 ici-nsclc 專案的完整執行，識別出 `ma-*` 模組文檔中的缺漏項目

---

## 🔍 **執行中發現的主要缺漏 (Priority Gaps)**

### **1. PRISMA-NMA Checklist 未整合到 ma-publication-quality**

**問題**:
- `ma-publication-quality/references/` 僅有 PRISMA 2020 和 MOOSE
- NMA 專案需要 PRISMA-NMA (32 items) 但模組中未提供
- 導致 AI 需要手動查找並創建

**影響**: ⭐⭐⭐⭐⭐ CRITICAL

**解決方案**:
- [ ] 創建 `ma-publication-quality/references/prisma-nma-checklist-template.md`
- [ ] 創建腳本 `ma-publication-quality/scripts/init_prisma_nma_checklist.py`
- [ ] 在 `CLAUDE.md` Stage 09 QA 部分加入 NMA checklist 說明
- [ ] 在 `ma-publication-quality/references/journal-formatting.md` 加入 NMA 特殊要求

---

### **2. GRADE Summary of Findings (SoF) Table 缺乏完整指引**

**問題**:
- `ma-peer-review/scripts/init_grade_summary.py` 僅初始化骨架
- 沒有詳細的 GRADE 評估指引（5 降級因素、3 升級因素）
- NMA 專案需要針對每個間接比較進行 GRADE 評估
- 缺乏 NMA 特殊 GRADE 考量（例如 transitivity, incoherence）

**影響**: ⭐⭐⭐⭐⭐ CRITICAL

**解決方案**:
- [ ] 創建 `ma-peer-review/references/grade-assessment-guide.md`（詳細 GRADE 方法）
- [ ] 創建 `ma-peer-review/references/grade-nma-guide.md`（NMA 特殊考量）
- [ ] 增強 `init_grade_summary.py` 加入自動建議（基於 I², risk of bias）
- [ ] 創建 GRADE SoF table 範例模板

---

### **3. Supplementary Materials 缺乏標準化結構**

**問題**:
- 沒有標準的補充材料結構模板
- AI 需要手動推斷應該包含哪些補充表格/圖片
- 缺乏補充材料檢查表（不同期刊要求不同）

**影響**: ⭐⭐⭐⭐ HIGH

**解決方案**:
- [ ] 創建 `ma-manuscript-quarto/references/supplementary-materials-template.md`
- [ ] 創建腳本 `ma-manuscript-quarto/scripts/init_supplementary_materials.py`
- [ ] 分期刊類型提供補充材料檢查表（Lancet vs JAMA vs BMJ）
- [ ] 加入補充材料交叉引用驗證

---

### **4. Author Contributions (CRediT) 和聲明缺乏模板**

**問題**:
- 沒有標準的 author contribution 模板
- 缺乏 funding statement, COI declaration 模板
- ICMJE disclosure forms 沒有整合到 workflow

**影響**: ⭐⭐⭐⭐ HIGH

**解決方案**:
- [ ] 創建 `ma-manuscript-quarto/references/author-statements-template.md`
- [ ] 創建 `ma-manuscript-quarto/assets/quarto/author_statements.qmd`
- [ ] 加入 CRediT taxonomy 自動填充腳本
- [ ] 在 submission checklist 加入 ICMJE forms 檢查

---

### **5. Claim Audit 缺乏系統化方法**

**問題**:
- `ma-publication-quality/scripts/claim_audit.py` 過於簡化
- 沒有系統化的 claim-to-evidence 映射檢查
- 缺乏 overclaim detection（結論超出證據支持範圍）

**影響**: ⭐⭐⭐⭐ HIGH

**解決方案**:
- [ ] 創建 `ma-publication-quality/references/claim-audit-guide.md`
- [ ] 增強 `claim_audit.py` 加入：
  - Abstract vs Results 一致性檢查
  - Confidence level 映射（p<0.05 → "significant", 95% CI 不跨 1 → "strong evidence"）
  - Limitation acknowledgment 檢查
- [ ] 創建 claim audit 範例（good vs bad claims）

---

### **6. NMA 特殊項目缺乏檢查表**

**問題**:
- NMA 專案有額外要求（league table, SUCRA, inconsistency check, CINeMA）
- 這些項目沒有整合到標準 QA workflow
- `ma-network-meta-analysis/` 模組缺乏完整性檢查腳本

**影響**: ⭐⭐⭐⭐ HIGH

**解決方案**:
- [ ] 創建 `ma-network-meta-analysis/references/nma-completion-checklist.md`
- [ ] 創建 `ma-network-meta-analysis/scripts/validate_nma_outputs.py`（檢查所有 NMA 必要輸出）
- [ ] 在 `final_qa_report.py` 加入 NMA-specific checks

---

### **7. QA Report 缺乏 NMA 特定檢查**

**問題**:
- `ma-end-to-end/scripts/final_qa_report.py` 未針對 NMA 專案調整
- 缺乏檢查：
  - Network connectivity (是否所有治療有間接證據連結)
  - Consistency check (是否有 inconsistency loop)
  - PRISMA-NMA 32 items vs PRISMA 2020 27 items
  - CINeMA GRADE assessment

**影響**: ⭐⭐⭐⭐ HIGH

**解決方案**:
- [ ] 在 `final_qa_report.py` 加入 `--analysis-type nma` 參數
- [ ] 基於 `pico.yaml` 中的 `analysis_type` 自動切換檢查項目
- [ ] 創建 NMA-specific validation functions

---

### **8. 缺乏 "Publication Readiness Score" 系統**

**問題**:
- 目前沒有單一數字評估專案完成度
- AI 和使用者難以快速判斷「距離投稿還有多遠」

**影響**: ⭐⭐⭐ MODERATE

**解決方案**:
- [ ] 創建 `ma-end-to-end/scripts/publication_readiness_score.py`
- [ ] 計算加權分數（0-100%）：
  - PRISMA checklist: 20%
  - GRADE assessment: 15%
  - Supplementary materials: 15%
  - Author statements: 10%
  - Claim audit: 15%
  - Cross-reference validation: 10%
  - Figure quality (DPI, labels): 10%
  - Reference completeness: 5%
- [ ] 輸出 "Ready to submit" (≥95%), "Almost ready" (85-94%), "Major work needed" (<85%)

---

### **9. PROSPERO Registration 缺乏自動化**

**問題**:
- 手動填寫 PROSPERO 費時（2-3 小時）
- 已有 `pico.yaml` + `02_methods.qmd` 的所有資訊
- 缺乏自動生成 PROSPERO protocol 的腳本

**影響**: ⭐⭐⭐ MODERATE

**解決方案**:
- [ ] 創建 `ma-topic-intake/scripts/generate_prospero_protocol.py`（已在 CLAUDE.md 提及但未實作）
- [ ] 輸出 Word/PDF format 可直接複製貼上到 PROSPERO 表單
- [ ] 包含所有 42 個 PROSPERO required fields

---

### **10. Journal-Specific Formatting 缺乏自動化**

**問題**:
- `journal-formatting.md` 僅列舉規則，沒有自動檢查
- 缺乏 Quarto template 針對不同期刊（Lancet vs JAMA vs BMJ）
- 字數限制、參考文獻格式、圖片要求沒有自動驗證

**影響**: ⭐⭐⭐ MODERATE

**解決方案**:
- [ ] 創建 `ma-manuscript-quarto/assets/quarto/template-lancet.qmd`
- [ ] 創建 `ma-manuscript-quarto/assets/quarto/template-jama.qmd`
- [ ] 創建 `ma-manuscript-quarto/scripts/validate_journal_format.py`
  - 檢查字數（Abstract ≤300, Main text ≤4000 for Lancet）
  - 檢查參考文獻格式（Vancouver vs AMA）
  - 檢查圖表數量限制
- [ ] 在 `render_manuscript.py` 加入 `--journal` 參數

---

## 📋 **Module Enhancement Priority Matrix**

| Module | Missing Items | Priority | Estimated Effort | Impact |
|--------|---------------|----------|------------------|--------|
| **ma-publication-quality** | PRISMA-NMA, GRADE guide, Claim audit | ⭐⭐⭐⭐⭐ CRITICAL | 6-8 hours | 直接影響高分期刊接受率 |
| **ma-manuscript-quarto** | Supplementary materials, Author statements | ⭐⭐⭐⭐ HIGH | 4-6 hours | 必要但可手動補充 |
| **ma-network-meta-analysis** | NMA completion checklist, validation script | ⭐⭐⭐⭐ HIGH | 3-4 hours | NMA 專案必要 |
| **ma-end-to-end** | NMA-aware QA, Publication readiness score | ⭐⭐⭐ MODERATE | 3-4 hours | 改善 UX |
| **ma-topic-intake** | PROSPERO auto-generation | ⭐⭐⭐ MODERATE | 2-3 hours | 節省時間但非阻塞 |

---

## 🔧 **Immediate Action Plan (Next 2 Hours)**

### **Phase 1: Critical Gaps (Priority ⭐⭐⭐⭐⭐)**

1. **Create PRISMA-NMA Checklist Template** (30 min)
   - File: `ma-publication-quality/references/prisma-nma-checklist-template.md`
   - Include all 32 items with examples from ici-nsclc project

2. **Create GRADE Assessment Guide** (45 min)
   - File: `ma-peer-review/references/grade-assessment-guide.md`
   - Include 5 downgrade factors, 3 upgrade factors
   - NMA-specific considerations (transitivity, incoherence)

3. **Create Supplementary Materials Template** (30 min)
   - File: `ma-manuscript-quarto/references/supplementary-materials-template.md`
   - Standard structure for Lancet/JAMA/BMJ

4. **Update CLAUDE.md with Missing Workflows** (15 min)
   - Add PRISMA-NMA checklist command
   - Add GRADE SoF table detailed workflow
   - Add Supplementary materials generation

---

## 📚 **Documentation Improvements Needed**

### **CLAUDE.md Updates**

```markdown
## When to Use PRISMA-NMA vs PRISMA 2020

**Decision rule**: Based on `analysis_type` in `01_protocol/pico.yaml`

- `analysis_type: pairwise` → Use PRISMA 2020 (27 items)
- `analysis_type: nma` → Use PRISMA-NMA (32 items, includes network geometry, inconsistency)

## Stage 09: QA Commands (Enhanced)

### For Pairwise Meta-Analysis
```bash
uv run init_reporting_checklists.py --root projects/<project> --type prisma2020
```

### For Network Meta-Analysis
```bash
uv run init_reporting_checklists.py --root projects/<project> --type prisma-nma
uv run validate_nma_outputs.py --root projects/<project>  # Check league table, SUCRA, etc.
```

### GRADE SoF Table (Detailed)
```bash
# Step 1: Initialize GRADE template
uv run init_grade_summary.py --extraction projects/<project>/05_extraction/extraction.csv

# Step 2: Auto-populate downgrade suggestions (based on I², RoB)
uv run auto_grade_suggestion.py --grade projects/<project>/08_reviews/grade_summary.csv

# Step 3: Manual review and finalize
# Edit grade_summary.csv in Excel/Numbers

# Step 4: Generate formatted SoF table for manuscript
uv run render_sof_table.py --grade projects/<project>/08_reviews/grade_summary.csv \
  --out projects/<project>/07_manuscript/tables/sof_table.png --dpi 300
```
```

---

## ✅ **Success Criteria for Improvements**

When these enhancements are complete, AI should be able to:

1. ✅ **Automatically detect NMA vs pairwise** from `pico.yaml`
2. ✅ **Generate complete PRISMA-NMA checklist** without manual template lookup
3. ✅ **Provide GRADE assessment guidance** with specific downgrade/upgrade criteria
4. ✅ **Auto-generate supplementary materials skeleton** based on analysis outputs
5. ✅ **Validate publication readiness** with single score (0-100%)
6. ✅ **Detect missing NMA-specific items** (league table, SUCRA, CINeMA)

---

## 📊 **Expected Impact**

**Before improvements**:
- AI completion rate: 85-90%
- Manual work needed: 8-12 hours
- Publication-ready: 2-3 days after "completion"

**After improvements**:
- AI completion rate: 95-98%
- Manual work needed: 3-4 hours (only author names, PROSPERO, ICMJE forms)
- Publication-ready: Same day as "completion"

**Time saved per project**: 4-8 hours

---

## 🚀 **Next Steps**

Would you like me to:

1. **Start Phase 1 immediately** (create critical templates and guides)
2. **Create all missing reference documents** in one batch (2-3 hours)
3. **Enhance existing scripts** with NMA awareness
4. **Update CLAUDE.md** with complete workflows

Or should I prioritize differently based on your immediate needs?
