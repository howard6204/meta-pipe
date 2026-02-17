# Resume Quick Reference Card

**Purpose**: 中斷後快速恢復工作上下文（2-5 分鐘 vs 傳統 20-30 分鐘）

---

## 🚀 一鍵恢復（最簡單）

```bash
cd /Users/htlin/meta-pipe/tooling/python

# 一次看到所有資訊
uv run smart_resume.py --project <project-name>
```

**顯示**：
- ✅ 完成了哪些階段（百分比）
- 🔄 目前在哪個階段
- 📋 上次做了什麼
- 🎯 上次的決定
- ❓ 未解決的問題
- ➡️ 建議的下一步

---

## 📊 分開查看（詳細控制）

### 查看專案進度

```bash
# 基本進度
uv run project_status.py --project <project-name>

# 詳細進度（含檔案列表）
uv run project_status.py --project <project-name> --verbose
```

### 查看上次工作內容

```bash
# 上次 session 摘要
uv run session_log.py --project <project-name> resume
```

---

## 📝 記錄工作進度（供下次恢復）

### 開始工作時

```bash
uv run session_log.py --project <project-name> start \
  --notes "Starting Stage 05 - Data Extraction"
```

### 工作過程中

```bash
# 完成任務
uv run session_log.py --project <project-name> update \
  --task "Completed LLM extraction for 15 studies"

# 做了決定
uv run session_log.py --project <project-name> update \
  --decision "Using Hybrid extraction approach"

# 遇到問題
uv run session_log.py --project <project-name> update \
  --question "Study #12 missing HR data - contact authors?"

# 創建檔案
uv run session_log.py --project <project-name> update \
  --file-created "05_extraction/round-01/extraction.csv"
```

### 結束工作時

```bash
uv run session_log.py --project <project-name> end \
  --summary "Completed data extraction. Ready for Risk of Bias."
```

---

## 💬 在 Claude Code 中使用

### 方法 1：直接說關鍵字

只要說以下任一關鍵字，我會自動執行恢復流程：

- `"continue"`
- `"status"`
- `"what's next"`
- `"resume"`
- `"where are we"`

### 方法 2：明確要求

```
"Show me the project status and last session summary"
"I'm back after 2 days, where did we leave off?"
"What did we decide last time?"
```

我會自動運行：
1. `smart_resume.py` 或
2. `project_status.py` + `session_log.py resume`

---

## 📋 完整工作流程範例

### 週一：開始新專案

```bash
# 1. 初始化專案
uv run init_project.py --name my-meta-analysis

# 2. 開始工作
uv run session_log.py --project my-meta-analysis start \
  --notes "First session - setting up protocol"

# 3. 做一些工作...

# 4. 記錄進度
uv run session_log.py --project my-meta-analysis update \
  --task "Completed PICO definition" \
  --decision "Using RCTs only, excluding observational studies"

# 5. 結束
uv run session_log.py --project my-meta-analysis end \
  --summary "Protocol complete. Ready for literature search."
```

### 週四：回來繼續

```bash
# 1. 快速恢復
uv run smart_resume.py --project my-meta-analysis

# 2. 看到上次完成了 Protocol，決定只用 RCTs

# 3. 開始新 session
uv run session_log.py --project my-meta-analysis start \
  --notes "Continue with Stage 02 - Literature Search"

# 4. 繼續工作...
```

---

## ⚡ 時間對比

| 情境 | 傳統方法 | Smart Resume | 節省時間 |
|------|---------|--------------|---------|
| 1 天後回來 | 10-15 分鐘 | **2-3 分鐘** | **~12 分鐘** |
| 3 天後回來 | 20-30 分鐘 | **3-5 分鐘** | **~25 分鐘** |
| 1 週後回來 | 30-45 分鐘 | **5-8 分鐘** | **~35 分鐘** |
| 1 月後回來 | 60+ 分鐘 | **10-15 分鐘** | **~45 分鐘** |

---

## 🎯 最佳實踐

### ✅ DO

- ✅ 每次開始工作時 `start` session
- ✅ 完成任務立即 `update --task`
- ✅ 做決定立即 `update --decision`
- ✅ 遇到問題立即 `update --question`
- ✅ 結束工作時 `end` 並寫 summary
- ✅ 中斷後回來先 `smart_resume`

### ❌ DON'T

- ❌ 不要跳過 session logging
- ❌ 不要等到最後才記錄（會忘記）
- ❌ 不要寫模糊的 notes（要具體）
- ❌ 不要忘記記錄「為什麼」

---

## 📁 檔案位置

```
projects/<project-name>/
└── 09_qa/
    └── sessions/
        ├── current_session.json      # 當前工作
        └── session_history.jsonl     # 完整歷史
```

---

## 🆘 疑難排解

### 問題：找不到上次 session

```bash
# 檢查是否有 session 記錄
ls projects/<project-name>/09_qa/sessions/

# 如果沒有，表示這是新專案或之前沒有記錄
# 解決：從現在開始記錄
uv run session_log.py --project <name> start
```

### 問題：project_status 顯示錯誤

```bash
# 檢查專案是否存在
ls projects/<project-name>/

# 檢查是否正確初始化
ls projects/<project-name>/01_protocol/
```

### 問題：想看所有歷史 session

```bash
# 查看所有 session（JSON 格式）
cat projects/<project-name>/09_qa/sessions/session_history.jsonl | jq

# 只看 session ID 和日期
cat session_history.jsonl | jq -r '[.session_id, .start_time] | @tsv'
```

---

## 📚 詳細文件

- 完整指南：`ma-end-to-end/references/resume-workflow.md`
- 工具文件：`tooling/python/README.md`（待創建）

---

**最後更新**: 2026-02-17
**狀態**: ✅ 已測試並可用
**工具版本**: v1.0
