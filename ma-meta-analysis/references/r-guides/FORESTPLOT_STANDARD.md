# forestplot Package - Meta-Pipe Standard for Forest Plots

**Date**: 2026-02-10
**Status**: ✅ **OFFICIAL STANDARD**

---

## 🎯 Summary

**forestplot 套件**現在是 meta-pipe 生成 forest plot 的**官方標準**。

### ✅ 為什麼選擇 forestplot？

1. **醫學期刊標準** - NEJM, Lancet, BMJ 都用這種風格
2. **Zebra stripes** - 交替背景大幅提升可讀性
3. **Diamond CI endpoints** - 專業的菱形端點標記
4. **Table layout** - 清晰的表格式排版
5. **高度可客製化** - 完全控制視覺外觀

### ❌ 不再推薦

- ❌ `metafor::forest()` - 太基本，不是期刊標準
- ❌ `meta::forest()` - 同上
- ❌ 純 ggplot2 - 不是醫學期刊風格

---

## 📋 標準配置

### 必需套件

```r
install.packages("forestplot")  # ⭐ 必裝
install.packages("metafor")     # 統計計算
install.packages("dplyr")       # 資料處理
install.packages("grid")        # 圖形支援
```

### 標準顏色方案

**預設（黑線）**：

```r
col = fpColors(
  box = "black",      # 黑色方塊
  lines = "black",    # 黑色 CI 線
  zero = "gray50",    # 灰色參考線
  summary = "black"   # 黑色合併效應
)
```

**重要**: 除非特別要求，否則**不要用藍色或其他顏色**。黑線是專業標準。

### 必備特徵

1. **Zebra stripes** - 交替灰白背景

   ```r
   hrzl_lines = list(
     "4" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),
     "6" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),
     # ...
   )
   ```

2. **Diamond endpoints** - 菱形端點

   ```r
   ci.vertices = TRUE
   ci.vertices.height = 0.2
   ```

3. **300 DPI** - 出版品質

   ```r
   png("forest_plot.png", width=4200, height=3000, res=300)
   ```

4. **Stats footer** - 統計資訊
   ```r
   grid.text(
     sprintf("Random-effects model | I² = %.1f%% | τ² = %.3f | p = %.3f",
             res$I2, res$tau2, res$pval),
     x = 0.5, y = 0.03
   )
   ```

---

## 🔧 標準模板

**所有 meta-analysis 都應該用這個模板**：

```r
library(forestplot)
library(metafor)
library(dplyr)
library(grid)

# 1. Load and prepare data
data <- read.csv("05_extraction/extraction.csv")
data <- data %>%
  mutate(
    # Calculate effect sizes
    effect = ...,
    se = ...,
    ci_lower = effect - 1.96 * se,
    ci_upper = effect + 1.96 * se
  ) %>%
  arrange(desc(n_total))

# 2. Meta-analysis
res <- rma(yi = effect, vi = se^2, data = data, method = "DL")

# 3. Prepare table
tabletext <- list(
  c("Study", paste0(data$author, " ", data$year), "Overall (RE)"),
  c("N", as.character(data$n_total), as.character(sum(data$n_total))),
  c("Effect [95% CI]",
    sprintf("%.2f [%.2f, %.2f]", data$effect, data$ci_lower, data$ci_upper),
    sprintf("%.2f [%.2f, %.2f]", res$beta[1], res$ci.lb, res$ci.ub))
)

mean_values <- c(NA, data$effect, res$beta[1])
lower_values <- c(NA, data$ci_lower, res$ci.lb)
upper_values <- c(NA, data$ci_upper, res$ci.ub)

# 4. Create forest plot (300 DPI)
png("figures/forest_plot.png", width=4200, height=3000, res=300)

forestplot(
  labeltext = tabletext,
  graph.pos = 3,
  mean = mean_values,
  lower = lower_values,
  upper = upper_values,

  title = "Effect of Intervention on Outcome",
  xlab = "     <--- Favors Control ---     --- Favors Intervention --->",

  # Zebra stripes
  hrzl_lines = list(
    "2" = gpar(lwd=1, col="#999999"),
    "4" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),
    "6" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),
    # Add more as needed...
    sprintf("%d", nrow(data)+2) = gpar(lwd=60, lineend="butt", columns=c(1:3), col="#DDDDDD")
  ),

  txt_gp = fpTxtGp(
    label = gpar(cex=1.1),
    ticks = gpar(cex=1.0),
    xlab = gpar(cex=1.2),
    title = gpar(cex=1.4, fontface="bold")
  ),

  # BLACK LINES (standard)
  col = fpColors(box="black", lines="black", zero="gray50", summary="black"),

  zero = 0,
  cex = 1.0,
  lineheight = "auto",
  boxsize = 0.35,
  colgap = unit(5, "mm"),
  lwd.ci = 2.5,
  ci.vertices = TRUE,
  ci.vertices.height = 0.2,

  is.summary = c(FALSE, rep(FALSE, nrow(data)), TRUE),

  grid = structure(c(-0.5, 0, 0.5, 1.0, 1.5), gp = gpar(lty=2, col="#CCCCCC"))
)

# Stats footer
grid.text(
  sprintf("Random-effects model | I² = %.1f%% | τ² = %.3f | p = %.3f | N = %d studies",
          res$I2, res$tau2, res$pval, nrow(data)),
  x = 0.5, y = 0.03,
  gp = gpar(cex=0.95, col="#555555")
)

dev.off()
```

---

## 📊 品質標準

### 必須符合

- ✅ **300 DPI** resolution
- ✅ **Black lines** (no colors unless requested)
- ✅ **Zebra stripes** for readability
- ✅ **Diamond endpoints** on CI
- ✅ **Stats footer** with I², τ², p-value
- ✅ **Table layout** with all key info
- ✅ **Professional typography**

### 不允許

- ❌ 低於 300 DPI
- ❌ 沒有 zebra stripes
- ❌ 使用 metafor::forest()
- ❌ 預設藍色線條（除非特別要求）
- ❌ 缺少統計資訊

---

## 🎓 更新文件

### 已更新

1. ✅ `ma-meta-analysis/references/r-guides/01-forest-plots.md` - 完全改寫，以 forestplot 為標準
2. ✅ `ma-meta-analysis/references/r-figure-guide.md` - 更新套件列表
3. ✅ `ma-meta-analysis/references/r-guides/FORESTPLOT_STANDARD.md` - 本文件（新增）

### 關鍵變更

**之前（舊）**:

```r
library(meta)
forest(res)  # 基本，不夠專業
```

**現在（新標準）**:

```r
library(forestplot)
forestplot(...)  # 醫學期刊標準
```

---

## 🔍 檢查清單

生成 forest plot 之前，確認：

- [ ] 安裝了 `forestplot` 套件
- [ ] 使用 `forestplot()` 函數（不是 `forest()`）
- [ ] 設定 300 DPI
- [ ] 使用黑線（`col = fpColors(box="black", lines="black", ...)`）
- [ ] 加入 zebra stripes
- [ ] 啟用 diamond endpoints (`ci.vertices = TRUE`)
- [ ] 加入 stats footer
- [ ] 測試圖片在 300 DPI 下的可讀性

---

## 📚 相關文件

- [01-forest-plots.md](01-forest-plots.md) - 完整 forestplot 使用指南
- [R_FIGURE_GUIDE.md](../R_FIGURE_GUIDE.md) - R 圖表生成總指南
- [09-package-selection.md](09-package-selection.md) - 套件選擇建議

---

## 🎯 常見問題

### Q: 可以用彩色嗎？

**A**: 不推薦。黑線是醫學期刊標準。除非：

- 編輯特別要求
- 期刊風格指南明確指定
- 需要區分多個亞組（但也可用灰階）

### Q: metafor::forest() 不能用嗎？

**A**: 不推薦用於最終投稿。可以用於：

- 快速預覽
- 內部分析
- 不需要出版品質的場合

但**最終投稿必須用 forestplot 套件**。

### Q: 如何自動生成 zebra stripes？

**A**: 參考 `01-forest-plots.md` 的 Troubleshooting 章節：

```r
n_studies <- nrow(data)
zebra_rows <- seq(4, n_studies*2, by=2)
hrzl_lines <- lapply(zebra_rows, function(i) {
  gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5")
})
names(hrzl_lines) <- as.character(zebra_rows)
```

### Q: 300 DPI 會不會檔案太大？

**A**: 不會。通常：

- PNG: 500-800 KB（可接受）
- TIFF: 1-2 MB（期刊標準）

如果超過 2 MB，考慮：

1. 減少研究數量（分成多個圖）
2. 使用 TIFF 壓縮 (`compression="lzw"`)
3. 調整尺寸（但不低於 300 DPI）

---

## 🚀 實作建議

### 第一次使用

1. 閱讀 `01-forest-plots.md` 的 Quick Start（10 分鐘）
2. 複製標準模板
3. 調整你的資料變數名稱
4. 生成圖片
5. 檢查品質（300 DPI, zebra stripes, 黑線）

### 已經用 metafor::forest()？

1. 保留 metafor 的統計計算部分
2. 只改圖片生成部分
3. 用 forestplot() 取代 forest()
4. 加入 zebra stripes 和其他專業特徵

---

## ✅ 總結

**meta-pipe 的 forest plot 標準**：

1. **forestplot 套件** - 唯一推薦
2. **黑線配色** - 專業標準
3. **Zebra stripes** - 必備
4. **300 DPI** - 最低要求
5. **Complete table** - 所有資訊可見

**遵循這些標準，你的 forest plot 將符合所有頂級醫學期刊的要求。**

---

**更新日期**: 2026-02-10
**適用範圍**: 所有 meta-pipe 專案
**維護者**: meta-pipe core team
