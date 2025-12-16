# 原生 CSS 完整教學指南

> 基於 Fizzy 與 Once Campfire 專案的 CSS 架構分析

本指南涵蓋現代原生 CSS 的所有核心技術，讓你能夠建立新網站或維護現有專案的樣式。

---

## 目錄

1. [CSS 架構與檔案組織](#1-css-架構與檔案組織)
2. [CSS Reset 與基礎設定](#2-css-reset-與基礎設定)
3. [CSS 自訂屬性（變數）系統](#3-css-自訂屬性變數系統)
4. [色彩系統與主題切換](#4-色彩系統與主題切換)
5. [排版系統與間距](#5-排版系統與間距)
6. [版面配置（Layout）](#6-版面配置layout)
7. [響應式設計](#7-響應式設計)
8. [組件樣式設計](#8-組件樣式設計)
9. [按鈕系統](#9-按鈕系統)
10. [表單輸入元素](#10-表單輸入元素)
11. [卡片組件](#11-卡片組件)
12. [導航與選單](#12-導航與選單)
13. [對話框與彈出視窗](#13-對話框與彈出視窗)
14. [動畫與過渡效果](#14-動畫與過渡效果)
15. [圖示系統](#15-圖示系統)
16. [工具類（Utilities）](#16-工具類utilities)
17. [列印樣式](#17-列印樣式)
18. [PWA 支援](#18-pwa-支援)
19. [無障礙設計](#19-無障礙設計)
20. [CSS 最佳實踐](#20-css-最佳實踐)

---

## 1. CSS 架構與檔案組織

### 1.1 檔案結構原則

將 CSS 按功能分割成獨立檔案，每個檔案負責特定的功能：

```
stylesheets/
├── _reset.css          # CSS Reset，移除瀏覽器預設樣式
├── _global.css         # 全域變數定義
├── base.css            # 基礎元素樣式
├── colors.css          # 色彩系統
├── layout.css          # 版面配置
├── utilities.css       # 工具類
├── animation.css       # 動畫定義
│
├── # 組件樣式
├── buttons.css         # 按鈕
├── inputs.css          # 表單輸入
├── cards.css           # 卡片
├── avatars.css         # 頭像
├── nav.css             # 導航
├── panels.css          # 面板
├── dialog.css          # 對話框
├── popup.css           # 彈出視窗
├── flash.css           # 閃現訊息
├── tooltips.css        # 提示框
├── spinners.css        # 載入動畫
│
├── # 特定功能
├── icons.css           # 圖示系統
├── comments.css        # 留言區
├── reactions.css       # 反應表情
├── filters.css         # 篩選器
├── search.css          # 搜尋
├── lightbox.css        # 燈箱
├── print.css           # 列印樣式
└── pwa.css             # PWA 相關
```

### 1.2 CSS Layers（層級）

使用 `@layer` 控制樣式優先順序：

```css
/* 定義層級順序 */
@layer reset, base, components, utilities;

/* reset 層：最低優先順序 */
@layer reset {
  *, *::before, *::after {
    box-sizing: border-box;
  }
}

/* components 層：組件樣式 */
@layer components {
  .btn {
    /* 按鈕樣式 */
  }

  .card {
    /* 卡片樣式 */
  }
}
```

**層級優點：**
- 明確控制樣式覆蓋順序
- 避免選擇器權重競爭
- 更容易維護和調試

---

## 2. CSS Reset 與基礎設定

### 2.1 現代 CSS Reset

```css
/* Box sizing 規則 */
*,
*::before,
*::after {
  box-sizing: border-box;
}

/* 移除預設 margin */
body,
h1, h2, h3, h4, h5, h6 {
  margin: 0;
}

/* 防止長文字溢出 */
p, li, h1, h2, h3, h4 {
  word-break: break-word;
}

/* 防止水平滾動 */
html, body {
  overflow-x: hidden;
}

/* 平滑滾動 */
html {
  scroll-behavior: smooth;
}

/* 基礎 body 設定 */
body {
  min-height: 100dvh;           /* 動態視窗高度 */
  font-family: sans-serif;
  font-size: 100%;
  line-height: 1.5;
  text-rendering: optimizeSpeed;
}

/* 圖片更容易處理 */
img {
  display: block;
  max-inline-size: 100%;        /* 邏輯屬性 */
}

/* 表單元素繼承字體 */
input, button, textarea, select {
  font: inherit;
}

/* 減少動畫（無障礙） */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

### 2.2 基礎元素樣式

```css
:root {
  --font-family: -apple-system, BlinkMacSystemFont, "Segoe UI",
                 Roboto, Helvetica, Arial, sans-serif;
  --font-mono: ui-monospace, SFMono-Regular, "SF Mono",
               Menlo, Consolas, monospace;
  --hover-size: 0.15em;
  --hover-filter: brightness(1);
}

html, body {
  -webkit-text-size-adjust: none;
  text-size-adjust: none;
  background-color: var(--color-bg);
  color: var(--color-text);
  font-family: var(--font-family);
  line-height: 1.4;
}

/* 連結樣式 */
:where(a:not([class]):not(:has(img))) {
  color: var(--color-link);

  @media (any-hover: hover) {
    &:where(:not(:active):hover) {
      filter: brightness(1.3);
    }
  }
}
```

---

## 3. CSS 自訂屬性（變數）系統

### 3.1 全域變數定義

```css
:root {
  /* 間距系統 */
  --inline-space: 1ch;                              /* 水平間距（字元寬度） */
  --inline-space-half: calc(var(--inline-space) / 2);
  --inline-space-double: calc(var(--inline-space) * 2);

  --block-space: 1rem;                              /* 垂直間距 */
  --block-space-half: calc(var(--block-space) / 2);
  --block-space-double: calc(var(--block-space) * 2);

  /* 字體大小 */
  --text-xx-small: 0.7rem;
  --text-x-small: 0.8rem;
  --text-small: 0.9rem;
  --text-medium: 1rem;
  --text-large: 1.2rem;
  --text-x-large: 1.5rem;
  --text-xx-large: 2rem;

  /* Z-index 層級 */
  --z-base: 1;
  --z-popup: 10;
  --z-nav: 50;
  --z-tray: 100;
  --z-flash: 200;
  --z-tooltip: 300;

  /* 過渡時間 */
  --dialog-duration: 200ms;

  /* 焦點環 */
  --focus-ring-size: 2px;
  --focus-ring-color: var(--color-link);
  --focus-ring-offset: 2px;

  /* Easing 函數 */
  --ease-out-overshoot: cubic-bezier(0.25, 1.25, 0.5, 1);
  --ease-out-overshoot-subtle: cubic-bezier(0.25, 1.1, 0.5, 1);
}
```

### 3.2 組件級變數

在組件內部使用區域變數，方便覆蓋：

```css
.btn {
  /* 定義可覆蓋的變數（帶預設值） */
  --btn-background: var(--color-canvas);
  --btn-border-color: var(--color-ink-light);
  --btn-border-radius: 2em;
  --btn-border-size: 1px;
  --btn-color: var(--color-ink);
  --btn-padding: 0.5em 1.1em;
  --btn-size: 2.65em;

  /* 使用變數 */
  background-color: var(--btn-background);
  border: var(--btn-border-size) solid var(--btn-border-color);
  border-radius: var(--btn-border-radius);
  color: var(--btn-color);
  padding: var(--btn-padding);
}

/* 變體只需覆蓋變數 */
.btn--primary {
  --btn-background: var(--color-ink);
  --btn-color: var(--color-ink-inverted);
  --btn-border-color: transparent;
}

.btn--negative {
  --btn-background: var(--color-negative);
  --btn-color: var(--color-ink-inverted);
}
```

### 3.3 使用 `color-mix()` 建立動態顏色

```css
.card {
  /* 混合顏色：卡片色 4% + 畫布色 96% */
  --card-bg-color: color-mix(in srgb, var(--card-color) 4%, var(--color-canvas));

  /* 混合顏色：卡片色 30% + 墨水色 70% */
  --card-content-color: color-mix(in srgb, var(--card-color) 30%, var(--color-ink));

  /* 混合顏色：加入透明度 */
  --card-border: 1px solid color-mix(in srgb, var(--card-color) 33%, var(--color-ink-inverted));

  background-color: var(--card-bg-color);
}
```

---

## 4. 色彩系統與主題切換

### 4.1 使用 OKLCH 色彩空間

OKLCH 提供更好的感知均勻性和色彩操作能力：

```css
:root {
  /* 定義基礎 LCH 值（亮度 色度 色相） */
  --lch-black: 0% 0 0;
  --lch-white: 100% 0 0;
  --lch-gray: 96% 0.005 96;
  --lch-gray-dark: 92% 0.005 96;
  --lch-gray-darker: 75% 0.005 96;

  /* 彩色 */
  --lch-blue: 54% 0.23 255;
  --lch-blue-light: 95% 0.03 255;
  --lch-blue-dark: 80% 0.08 255;
  --lch-blue-medium: 60% 0.2 255;

  --lch-red: 51% 0.2 31;
  --lch-red-medium: 60% 0.2 31;
  --lch-red-dark: 45% 0.2 31;

  --lch-green: 65% 0.234 142.49;
  --lch-green-medium: 55% 0.2 142;
  --lch-green-dark: 45% 0.2 142;

  --lch-purple-medium: 55% 0.2 300;
  --lch-orange: 70% 0.2 44;

  /* 永遠不變的黑色（用於陰影） */
  --lch-always-black: 0% 0 0;

  /* 語意化色彩抽象 */
  --color-negative: oklch(var(--lch-red));
  --color-positive: oklch(var(--lch-green));
  --color-bg: oklch(var(--lch-white));
  --color-text: oklch(var(--lch-black));
  --color-text-reversed: oklch(var(--lch-white));
  --color-link: oklch(var(--lch-blue));
  --color-border: oklch(var(--lch-gray));
  --color-border-dark: oklch(var(--lch-gray-dark));
  --color-selected: oklch(var(--lch-blue-light));
}
```

### 4.2 深色模式支援

**方法一：自動跟隨系統（prefers-color-scheme）**

```css
:root {
  --lch-black: 0% 0 0;
  --lch-white: 100% 0 0;

  /* 深色模式：重新定義色彩值 */
  @media (prefers-color-scheme: dark) {
    --lch-black: 100% 0 0;          /* 黑白對調 */
    --lch-white: 0% 0 0;
    --lch-gray: 25.2% 0 0;
    --lch-gray-dark: 30.12% 0 0;
    --lch-gray-darker: 44.95% 0 0;
    --lch-blue: 72.25% 0.16 248;    /* 調整亮度 */
    --lch-red: 73.8% 0.184 29.18;
    --lch-green: 75% 0.21 141.89;
  }
}
```

**方法二：手動切換（data-theme 屬性）**

```css
:root {
  /* 淺色模式變數 */
  --color-canvas: oklch(100% 0 0);
  --color-ink: oklch(0% 0 0);
}

/* 深色模式（手動切換） */
html[data-theme="dark"] {
  --color-canvas: oklch(15% 0 0);
  --color-ink: oklch(95% 0 0);
}

/* 自動跟隨系統（當未設定 data-theme 時） */
@media (prefers-color-scheme: dark) {
  html:not([data-theme]) {
    --color-canvas: oklch(15% 0 0);
    --color-ink: oklch(95% 0 0);
  }
}
```

### 4.3 主題切換器樣式

```css
.theme-switcher {
  @media (max-width: 479px) {
    flex-direction: column;
  }
}

.theme-switcher__btn {
  --btn-background: var(--color-ink-lightest);
  --btn-border-radius: 0.4em;
  --btn-border-size: 0;
  --btn-gap: 0.1lh;
  --btn-padding: 1em;
  --icon-size: 2em;

  flex: 1;
  flex-direction: column;
  position: relative;

  /* 選中狀態 */
  &:has(input:checked) {
    --btn-background: var(--color-selected);
    --btn-color: var(--color-ink);
  }

  @media (max-width: 479px) {
    flex-direction: row;
  }
}
```

### 4.4 使用 `light-dark()` 函數

```css
/* 根據色彩方案自動選擇值 */
.highlight .gd {
  color: var(--markup-deleted);
  background-color: light-dark(
    lch(39.64 68.17 31.45 / 0.15),  /* 淺色模式 */
    lch(39.64 68.17 31.45 / 0.2)   /* 深色模式 */
  );
}

.highlight .gi {
  color: var(--markup-inserted);
  background-color: light-dark(
    lch(49.14 52.75 142.85 / 0.15),
    lch(83.65 59.31 141.61 / 0.15)
  );
}
```

---

## 5. 排版系統與間距

### 5.1 使用邏輯屬性

邏輯屬性支援 RTL（從右到左）語言：

```css
/* 傳統寫法 → 邏輯屬性 */
/* width      → inline-size */
/* height     → block-size */
/* margin-left  → margin-inline-start */
/* margin-right → margin-inline-end */
/* padding-top    → padding-block-start */
/* padding-bottom → padding-block-end */

.card {
  /* 尺寸 */
  inline-size: 100%;              /* width: 100% */
  max-inline-size: 50ch;          /* max-width: 50ch */
  block-size: auto;               /* height: auto */
  min-block-size: 10rem;          /* min-height: 10rem */

  /* 內距 */
  padding-block: var(--block-space);           /* padding-top/bottom */
  padding-inline: var(--inline-space);         /* padding-left/right */
  padding-block-start: var(--block-space);     /* padding-top */
  padding-inline-end: var(--inline-space);     /* padding-right (LTR) */

  /* 外距 */
  margin-block: var(--block-space);
  margin-inline: auto;                         /* 水平置中 */

  /* 邊框 */
  border-block-start: 1px solid currentColor;  /* border-top */
  border-inline-end: 1px solid currentColor;   /* border-right (LTR) */

  /* 定位 */
  inset-block-start: 0;                        /* top: 0 */
  inset-inline-start: 0;                       /* left: 0 (LTR) */
  inset: 0 auto auto 0;                        /* top/right/bottom/left */
}
```

### 5.2 使用 `ch` 和 `lh` 單位

```css
/* ch：字元 '0' 的寬度，適合文字相關間距 */
.input {
  max-inline-size: 50ch;          /* 約 50 個字元寬 */
  padding-inline: 1ch;            /* 約 1 個字元的內距 */
}

/* lh：行高單位，適合垂直間距 */
.paragraph {
  margin-block: 0.5lh;            /* 半行高的外距 */
  padding-block: 1lh;             /* 一行高的內距 */
}

/* rem：相對於根元素字體大小 */
.container {
  padding: 1rem;
}

/* em：相對於當前元素字體大小 */
.btn {
  padding: 0.5em 1em;             /* 隨字體大小縮放 */
}
```

### 5.3 富文本內容排版

```css
:where(.rich-text-content) {
  --block-margin: 0.5lh;

  h1, h2, h3, h4, h5, h6 {
    font-weight: 800;
    letter-spacing: -0.02ch;
    line-height: 1.1;
    margin-block: 0 var(--block-margin);
    overflow-wrap: break-word;
    text-wrap: balance;           /* 標題文字平衡換行 */
  }

  h1 { font-size: 2em; }
  h2 { font-size: 1.5em; }
  h3 { font-size: 1.17em; }
  h4 { font-size: 1em; }
  h5 { font-size: 0.83em; }
  h6 { font-size: 0.67em; }

  p, ul, ol, blockquote, figure {
    margin-block: 0 var(--block-margin);
    overflow-wrap: break-word;
    text-wrap: pretty;            /* 段落美化換行 */
  }

  ol, ul {
    padding-inline-start: 3ch;
  }

  ol { list-style: decimal; }
  ul { list-style: disc; }

  /* 巢狀列表 */
  li:has(li) {
    list-style: none;

    ol, ul {
      margin: 0;
      padding-inline-start: 2ch;
    }
  }

  blockquote {
    border-inline-start: 0.25em solid var(--color-ink-lighter);
    font-style: italic;
    margin: var(--block-margin) 0;
    padding-inline-start: 2ch;
  }

  /* 程式碼區塊 */
  code, pre {
    background-color: var(--color-canvas);
    border: 1px solid var(--color-ink-lighter);
    border-radius: 0.3em;
    font-family: var(--font-mono);
    font-size: 0.85em;
  }

  code {
    padding: 0.1em 0.3em;
  }

  pre {
    border-radius: 0.5em;
    overflow-x: auto;
    padding: 0.5lh 2ch;
    tab-size: 2;
    white-space: pre;
  }
}
```

---

## 6. 版面配置（Layout）

### 6.1 CSS Grid 主版面

```css
body {
  --footer-height: calc(var(--block-space) + 3.6em + var(--block-space));
  --navbar-height: 4.125em;
  --sidebar-width: 0vw;

  display: grid;
  grid-template-areas:
    "nav sidebar"
    "main sidebar";
  grid-template-columns: 1fr var(--sidebar-width);
  grid-template-rows: min-content 1fr;
  max-block-size: 100dvh;

  /* 有側邊欄時 */
  &.sidebar {
    @media (min-width: 100ch) {
      --sidebar-width: 26vw;
    }
  }
}

/* 指派區域 */
#nav {
  grid-area: nav;
}

#main-content {
  grid-area: main;
  display: flex;
  flex-direction: column;
  overflow: auto;
}

#sidebar {
  grid-area: sidebar;
  position: relative;
  transition: transform 300ms ease;

  /* 側邊欄開啟時 */
  .sidebar & {
    backdrop-filter: blur(66px);
    background-color: oklch(var(--lch-white) / 0.66);
    block-size: 100dvh;
    z-index: 3;

    /* 小螢幕：固定定位 + 滑入效果 */
    @media (max-width: 100ch) {
      inset: 0;
      position: fixed;
      transform: translate(100%);
    }
  }

  &.open {
    @media (max-width: 100ch) {
      transform: translate(0);
    }
  }
}
```

### 6.2 Flexbox 佈局

```css
/* 水平排列 + 間距 */
.flex-row {
  display: flex;
  align-items: center;
  gap: var(--inline-space);
}

/* 垂直排列 */
.flex-column {
  display: flex;
  flex-direction: column;
  gap: var(--block-space);
}

/* 換行 */
.flex-wrap {
  display: flex;
  flex-wrap: wrap;
  gap: var(--inline-space);
}

/* Flex 子項目 */
.flex-grow { flex-grow: 1; }
.flex-shrink-0 { flex-shrink: 0; }
.flex-item-justify-start { margin-inline-end: auto; }
.flex-item-justify-end { margin-inline-start: auto; }
```

### 6.3 多欄卡片佈局

```css
.card-columns {
  --column-gap: 8px;
  --column-width-collapsed: 40px;
  --column-width-expanded: 450px;

  container-type: inline-size;
  display: grid;
  gap: var(--column-gap);
  grid-template-columns: 1fr var(--column-width-expanded) 1fr;
  margin-inline: auto;
  max-inline-size: var(--main-width);
  overflow-x: auto;
  overflow-y: hidden;

  /* 有展開欄位時 */
  &:has(.cards:not(.is-collapsed)) {
    grid-template-columns: auto var(--column-width-expanded) auto;
  }
}

/* 欄位容器 */
.cards {
  inline-size: var(--column-width-expanded);
  position: relative;

  &.is-collapsed {
    inline-size: var(--column-width-collapsed);
  }
}
```

### 6.4 格線卡片佈局

```css
.cards--grid {
  --cards-gap: 1rem;
  --card-grid-columns: 1;

  container-type: inline-size;
  display: flex;
  flex-wrap: wrap;
  gap: var(--cards-gap);
  justify-content: center;

  @media (min-width: 640px) {
    --card-grid-columns: 2;
  }

  @media (min-width: 960px) {
    --card-grid-columns: 3;
  }

  .card {
    /* 計算每張卡片寬度 */
    inline-size: calc(
      (100% - var(--cards-gap) * (var(--card-grid-columns) - 1))
      / var(--card-grid-columns)
    );
  }
}
```

---

## 7. 響應式設計

### 7.1 媒體查詢策略

```css
/* 行動裝置優先（Mobile-first） */
.component {
  /* 預設：行動裝置樣式 */
  padding: var(--block-space);
}

@media (min-width: 640px) {
  .component {
    /* 平板 */
    padding: var(--block-space-double);
  }
}

@media (min-width: 960px) {
  .component {
    /* 桌面 */
    max-inline-size: 80ch;
  }
}

@media (min-width: 1200px) {
  .component {
    /* 大螢幕 */
    max-inline-size: 100ch;
  }
}
```

### 7.2 使用 `ch` 單位作為斷點

```css
/* 基於字元寬度的斷點更語意化 */
@media (min-width: 100ch) {
  /* 約 100 個字元寬 */
}

@media (max-width: 80ch) {
  /* 小於 80 字元寬 */
}
```

### 7.3 互動方式媒體查詢

```css
/* 滑鼠/觸控偵測 */
@media (any-hover: hover) {
  .btn:hover {
    filter: brightness(0.9);
  }
}

@media (hover: none) {
  /* 觸控裝置：無 hover 狀態 */
  .tooltip {
    display: none;
  }
}

/* 精確 vs 粗略指標 */
@media (pointer: fine) {
  /* 滑鼠：可以有小按鈕 */
  .btn { --btn-size: 2em; }
}

@media (pointer: coarse) {
  /* 觸控：需要大觸控區域 */
  .btn { --btn-size: 3em; }
}
```

### 7.4 容器查詢（Container Queries）

```css
/* 定義容器 */
.cards {
  container-type: inline-size;
}

/* 基於容器尺寸的樣式 */
.cards .card {
  /* 使用 cqi 單位（容器 inline 尺寸百分比） */
  font-size: clamp(0.6rem, 0.85cqi, 100px);
  padding: 0.5cqi;
}

/* 容器查詢 */
@container (min-width: 400px) {
  .card {
    --card-grid-columns: 2;
  }
}
```

### 7.5 Profile Layout 響應式範例

```css
.profile-layout {
  display: flex;
  gap: var(--inline-space);

  @media (min-width: 800px) {
    align-items: stretch;
    justify-content: center;
  }

  @media (max-width: 799px) {
    align-items: center;
    flex-direction: column;
  }
}
```

---

## 8. 組件樣式設計

### 8.1 組件設計原則

**使用 CSS 變數實現客製化：**

```css
.panel {
  /* 定義所有可覆蓋的屬性 */
  --panel-bg: var(--color-canvas);
  --panel-border-size: 1px;
  --panel-border-color: var(--color-ink-lighter);
  --panel-border-radius: 1em;
  --panel-padding: var(--block-space);
  --panel-size: 60ch;

  /* 應用變數 */
  background-color: var(--panel-bg);
  border: var(--panel-border-size) solid var(--panel-border-color);
  border-radius: var(--panel-border-radius);
  padding: var(--panel-padding);
  inline-size: var(--panel-size);
  max-inline-size: 100%;

  /* 響應式調整 */
  @media (min-width: 640px) {
    --panel-size: 100%;
    --panel-padding: var(--block-space-double);
  }
}

/* 變體 */
.panel--wide {
  --panel-size: 60ch;
}

.panel--centered {
  --panel-border-size: 0;
  --panel-size: 100%;

  @media (min-width: 640px) {
    --panel-size: 42ch;
  }
}
```

### 8.2 使用 `:where()` 降低權重

```css
/* :where() 內的選擇器權重為 0 */
:where(.rich-text-content) {
  h1, h2, h3 {
    font-weight: 800;
  }
}

/* 這樣可以輕易覆蓋 */
.custom-heading {
  font-weight: 400;  /* 可以覆蓋上面的 800 */
}
```

### 8.3 使用 `:has()` 父元素選擇

```css
/* 如果卡片包含關閉狀態，套用不同顏色 */
.card:has(.card__closed) {
  --card-color: var(--color-card-complete) !important;
}

/* 如果對話框開啟，提升層級 */
.card-perma:has(dialog[open]) {
  z-index: 2;
}

/* 如果輸入框獲得焦點，顯示外框 */
.input-group:has(.input:focus) {
  box-shadow: 0 0 0 2px var(--color-link);
}

/* 隱藏空列表 */
.popup__section:not(:has(.popup__item)) {
  display: none;
}

/* 當所有項目都隱藏時，隱藏區段 */
.popup__section:has(.popup__item[hidden]):not(:has(.popup__item:not([hidden]))) {
  display: none;
}
```

### 8.4 使用 CSS Nesting

```css
.card {
  background-color: var(--card-bg);
  padding: var(--card-padding);

  /* 巢狀選擇器 */
  .card__header {
    display: flex;
    gap: 1ch;
  }

  .card__body {
    padding-block: var(--block-space);
  }

  /* 狀態修飾 */
  &.card--active {
    border-color: var(--color-link);
  }

  /* Hover 狀態 */
  @media (any-hover: hover) {
    &:hover {
      box-shadow: var(--shadow-lg);
    }
  }

  /* 響應式巢狀 */
  @media (max-width: 639px) {
    --card-padding: var(--block-space);
  }
}
```

---

## 9. 按鈕系統

### 9.1 基礎按鈕

```css
:root {
  --btn-size: 2.65em;
}

.btn {
  /* 可覆蓋變數 */
  --btn-background: var(--color-text-reversed);
  --btn-border-color: var(--color-border-darker);
  --btn-border-radius: 2em;
  --btn-border-size: 1px;
  --btn-color: var(--color-text);
  --btn-padding: 0.5em 1.1em;

  /* 基礎樣式 */
  align-items: center;
  background-color: var(--btn-background);
  border-radius: var(--btn-border-radius);
  border: var(--btn-border-size) solid var(--btn-border-color);
  color: var(--btn-color);
  cursor: pointer;
  display: inline-flex;
  font-weight: 600;
  gap: 0.5em;
  justify-content: center;
  padding: var(--btn-padding);
  text-align: center;

  /* 過渡效果 */
  transition:
    box-shadow 150ms ease,
    background-color 150ms ease,
    filter 150ms ease;

  /* Hover 效果 */
  @media (any-hover: hover) {
    &:where(:not(:active):hover) {
      filter: var(--hover-filter);
      box-shadow: 0 0 0 var(--hover-size) var(--hover-color);
    }
  }

  /* 焦點狀態 */
  &:where(:not(:active)):focus-visible {
    outline-width: var(--outline-size);
    outline-color: var(--color-link);
    outline-offset: calc(var(--outline-size) * 2);
  }

  /* 禁用狀態 */
  &:where([disabled]):not(:hover):not(:active) {
    cursor: not-allowed;
    filter: brightness(0.75);
  }
}
```

### 9.2 按鈕變體

```css
/* 反轉色按鈕 */
.btn--reversed {
  --btn-background: var(--color-text);
  --btn-color: var(--color-text-reversed);
  --btn-border-color: transparent;
  --hover-filter: brightness(0.7);

  img:not(.avatar) {
    filter: invert(100%);

    @media (prefers-color-scheme: dark) {
      filter: invert(0%);
    }
  }
}

/* 危險動作按鈕 */
.btn--negative {
  --btn-background: var(--color-negative);
  --btn-color: var(--color-text-reversed);
  --btn-border-color: transparent;
  --hover-filter: brightness(0.7);
}

/* 無邊框按鈕 */
.btn--borderless {
  --btn-border-color: transparent;
}

/* 純文字按鈕 */
.btn--plain {
  --btn-background: transparent;
  --btn-border-color: transparent;
  --btn-padding: 0;
}

/* 脈動效果（引起注意） */
.btn--pulsing {
  animation: pulsing-outline 2s infinite both;
  outline: 0 solid var(--color-alert);
}

/* 成功狀態 */
.btn--success {
  animation: success 1s ease-out;
}
```

### 9.3 圓形圖示按鈕

```css
.btn {
  /* 當按鈕只有圖示 + 螢幕閱讀器文字 */
  &:where(:has(.for-screen-reader):has(img, figure)) {
    --btn-border-radius: 50%;
    --btn-padding: 0;

    aspect-ratio: 1;
    block-size: var(--btn-size);
    display: grid;
    inline-size: var(--btn-size);
    place-items: center;

    > * {
      grid-area: 1/1;  /* 所有子元素疊在一起 */
    }
  }
}
```

### 9.4 按鈕載入狀態

```css
.btn {
  [aria-busy] &:disabled {
    position: relative;

    > * {
      visibility: hidden;
    }

    &::after {
      --mask: no-repeat radial-gradient(#000 68%, #0000 71%);
      --size: 1.25em;

      -webkit-mask: var(--mask), var(--mask), var(--mask);
      -webkit-mask-size: 28% 45%;
      animation: submitting 1s infinite linear;
      aspect-ratio: 8/5;
      background: currentColor;
      content: "";
      inline-size: var(--size);
      inset: 50%;
      position: absolute;
      margin-block: calc((var(--size) / 3) * -1);
      margin-inline: calc((var(--size) / 2) * -1);
    }
  }
}
```

### 9.5 選中狀態按鈕

```css
.btn:has(input:checked) {
  --btn-background: var(--color-text);
  --btn-color: var(--color-text-reversed);

  img {
    filter: invert(100%);
  }

  @media (prefers-color-scheme: dark) {
    img {
      filter: invert(0);
    }
  }
}
```

---

## 10. 表單輸入元素

### 10.1 基礎輸入框

```css
.input {
  --input-accent-color: var(--color-text);
  --input-background: transparent;
  --input-border-color: var(--color-border-darker);
  --input-border-radius: 0.5em;
  --input-border-size: 1px;
  --input-color: var(--color-text);
  --input-padding: 0.5em 0.8em;

  accent-color: var(--input-accent-color);
  background-color: var(--input-background);
  border-radius: var(--input-border-radius);
  border: var(--input-border-size) solid var(--input-border-color);
  color: var(--input-color);
  font-size: max(16px, 1em);        /* 防止 iOS 縮放 */
  inline-size: 100%;
  padding: var(--input-padding);
  resize: none;

  /* 移除搜尋框裝飾 */
  &[type="search"] {
    &::-webkit-search-decoration,
    &::-webkit-search-results-button,
    &::-webkit-search-results-decoration {
      display: none;
    }
  }

  /* 自動填入樣式 */
  &:autofill,
  &:-webkit-autofill {
    -webkit-text-fill-color: var(--color-text);
    -webkit-box-shadow: 0 0 0px 1000px var(--color-selected) inset;
  }

  /* 焦點狀態 */
  &:where(:not(:active)):focus {
    --input-border-color: var(--color-selected-dark);
    box-shadow: 0 0 0 var(--hover-size) var(--color-selected-dark);
  }
}
```

### 10.2 輸入框變體

```css
/* 透明輸入框 */
.input--transparent {
  --input-border-color: currentColor;
  --input-color: currentColor;
  --input-background: transparent;
}

/* 隱形輸入框（用於無障礙） */
.input--invisible {
  background-color: transparent;
  block-size: 5px;
  border: none;
  inline-size: 5px;
  opacity: 0.1;

  &:focus {
    outline: none;
  }
}

/* 程式碼輸入框 */
.input--code {
  font-family: var(--font-mono);
  white-space: pre-wrap !important;
  word-wrap: break-word;
}
```

### 10.3 開關（Switch）

```css
.switch {
  block-size: 1.75em;
  display: inline-flex;
  inline-size: 3em;
  position: relative;
  border-radius: 2em;

  @media (any-hover: hover) {
    &:hover .switch__btn {
      filter: brightness(0.7);
    }
  }

  /* 焦點環 */
  &:focus-within .switch__btn {
    box-shadow:
      0 0 0 2px var(--color-bg),
      0 0 0 4px var(--color-link);
  }
}

/* 隱藏原生 checkbox */
.switch__input {
  block-size: 0;
  inline-size: 0;
  opacity: 0.1;
}

/* 開關按鈕外觀 */
.switch__btn {
  background-color: var(--color-border-darker);
  border-radius: 2em;
  cursor: pointer;
  inset: 0;
  position: absolute;
  transition: 150ms ease;

  /* 圓形把手 */
  &::before {
    background-color: var(--color-text-reversed);
    block-size: 1.35em;
    border-radius: 50%;
    content: "";
    inline-size: 1.35em;
    inset-block-end: 0.2em;
    inset-inline-start: 0.2em;
    position: absolute;
    transition: 150ms ease;
  }

  /* 禁用狀態 */
  .switch__input:disabled + & {
    background-color: var(--color-border-darker) !important;
    cursor: not-allowed;
  }

  /* 開啟狀態 */
  .switch__input:checked + & {
    background-color: var(--color-text);

    &::before {
      transform: translateX(1.2em);
    }
  }
}
```

### 10.4 自動調整高度文字框

```css
@layer components {
  @supports not (field-sizing: content) {
    /* Polyfill：不支援 field-sizing 時使用 */
    .autoresize__wrapper {
      display: grid !important;
      position: relative;

      > *, &::after {
        grid-area: 1 / 1 / 2 / 2;
      }

      &::after {
        content: attr(data-autoresize-clone-value) " ";
        font: inherit;
        line-height: inherit;
        padding-block: var(--autosize-block-padding, 0);
        visibility: hidden;
        white-space: pre-wrap;
      }
    }

    .autoresize__textarea {
      inset: 0;
      overflow: hidden;
      position: absolute;
      resize: none;
    }
  }
}

/* 現代瀏覽器直接用 field-sizing */
@supports (field-sizing: content) {
  .auto-height-textarea {
    field-sizing: content;
    min-inline-size: 20ch;
  }
}
```

### 10.5 步驟/待辦項目勾選框

```css
.step__checkbox {
  appearance: none;
  background-color: var(--color-canvas);
  block-size: 1.1em;
  border: 1px solid currentColor;
  border-radius: 0.15em;
  display: grid;
  inline-size: 1.1em;
  place-content: center;

  /* 勾選圖示 */
  &::before {
    background-color: CanvasText;
    block-size: 0.65em;
    box-shadow: inset 1em 1em currentColor;
    clip-path: polygon(14% 44%, 0 65%, 50% 100%, 100% 16%, 80% 0%, 43% 62%);
    content: "";
    inline-size: 0.65em;
    transform: scale(0);
    transform-origin: center;
    transition: 150ms transform ease-in-out;
  }

  /* 勾選狀態 */
  &:checked::before {
    transform: scale(1) rotate(10deg);
  }

  /* 禁用狀態 */
  &:where([disabled]):not(:hover):not(:active) {
    filter: none;
    opacity: 0.5;
  }
}
```

---

## 11. 卡片組件

### 11.1 基礎卡片結構

```css
.card {
  /* 變數定義 */
  --avatar-size: 2.75em;
  --card-bg-color: color-mix(in srgb, var(--card-color) 4%, var(--color-canvas));
  --card-content-color: color-mix(in srgb, var(--card-color) 30%, var(--color-ink));
  --card-text-color: color-mix(in srgb, var(--card-color) 75%, var(--color-ink));
  --card-border: 1px solid color-mix(in srgb, var(--card-color) 33%, var(--color-ink-inverted));
  --card-header-space: 1ch;
  --card-padding-inline: var(--inline-space-double);
  --card-padding-block: var(--block-space);
  --border-radius: 0.2em;

  /* 基礎樣式 */
  aspect-ratio: var(--card-aspect-ratio, auto);
  background-color: var(--card-bg-color);
  border-radius: var(--border-radius);
  box-shadow: var(--shadow);
  display: flex;
  flex-direction: column;
  inline-size: 100%;
  padding: var(--card-padding-block) var(--card-padding-inline);
  position: relative;
  text-align: start;

  /* 深色模式邊框 */
  html[data-theme="dark"] & {
    box-shadow: 0 0 0 1px var(--color-ink-lighter);
  }

  @media (prefers-color-scheme: dark) {
    html:not([data-theme]) & {
      box-shadow: 0 0 0 1px var(--color-ink-lighter);
    }
  }
}
```

### 11.2 卡片標題區

```css
.card__header {
  align-items: center;
  border-radius: var(--border-radius) 0 0 0;
  display: flex;
  flex-wrap: nowrap;
  gap: var(--card-header-space);
  margin-block-start: calc(-1 * var(--card-padding-block));
  margin-inline: calc(-1 * var(--card-padding-inline)) calc(-0.5 * var(--card-padding-inline));
}

.card__board {
  background-color: var(--card-color);
  border-radius: var(--border-radius) 0 var(--border-radius) 0;
  color: var(--color-ink-inverted);
  display: inline-flex;
  font-weight: 600;
  padding-block: 0.25lh;
  padding-inline: var(--card-padding-inline) 1ch;

  /* 可點擊狀態 */
  &:has(.board-picker__button) {
    cursor: pointer;
    transition: background-color 100ms ease-out;

    @media (any-hover: hover) {
      &:hover {
        background-color: color-mix(in srgb, var(--card-color) 90%, var(--color-ink));
      }
    }
  }
}
```

### 11.3 卡片內容區

```css
.card__body {
  display: flex;
  flex-grow: 1;
  gap: 1ch;
  inline-size: 100%;
  padding-block: calc(var(--card-padding-block) / 2);

  @media (min-width: 640px) {
    gap: var(--card-padding-inline);
  }
}

.card__content {
  color: var(--card-content-color);
  contain: inline-size;
  flex: 2 1 auto;
  max-inline-size: 100%;
}

.card__title {
  --lines: 3;

  color: var(--card-content-color);
  font-size: var(--text-xx-large);
  font-weight: 900;
  line-height: 1.15;
  text-wrap: balance;
}
```

### 11.4 卡片元資訊區

```css
.card__meta {
  --meta-spacer-block: 0.5ch;
  --meta-spacer-inline: 0.75ch;

  align-items: center;
  color: var(--card-text-color);
  display: grid;
  font-size: var(--text-x-small);
  font-weight: 500;
  grid-template-areas:
    "avatars-author text-added text-updated avatars-assignees"
    "avatars-author text-author text-assignees avatars-assignees";
  grid-template-columns: auto auto 1fr auto;
  text-transform: uppercase;

  strong, .local-time-value {
    font-weight: 900;
  }
}

/* 指派 Grid 區域 */
.card__meta-avatars--author { grid-area: avatars-author; }
.card__meta-avatars--assignees { grid-area: avatars-assignees; }
.card__meta-text--added { grid-area: text-added; }
.card__meta-text--author { grid-area: text-author; }
.card__meta-text--updated { grid-area: text-updated; }
.card__meta-text--assignees { grid-area: text-assignees; }
```

### 11.5 完成標記

```css
.card__closed {
  --stamp-color: oklch(var(--lch-green-medium) / 0.65);

  align-items: center;
  background-color: color-mix(in srgb, var(--card-bg-color) 90%, transparent);
  border-radius: 0.2em;
  border: 0.5ch solid var(--stamp-color);
  color: var(--color-ink-dark);
  display: flex;
  flex-direction: column;
  font-weight: bold;
  inset: auto 1ch 1ch auto;
  position: absolute;
  rotate: 5deg;
  transform-origin: top right;
  padding: 1ch;
}

.card__closed-title {
  color: var(--stamp-color);
  font-size: 1.3em;
  font-weight: 900;
  text-transform: uppercase;
}
```

---

## 12. 導航與選單

### 12.1 頂部導航

```css
#nav {
  align-items: center;
  column-gap: var(--inline-space-half);
  display: flex;
  inset: 0 0 auto 0;
  inset-inline-end: var(--sidebar-width);
  padding-block: var(--block-space);
  padding-inline: calc(var(--inline-space) * 1.5) var(--inline-space-double);
  pointer-events: none;           /* 允許點擊穿透 */
  position: fixed;
  z-index: 2;

  /* 背景漸層（小螢幕） */
  .sidebar & {
    @media (max-width: 100ch) {
      padding-block: var(--block-space-half);

      &::before {
        background: linear-gradient(
          180deg,
          oklch(var(--lch-white)) 20%,
          oklch(var(--lch-white) / 0) 100%
        );
        content: "";
        inset: 0;
        position: absolute;
        z-index: -1;
      }
    }
  }
}

/* 跳過導航連結（無障礙） */
.skip-navigation {
  --left-offset: -999em;

  inset-block-start: 4rem;
  inset-inline-start: var(--left-offset);
  position: absolute;
  white-space: nowrap;
  z-index: 11;

  &:focus {
    --left-offset: var(--inline-space);
  }
}
```

### 12.2 側邊欄導航

```css
:root {
  --sidebar-inline-space: max(calc(var(--inline-space) * 1.5), 1vw);
  --sidebar-tools-height: calc(var(--block-space) + var(--btn-size) + var(--block-space) * 2);
}

.sidebar__container {
  block-size: 100dvh;
  max-block-size: 100dvh;
  padding-block-end: var(--sidebar-tools-height);
}

.sidebar__tools {
  backdrop-filter: blur(12px);
  inset: auto 0 0 0;
  padding-block: calc(var(--block-space) * 1.5);
  padding-inline: var(--sidebar-inline-space);
  position: fixed;

  @media (min-width: 100ch) {
    inline-size: var(--sidebar-width);
    inset-inline-start: auto;
  }
}

/* 側邊欄切換按鈕 */
.sidebar__toggle {
  inset-block-start: var(--block-space-half);
  inset-inline-start: calc((var(--btn-size) + max(var(--inline-space), 1vw)) * -1);
  position: absolute;
  transition:
    inset-inline-start 300ms ease,
    border-color 300ms ease,
    background-color 300ms ease;
  z-index: 5;

  /* 未讀指示器 */
  #sidebar:where(:not(.open):has(.unread)) &::after {
    --size: 1em;

    aspect-ratio: 1;
    background-color: var(--color-negative);
    block-size: var(--size);
    border-radius: calc(var(--size) * 2);
    content: "";
    inset-block-start: calc(var(--size) / -4);
    inset-inline-end: calc(var(--size) / -4);
    position: absolute;
  }

  @media (min-width: 100ch) {
    display: none;
  }

  .open & {
    inset-inline-start: var(--sidebar-inline-space);
  }
}
```

---

## 13. 對話框與彈出視窗

### 13.1 原生 Dialog 樣式

```css
.dialog {
  --width: 50ch;

  background-color: var(--color-bg);
  margin-inline: var(--inline-space);
  inline-size: var(--width);
  max-inline-size: calc(100dvw - var(--inline-space) * 2);
  position: relative;

  /* 背景遮罩 */
  &::backdrop {
    background-image: linear-gradient(
      45deg,
      #fff500,
      #ff9f00,
      #f00,
      #ec0061
    );
    opacity: 0.75;
  }
}

/* 關閉按鈕位置 */
.dialog__close {
  position: absolute;
  inset: calc(var(--block-space) * 1.5) var(--inline-space) auto auto;
}
```

### 13.2 對話框動畫

```css
:is(.dialog) {
  border: 0;
  opacity: 0;
  transform: scale(0.2);
  transform-origin: top center;
  transition: var(--dialog-duration) allow-discrete;
  transition-property: display, opacity, overlay, transform;

  &::backdrop {
    background-color: var(--color-black);
    opacity: 0;
    transition: var(--dialog-duration) allow-discrete;
    transition-property: display, opacity, overlay;
  }

  /* 開啟狀態 */
  &[open] {
    opacity: 1;
    transform: scale(1);

    &::backdrop {
      opacity: 0.5;
    }
  }

  /* 開啟時的起始狀態 */
  @starting-style {
    &[open] {
      opacity: 0;
      transform: scale(0.2);
    }

    &[open]::backdrop {
      opacity: 0;
    }
  }
}
```

### 13.3 彈出視窗（Popup）

```css
.popup {
  --btn-background: transparent;
  --panel-border-radius: 0.5em;
  --panel-padding: var(--block-space);
  --panel-size: auto;
  --popup-icon-size: 24px;
  --popup-item-padding-inline: 0.4rem;

  inset: 0 auto auto 50%;
  max-block-size: 70dvh;
  max-inline-size: min(55ch, calc(100vw - var(--panel-padding)));
  min-inline-size: min(25ch, calc(100vw - var(--panel-padding)));
  overflow: auto;
  position: absolute;
  transform: translateX(-50%);
  z-index: var(--z-popup);

  &[open] {
    display: flex;
  }

  /* 方向變體 */
  &.orient-left {
    inset-inline: auto 0;
    transform: translateX(0);
  }

  &.orient-right {
    inset-inline: 0 auto;
    transform: translateX(0);
  }
}

/* 彈出項目 */
.popup__item {
  align-items: center;
  background: transparent;
  border-radius: 0.3em;
  display: flex;
  inline-size: 100%;

  @media (any-hover: hover) {
    &:hover {
      background: var(--color-ink-lightest);
    }
  }

  /* 選中狀態 */
  &[aria-selected] {
    background-color: var(--color-selected);
  }

  /* 勾選標記 */
  .checked {
    display: none;
  }

  &[aria-checked="true"] .checked {
    display: block;
  }
}
```

### 13.4 燈箱（Lightbox）

```css
.lightbox {
  --dialog-duration: 350ms;
  --lightbox-padding: 3vmin;

  background-color: transparent;
  block-size: 100dvh;
  border: 0;
  inline-size: 100dvw;
  inset: 0;
  margin: auto;
  max-height: unset;
  max-width: unset;
  overflow: hidden;
  padding: var(--lightbox-padding);
  text-align: center;

  &::backdrop {
    backdrop-filter: blur(16px);
    background-color: oklch(var(--lch-black) / 50%);
  }

  /* 關閉狀態 */
  &, &::backdrop {
    opacity: 0;
    transition: var(--dialog-duration) allow-discrete;
    transition-property: display, opacity, overlay;
  }

  /* 開啟狀態 */
  &[open], &[open]::backdrop {
    opacity: 1;

    @starting-style {
      opacity: 0;
    }

    .lightbox__figure {
      animation: slide-up var(--dialog-duration);
    }
  }
}

/* 防止背景滾動 */
html:has(.lightbox[open]) {
  overflow: clip;
}
```

---

## 14. 動畫與過渡效果

### 14.1 關鍵影格定義

```css
/* 淡入後淡出 */
@keyframes appear-then-fade {
  0%, 100% { opacity: 0; }
  5%, 60%  { opacity: 1; }
}

/* 彈跳縮放 */
@keyframes boost {
  0%   { transform: scale(0.3);  opacity: 0; }
  50%  { transform: scale(1.15); opacity: 1; }
  100% { transform: scale(1); }
}

/* 脈動外框 */
@keyframes pulsing-outline {
  0%  { outline-width: 0; }
  33% { outline-width: 4px; }
}

/* 縮小淡出 */
@keyframes scale-fade-out {
  0%   { transform: scale(1); opacity: 1; }
  100% { transform: scale(0); opacity: 0; }
}

/* 搖晃 */
@keyframes shake {
  0%  { transform: translateX(-2rem); }
  25% { transform: translateX(2rem); }
  50% { transform: translateX(-1rem); }
  75% { transform: translateX(1rem); }
}

/* 載入動畫（三點） */
@keyframes submitting {
  0%    { -webkit-mask-position: 0% 0%,   50% 0%,   100% 0% }
  12.5% { -webkit-mask-position: 0% 50%,  50% 0%,   100% 0% }
  25%   { -webkit-mask-position: 0% 100%, 50% 50%,  100% 0% }
  37.5% { -webkit-mask-position: 0% 100%, 50% 100%, 100% 50% }
  50%   { -webkit-mask-position: 0% 100%, 50% 100%, 100% 100% }
  62.5% { -webkit-mask-position: 0% 50%,  50% 100%, 100% 100% }
  75%   { -webkit-mask-position: 0% 0%,   50% 50%,  100% 100% }
  87.5% { -webkit-mask-position: 0% 0%,   50% 0%,   100% 50% }
  100%  { -webkit-mask-position: 0% 0%,   50% 0%,   100% 0% }
}

/* 成功閃爍 */
@keyframes success {
  0%  { background-color: var(--color-border-darker); scale: 0.8; }
  20% { background-color: var(--color-border-darker); scale: 1; }
}

/* 搖擺 */
@keyframes wiggle {
  0%   { transform: rotate(0deg); }
  20%  { transform: rotate(3deg); }
  40%  { transform: rotate(-3deg); }
  60%  { transform: rotate(3deg); }
  80%  { transform: rotate(-3deg); }
  100% { transform: rotate(0deg); }
}

/* 上浮淡出 */
@keyframes zoom-fade {
  100% { transform: translateY(-2em); opacity: 0; }
}

/* 滑入上方 */
@keyframes slide-up {
  from { transform: translateY(1rem); opacity: 0; }
  to   { transform: translateY(0); opacity: 1; }
}

/* 滑出下方 */
@keyframes slide-down {
  from { transform: translateY(0); opacity: 1; }
  to   { transform: translateY(1rem); opacity: 0; }
}

/* 游標閃爍 */
@keyframes blink {
  50% { opacity: 0; }
}
```

### 14.2 使用動畫

```css
/* 閃現訊息 */
.flash__inner {
  animation: appear-then-fade 3s 300ms both;
}

/* 搖晃（錯誤提示） */
.shake {
  animation: shake 400ms both;
}

/* 刪除項目 */
.boost--deleting {
  animation: scale-fade-out 0.2s both;
}

/* 反應表情彈出 */
.reaction__form.expanded {
  animation: boost 300ms both;
}
```

### 14.3 過渡效果

```css
/* 基礎過渡 */
.btn {
  transition:
    box-shadow 150ms ease,
    outline-offset 150ms ease,
    background-color 150ms ease,
    opacity 150ms ease,
    filter 150ms ease;
}

/* 彈性過渡（overshoot） */
.sidebar {
  transition: transform 300ms cubic-bezier(0.25, 1.25, 0.5, 1);
}

/* 使用 CSS 變數控制 */
:root {
  --ease-out-overshoot: cubic-bezier(0.25, 1.25, 0.5, 1);
  --ease-out-overshoot-subtle: cubic-bezier(0.25, 1.1, 0.5, 1);
}

.tray {
  transition: inset var(--tray-duration) var(--ease-out-overshoot-subtle);
}
```

### 14.4 View Transitions（視圖過渡）

```css
/* 命名視圖過渡 */
.bar {
  view-transition-name: bar;
}

/* 控制過渡層級 */
::view-transition-group(bar) {
  z-index: 99;
}

.tray--pins {
  view-transition-name: tray-pins;
}

::view-transition-group(tray-pins) {
  z-index: 100;
}

/* 在過渡期間禁用 */
.card {
  .tray & {
    view-transition-name: unset !important;
  }
}
```

### 14.5 提示框（Tooltip）動畫

```css
[data-controller~="tooltip"] {
  --tooltip-delay: 750ms;
  --tooltip-duration: 150ms;

  .for-screen-reader {
    background: var(--color-ink);
    border-radius: 0.5ch;
    color: var(--color-canvas);
    font-size: var(--text-x-small);
    inset: -1ch auto auto 50%;
    opacity: 0;
    padding: 0.25ch 1ch;
    transition: var(--tooltip-duration) ease-out allow-discrete;
    transition-property: opacity;
    translate: -50% -100%;
  }

  @media(any-hover: hover) {
    &:hover .for-screen-reader {
      block-size: auto !important;
      clip-path: none !important;
      inline-size: auto !important;
      opacity: 1;
      transition-delay: var(--tooltip-delay);
      z-index: var(--z-tooltip);
    }
  }
}
```

---

## 15. 圖示系統

### 15.1 CSS Mask 圖示

```css
.icon {
  -webkit-touch-callout: none;
  background-color: currentColor;        /* 使用文字顏色 */
  block-size: var(--icon-size, 1em);
  display: inline-block;
  flex-shrink: 0;
  inline-size: var(--icon-size, 1em);
  mask-image: var(--svg);                /* SVG 作為遮罩 */
  mask-position: center;
  mask-repeat: no-repeat;
  mask-size: var(--icon-size, 1em);
  pointer-events: none;
  user-select: none;
}

/* 圖片類型的圖示不需要背景 */
img.icon {
  background: none;
}

/* 圖示定義 */
.icon--add { --svg: url("add.svg"); }
.icon--arrow-left { --svg: url("arrow-left.svg"); }
.icon--arrow-right { --svg: url("arrow-right.svg"); }
.icon--check { --svg: url("check.svg"); }
.icon--close { --svg: url("close.svg"); }
.icon--menu { --svg: url("menu.svg"); }
.icon--search { --svg: url("search.svg"); }
.icon--settings { --svg: url("settings.svg"); }
/* ... 更多圖示 ... */
```

### 15.2 深色模式圖示處理

```css
/* 需要反轉的圖示 */
.colorize--white {
  filter: invert(100%);

  @media (prefers-color-scheme: dark) {
    filter: invert(0%);
  }
}

.colorize--black {
  filter: invert(0%);

  @media (prefers-color-scheme: dark) {
    filter: invert(100%);
  }
}

/* 按鈕內的圖示 */
.btn img:not([class]) {
  filter: invert(0);

  @media (prefers-color-scheme: dark) {
    filter: invert(100%);
  }
}

/* 反轉按鈕的圖示 */
.btn--reversed img:not(.avatar) {
  filter: invert(100%);

  @media (prefers-color-scheme: dark) {
    filter: invert(0%);
  }
}
```

---

## 16. 工具類（Utilities）

### 16.1 文字工具類

```css
/* 大小 */
.txt-small { font-size: 0.8rem; }
.txt-medium { font-size: 1rem; }
.txt-large { font-size: 1.4rem; }
.txt-x-large { font-size: 1.8rem; }
.txt-xx-large { font-size: 2.4rem; }

/* 對齊 */
.txt-align-center { text-align: center; }
.txt-align-start { text-align: start; }
.txt-align-end { text-align: end; }

/* 顏色 */
.txt-primary { color: var(--color-text); }
.txt-reversed { color: var(--color-text-reversed); }
.txt-negative { color: var(--color-negative); }
.txt-subtle { color: var(--color-border-darker); }

/* 樣式 */
.txt-undecorated { text-decoration: none; }
.txt-tight-lines { line-height: 1.2; }
.txt-normal { font-weight: 400; font-style: normal; }
.txt-nowrap { white-space: nowrap; }
```

### 16.2 Flexbox 工具類

```css
/* 顯示 */
.flex { display: flex; }
.flex-inline { display: inline-flex; }
.flex-column { flex-direction: column; }
.flex-wrap { flex-wrap: wrap; }

/* 主軸對齊 */
.justify-end { justify-content: end; }
.justify-start { justify-content: start; }
.justify-center { justify-content: center; }
.justify-space-between { justify-content: space-between; }

/* 交叉軸對齊 */
.align-center { align-items: center; }
.align-start { align-items: start; }
.align-end { align-items: end; }
.align-self-start { align-self: start; }

/* Flex 項目 */
.flex-item-grow { flex-grow: 1; }
.flex-item-no-shrink { flex-shrink: 0; }
.flex-item-justify-start { margin-inline-end: auto; }
.flex-item-justify-end { margin-inline-start: auto; }

/* 間距 */
.gap {
  column-gap: var(--column-gap, var(--inline-space));
  row-gap: var(--row-gap, var(--block-space));
}

.gap-half {
  column-gap: var(--inline-space-half);
  row-gap: var(--block-space-half);
}
```

### 16.3 尺寸工具類

```css
.full-width { inline-size: 100%; }
.min-width { min-inline-size: 0; }
.max-width { max-inline-size: 100%; }
.min-content { inline-size: min-content; }
.max-inline-size { max-inline-size: 100%; }
.constrain-height { max-block-size: var(--max-height, 50vh); }
```

### 16.4 溢出處理

```css
.overflow-x {
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  scroll-behavior: smooth;
}

.overflow-y {
  overflow-y: auto;
  scroll-snap-type: y mandatory;
  scroll-behavior: smooth;
}

.overflow-clip {
  text-overflow: clip;
  white-space: nowrap;
  overflow: hidden;
}

.overflow-ellipsis {
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
}

/* 隱藏捲軸（觸控裝置） */
.overflow-hide-scrollbar::-webkit-scrollbar {
  @media (pointer: coarse) {
    display: none;
  }
}
```

### 16.5 間距工具類

```css
/* 內距 */
.pad { padding: var(--block-space) var(--inline-space); }
.pad-block { padding-block: var(--block-space); }
.pad-block-start { padding-block-start: var(--block-space); }
.pad-block-end { padding-block-end: var(--block-space); }
.pad-block-half { padding-block: var(--block-space-half); }
.pad-inline { padding-inline: var(--inline-space); }
.pad-inline-half { padding-inline: var(--inline-space-half); }
.pad-inline-double { padding-inline: var(--inline-space-double); }
.unpad { padding: 0; }

/* 外距 */
.margin { margin: var(--block-space) var(--inline-space); }
.margin-block { margin-block: var(--block-space); }
.margin-block-half { margin-block: var(--block-space-half); }
.margin-block-double { margin-block: var(--block-space-double); }
.margin-inline { margin-inline: var(--inline-space); }
.margin-inline-half { margin-inline: var(--inline-space-half); }
.margin-none { margin: 0; }

/* 置中 */
.center { margin-inline: auto; }
.center-block { margin-block: auto; }
```

### 16.6 視覺工具類

```css
/* 背景 */
.fill { background-color: var(--color-bg); }
.fill-white { background-color: var(--color-text-reversed); }
.fill-shade { background-color: var(--color-border); }
.fill-transparent { background-color: transparent; }

/* 透明度 */
.translucent { opacity: var(--opacity, 0.5); }

/* 邊框 */
.border {
  border: var(--border-size, 1px) solid var(--border-color, var(--color-border));
}
.border-top {
  border-block-start: var(--border-size, 1px) solid var(--border-color, var(--color-border));
}
.borderless { border: 0; }

/* 圓角 */
.border-radius { border-radius: var(--border-radius, 1em); }

/* 陰影 */
.shadow {
  box-shadow:
    0 0 0 1px oklch(var(--lch-always-black) / 0.02),
    0 .2em 1.6em -0.8em oklch(var(--lch-always-black) / 0.2),
    0 .4em 2.4em -1em oklch(var(--lch-always-black) / 0.3),
    0 .4em .8em -1.2em oklch(var(--lch-always-black) / 0.4);

  @media (prefers-color-scheme: dark) {
    box-shadow:
      0 0 0 1px oklch(var(--lch-always-black) / 0.42),
      0 .2em 1.6em -0.8em oklch(var(--lch-always-black) / 0.6),
      0 .4em 2.4em -1em oklch(var(--lch-always-black) / 0.7);
  }
}
```

### 16.7 可見性工具類

```css
/* 基礎隱藏 */
[hidden] { display: none; }
[contents] { display: contents; }

/* PWA 模式 */
.hide-in-pwa {
  @media (display-mode: standalone) {
    display: none;
  }
}

.hide-in-browser {
  @media (display-mode: browser) {
    display: none;
  }
}

/* iOS PWA 專用 */
.hide-in-ios-pwa {
  @media (display-mode: standalone) {
    @supports (-webkit-touch-callout: none) {
      display: none;
    }
  }
}
```

---

## 17. 列印樣式

### 17.1 列印媒體查詢

```css
@media print {
  /* 全域設定 */
  :root {
    --color-ink: black;
    --color-canvas: white;
    --border-dark: 1px solid var(--color-ink);
    --border-light: 1px solid color-mix(in oklch, var(--color-ink), transparent 75%);
  }

  @page {
    margin: 0.5in;
  }

  html {
    font-size: 10pt;
  }

  main {
    inline-size: unset;
    margin: 0;
    orphans: 3;          /* 最小保留行數（頁面底部） */
    padding: 0;
    widows: 2;           /* 最小保留行數（頁面頂部） */
  }

  /* 確保圖示在列印時可見 */
  .icon, .knob, .switch {
    -webkit-print-color-adjust: exact;
    color-adjust: exact;
    print-color-adjust: exact;
  }

  /* 隱藏互動元素 */
  .nav__menu,
  .nav__trigger,
  .header__actions {
    display: none;
  }
}
```

### 17.2 卡片列印樣式

```css
@media print {
  .card {
    --card-color: var(--color-ink) !important;

    background: var(--color-canvas);
    border: var(--border-light);
    box-shadow: none;
    break-inside: avoid;           /* 避免跨頁斷開 */
    color: var(--color-ink);
  }

  .card__board {
    background: var(--color-canvas);
    border-block-end: var(--border-light);
    border-inline-end: var(--border-light);
    color: var(--color-ink);
  }

  .card__title {
    font-weight: bold;
  }
}
```

### 17.3 隱藏列印不需要的元素

```css
@media print {
  .filters,
  .card--new,
  .cards__decoration,
  .comment--new,
  .delete-card,
  div:has(> .tag-picker__button) {
    display: none;
  }

  .settings__panel {
    border: none;
    border-radius: 0;
    box-shadow: none;
    padding: 0;
  }
}
```

---

## 18. PWA 支援

### 18.1 PWA 安裝樣式

```css
/* 安裝說明（非 PWA 模式顯示） */
.pwa__instructions {
  @media (display-mode: standalone) {
    display: none;
  }
}

/* 安裝按鈕（可安裝時顯示） */
.pwa__installer {
  display: none;

  .pwa--can-install & {
    display: block;
  }
}
```

### 18.2 安全區域處理

```css
.bar {
  /* 處理 iPhone 等裝置的安全區域 */
  block-size: calc(var(--footer-height) + env(safe-area-inset-bottom));
  padding-block:
    var(--block-space)
    calc(var(--block-space) + env(safe-area-inset-bottom));
  padding-inline:
    calc(var(--tray-size) + var(--inline-space) * 3 + env(safe-area-inset-left))
    calc(var(--tray-size) + var(--inline-space) * 3 + env(safe-area-inset-right));
}

.tray {
  inset-block: auto env(safe-area-inset-bottom);
}
```

---

## 19. 無障礙設計

### 19.1 螢幕閱讀器專用

```css
.for-screen-reader {
  block-size: 1px;
  clip-path: inset(50%);
  inline-size: 1px;
  overflow: hidden;
  position: absolute;
  white-space: nowrap;
}
```

### 19.2 焦點樣式

```css
/* 全域焦點環 */
:where(button, input, textarea, summary, .input, .btn) {
  --outline-size: min(0.2em, 2px);

  &:where(:not(:active)):focus-visible {
    outline-width: var(--outline-size);
    outline-color: var(--outline-color, var(--color-link));
    outline-offset: var(--outline-offset, calc(var(--outline-size) * 2));
  }

  /* 按下時移除 offset */
  &:focus:not(:focus-visible) {
    --outline-offset: 0;
  }
}
```

### 19.3 減少動畫

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }

  html {
    scroll-behavior: initial;
  }
}
```

### 19.4 跳過導航連結

```css
.skip-navigation {
  --left-offset: -999em;

  inset-block-start: 4rem;
  inset-inline-start: var(--left-offset);
  position: absolute;
  white-space: nowrap;
  z-index: 11;

  &:focus {
    --left-offset: var(--inline-space);
  }
}
```

---

## 20. CSS 最佳實踐

### 20.1 命名慣例

使用 BEM-like 命名：

```css
/* Block（區塊） */
.card { }

/* Element（元素）- 雙底線 */
.card__header { }
.card__body { }
.card__footer { }

/* Modifier（修飾符）- 雙連字號 */
.card--featured { }
.card--compact { }

/* State（狀態）- 單連字號或 is-/has- 前綴 */
.card.is-active { }
.card.is-collapsed { }
.card.has-error { }
```

### 20.2 使用 CSS 變數進行主題化

```css
/* 好：使用變數，易於覆蓋 */
.btn {
  --btn-background: var(--color-canvas);
  --btn-color: var(--color-ink);

  background-color: var(--btn-background);
  color: var(--btn-color);
}

.btn--primary {
  --btn-background: var(--color-ink);
  --btn-color: var(--color-canvas);
}

/* 避免：直接寫死值 */
.btn-bad {
  background-color: white;
  color: black;
}
```

### 20.3 使用邏輯屬性

```css
/* 好：支援 RTL 語言 */
.card {
  padding-inline: var(--inline-space);
  margin-block-end: var(--block-space);
  border-inline-start: 2px solid;
}

/* 避免：不支援 RTL */
.card-bad {
  padding-left: var(--inline-space);
  padding-right: var(--inline-space);
  margin-bottom: var(--block-space);
  border-left: 2px solid;
}
```

### 20.4 善用現代 CSS 功能

```css
/* color-mix() - 動態混色 */
.card {
  --card-bg: color-mix(in srgb, var(--card-color) 10%, var(--color-canvas));
}

/* :has() - 父元素選擇 */
.form:has(input:invalid) {
  border-color: var(--color-negative);
}

/* :where() - 降低權重 */
:where(.rich-text) h1 {
  font-size: 2em;
}

/* Container Queries - 容器查詢 */
.card-grid {
  container-type: inline-size;
}

@container (min-width: 400px) {
  .card {
    flex-direction: row;
  }
}

/* @starting-style - 進入動畫 */
dialog {
  opacity: 0;

  &[open] {
    opacity: 1;

    @starting-style {
      opacity: 0;
    }
  }
}
```

### 20.5 效能考量

```css
/* 使用 contain 限制重繪範圍 */
.card {
  contain: inline-size;
}

/* 使用 will-change 提示瀏覽器（謹慎使用） */
.sidebar {
  will-change: transform;
}

/* 使用 content-visibility 延遲渲染 */
.long-list-item {
  content-visibility: auto;
  contain-intrinsic-size: 100px;
}
```

### 20.6 組織 CSS 順序

建議的屬性順序：

```css
.component {
  /* 1. 定位 */
  position: absolute;
  inset: 0;
  z-index: 1;

  /* 2. 盒模型 */
  display: flex;
  flex-direction: column;
  gap: var(--space);
  inline-size: 100%;
  padding: var(--space);
  margin: 0;

  /* 3. 排版 */
  font-size: 1rem;
  font-weight: 500;
  line-height: 1.5;
  text-align: center;

  /* 4. 視覺 */
  background-color: var(--bg);
  border: 1px solid var(--border);
  border-radius: 0.5em;
  color: var(--text);

  /* 5. 雜項 */
  cursor: pointer;
  opacity: 1;
  overflow: hidden;
  transition: opacity 150ms ease;
}
```

---

## 結語

本指南涵蓋了 Fizzy 與 Once Campfire 專案中使用的所有 CSS 技術。這些技術代表了現代原生 CSS 的最佳實踐：

1. **CSS 自訂屬性**：建立靈活、可維護的設計系統
2. **邏輯屬性**：支援多語言和 RTL 佈局
3. **現代選擇器**：`:has()`、`:where()`、CSS Nesting
4. **現代色彩**：OKLCH 色彩空間、`color-mix()`
5. **響應式設計**：媒體查詢、容器查詢
6. **動畫**：關鍵影格、View Transitions、`@starting-style`
7. **無障礙**：焦點管理、減少動畫、螢幕閱讀器支援

掌握這些技術後，你就能夠：
- 建立全新的網站專案
- 維護和擴展現有的 Fizzy 和 Once Campfire 樣式
- 遵循一致的設計模式和命名慣例
