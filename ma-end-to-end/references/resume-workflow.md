# Resume Workflow: 如何在中斷後繼續工作

**Purpose**: 防止「兩天後回來不知道做到哪裡」的問題
**Time**: 2-5 分鐘恢復上下文
**Tools**: `project_status.py`, `session_log.py`

---

## 問題背景

**常見情境**：

- 週一開始做 meta-analysis
- 週二有其他事情中斷
- 週四回來，**完全忘記做到哪裡**
- 不知道上次決定了什麼
- 不知道哪些問題還沒解決

**後果**：

- ❌ 浪費 20-30 分鐘重新熟悉專案
- ❌ 可能重複已完成的工作
- ❌ 忘記重要的決策和假設
- ❌ 遺漏未解決的問題

---

## 解決方案：三層恢復系統

### 🎯 **Layer 1: 專案狀態檢查**（自動化）

**目的**：快速了解「做到哪個階段」

```bash
cd /Users/htlin/meta-pipe/tooling/python

# 基本狀態檢查
uv run project_status.py --project <project-name>

# 詳細狀態檢查（顯示檔案列表）
uv run project_status.py --project <project-name> --verbose

# 儲存為 JSON（供程式使用）
uv run project_status.py --project <project-name> --json status.json
```

**輸出範例**：

```
============================================================
📊 PROJECT STATUS: ici-breast-cancer
============================================================

📁 Location: /Users/htlin/meta-pipe/projects/ici-breast-cancer
⏰ Checked: 2026-02-17T10:13:19Z
✅ Completion: 45%
🎯 Current Stage: 05_extraction
➡️  Next Action: Complete 05_extraction (Data Extraction)

────────────────────────────────────────────────────────────
STAGE PROGRESS:
────────────────────────────────────────────────────────────

✅ 01_protocol - Protocol Development
✅ 02_search - Literature Search
✅ 03_screening - Title/Abstract Screening
✅ 04_fulltext - Full-text Retrieval
🔄 05_extraction - Data Extraction        ← 目前這裡
⬜ 06_analysis - Meta-Analysis
⬜ 07_manuscript - Manuscript Assembly
⬜ 08_reviews - GRADE Assessment
⬜ 09_qa - Quality Assurance
```

---

### 🎯 **Layer 2: 上次工作內容回顧**（Session Log）

**目的**：了解「上次做了什麼、決定了什麼」

```bash
# 查看上次工作內容
uv run session_log.py --project <project-name> resume
```

**輸出範例**：

```
============================================================
📋 LAST SESSION SUMMARY
============================================================

Session ID: 20260215_143022
Date: 2026-02-15
Stage: 05_extraction

✅ TASKS COMPLETED:
   • Converted BibTeX to CSV (15 studies included)
   • Extracted PDF text for 8/15 studies
   • Started LLM extraction using Claude CLI
   • Validated first 3 studies manually

🎯 DECISIONS MADE:
   • Using Hybrid extraction approach (web + PDF)
   • Target 90% completeness threshold
   • Will manually verify LLM output for numeric data
   • Decided to use RoB 2 (all RCTs)

❓ OPEN QUESTIONS:
   • Study #12 (Smith 2020) missing HR data - contact authors?
   • Should we extract secondary endpoints? (not in original PICO)

📁 FILES CREATED:
   • 05_extraction/round-01/pdf_texts.jsonl
   • 05_extraction/round-01/llm_extracted_all.jsonl
   • 05_extraction/round-01/extraction.csv (8/15 complete)

📝 SESSION NOTES:
   LLM extraction working well for basic fields. Numeric data needs manual verification.
   Taking longer than expected - might need 6 hours instead of 4.

============================================================
➡️  SUGGESTED NEXT STEPS:
============================================================

   1. Complete LLM extraction for remaining 7 studies
   2. Validate extraction.csv completeness
   3. Perform Risk of Bias assessment (RoB 2)
   4. Start Stage 06: Meta-Analysis (R scripts)
```

---

### 🎯 **Layer 3: 工作階段追蹤**（自動記錄）

**目的**：記錄當前工作進度，供下次恢復時使用

#### 開始工作時：

```bash
# 啟動新的工作階段
uv run session_log.py --project <project-name> start \
  --notes "Resuming Stage 05 - Data Extraction"
```

#### 工作過程中（自動記錄）：

```bash
# 完成一個任務
uv run session_log.py --project <project-name> update \
  --task "Completed LLM extraction for remaining 7 studies"

# 做了一個決定
uv run session_log.py --project <project-name> update \
  --decision "Decided to exclude Study #12 due to insufficient data"

# 遇到一個問題
uv run session_log.py --project <project-name> update \
  --question "How to handle missing confidence intervals in Study #8?"

# 創建了檔案
uv run session_log.py --project <project-name> update \
  --file-created "05_extraction/round-01/extraction.csv"
```

#### 結束工作時：

```bash
# 結束工作階段（會自動存檔）
uv run session_log.py --project <project-name> end \
  --summary "Completed all data extraction. Ready for Risk of Bias assessment."
```

---

## 完整的恢復流程範例

### 情境：週四回來繼續週一的工作

#### **Step 1: 檢查專案狀態**（30 秒）

```bash
uv run project_status.py --project my-meta-analysis --verbose
```

**快速了解**：
- ✅ 已完成 4 個階段（45%）
- 🔄 目前在 Stage 05（Data Extraction）
- ⬜ 還有 4 個階段待完成

#### **Step 2: 回顧上次工作**（1-2 分鐘）

```bash
uv run session_log.py --project my-meta-analysis resume
```

**詳細了解**：
- ✅ 上次完成了 8/15 研究的數據萃取
- 🎯 決定使用 Hybrid 方法
- ❓ 有 1 個未解決的問題（Study #12 缺數據）
- 📁 已創建 extraction.csv（部分完成）

#### **Step 3: 開始新的工作階段**（10 秒）

```bash
uv run session_log.py --project my-meta-analysis start \
  --notes "Continue extraction - 7 studies remaining"
```

#### **Step 4: 繼續工作**

現在您清楚知道：
1. 做到哪裡了（8/15 完成）
2. 接下來要做什麼（完成剩下 7 個）
3. 有哪些未解決的問題（Study #12）
4. 之前做了什麼決定（Hybrid 方法）

**總恢復時間**：2-3 分鐘（vs 傳統 20-30 分鐘）

---

## 自動化建議

### 在 CLAUDE.md 中集成

當使用者說 **"continue"** 或 **"status"** 時，自動執行：

1. `project_status.py` - 顯示整體進度
2. `session_log.py resume` - 顯示上次工作內容
3. 生成個人化的恢復報告

### 範例腳本：

創建 `tooling/python/smart_resume.py`：

```python
#!/usr/bin/env python3
"""Smart resume: combines status + session log."""

import subprocess
import sys
from pathlib import Path

def smart_resume(project_name: str):
    """Run both status and resume, combine output."""

    # Run project status
    status_result = subprocess.run(
        ["uv", "run", "project_status.py", "--project", project_name],
        capture_output=True,
        text=True,
    )

    # Run session resume
    resume_result = subprocess.run(
        ["uv", "run", "session_log.py", "--project", project_name, "resume"],
        capture_output=True,
        text=True,
    )

    print(status_result.stdout)
    print("\n" + "="*60 + "\n")
    print(resume_result.stdout)

    # Suggest next action
    print("\n" + "="*60)
    print("💡 READY TO CONTINUE?")
    print("="*60)
    print("\n1. Review the summary above")
    print("2. Start a new session:")
    print(f"   uv run session_log.py --project {project_name} start")
    print("\n3. Continue working on suggested next steps")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: smart_resume.py <project-name>")
        sys.exit(1)

    smart_resume(sys.argv[1])
```

---

## 最佳實踐

### ✅ **DO**

1. **每次開始工作時**：
   ```bash
   uv run session_log.py --project <name> start
   ```

2. **完成任務時立即記錄**：
   ```bash
   --task "Completed X"
   ```

3. **做決定時立即記錄**：
   ```bash
   --decision "Decided Y because Z"
   ```

4. **遇到問題時立即記錄**：
   ```bash
   --question "Need to clarify W"
   ```

5. **結束工作時總結**：
   ```bash
   --summary "Finished Stage X, ready for Y"
   ```

### ❌ **DON'T**

1. ❌ 不要跳過 session log
2. ❌ 不要等到最後才記錄（會忘記細節）
3. ❌ 不要只寫模糊的 notes（寫具體的任務和決定）
4. ❌ 不要忘記記錄「為什麼」做某個決定

---

## 時間節省估算

| 恢復時間 | 傳統方法 | 使用 Resume System |
|---------|---------|------------------|
| **1 天後** | 10-15 分鐘 | **2-3 分鐘** |
| **2-3 天後** | 20-30 分鐘 | **3-5 分鐘** |
| **1 週後** | 30-45 分鐘 | **5-8 分鐘** |
| **1 個月後** | 60+ 分鐘 | **10-15 分鐘** |

**ROI**: 每次恢復節省 15-40 分鐘

---

## 實際案例

### Case 1: 中斷 3 天後恢復

**情境**：
- 週一：完成 Literature Search（Stage 02）
- 週二-週四：忙其他事情
- 週五：想繼續

**傳統方法**（25 分鐘）：
1. 打開專案資料夾，不確定做到哪裡（5 分鐘）
2. 重新檢查所有檔案找線索（10 分鐘）
3. 回想上次的決定和問題（10 分鐘）
4. 終於想起來，開始工作

**使用 Resume System**（3 分鐘）：
1. `uv run project_status.py` - 立刻知道完成 Stage 02（30 秒）
2. `uv run session_log.py resume` - 看到完整的上次工作記錄（2 分鐘）
3. 開始工作（立即）

**節省時間**：22 分鐘

---

## 檔案位置

所有 session 資料儲存在：

```
projects/<project-name>/
└── 09_qa/
    └── sessions/
        ├── current_session.json      # 當前工作階段
        └── session_history.jsonl     # 歷史記錄
```

- `current_session.json`: 目前進行中的工作階段
- `session_history.jsonl`: 所有已完成的工作階段（每行一個 JSON）

**格式**：

```json
{
  "session_id": "20260215_143022",
  "start_time": "2026-02-15T14:30:22Z",
  "end_time": "2026-02-15T17:45:10Z",
  "stage": "05_extraction",
  "tasks": [
    {"timestamp": "2026-02-15T15:00:00Z", "task": "Completed PDF extraction"}
  ],
  "decisions": [
    {"timestamp": "2026-02-15T15:30:00Z", "decision": "Use Hybrid approach"}
  ],
  "questions": [
    {"timestamp": "2026-02-15T16:00:00Z", "question": "Missing HR in Study #12?"}
  ],
  "files_created": ["05_extraction/round-01/extraction.csv"],
  "summary": "Finished 8/15 studies. Ready for remaining 7."
}
```

---

## 進階功能

### 1. 查看所有歷史 Session

```bash
# 查看所有 session
cat projects/<project-name>/09_qa/sessions/session_history.jsonl | jq
```

### 2. 統計工作時間

```bash
# 計算總工作時間
cat session_history.jsonl | jq -r '[.start_time, .end_time] | @tsv' | \
  awk '{print ($2 - $1)/3600 " hours"}'
```

### 3. 匯出進度報告

```bash
# 產生完整的專案進度報告
uv run project_status.py --project <name> --json status.json
cat status.json | jq
```

---

## 總結

### 三個核心工具：

1. **`project_status.py`** - WHERE（做到哪裡）
2. **`session_log.py`** - WHAT（做了什麼）
3. **`smart_resume.py`** - HOW（如何繼續）

### 使用時機：

- 🔄 **每次開始工作**：`session_log start`
- ✅ **完成任務時**：`session_log update --task`
- 🎯 **做決定時**：`session_log update --decision`
- ❓ **遇到問題時**：`session_log update --question`
- 🏁 **結束工作時**：`session_log end --summary`
- 📊 **恢復工作時**：`smart_resume` 或 說 "continue"

### 投資回報：

- **初始投資**：每次記錄 5-10 秒
- **恢復時間**：從 20-30 分鐘降至 2-5 分鐘
- **ROI**：每次中斷節省 15-25 分鐘

---

**Created**: 2026-02-17
**Status**: ✅ Ready to use
**Tools**: `project_status.py`, `session_log.py` (已創建並測試)
