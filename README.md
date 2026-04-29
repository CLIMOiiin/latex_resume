# LaTeX Resume Template

基于 LaTeX + Markdown 的中文简历模板。内容与样式分离，通过编辑 `content.md` 维护简历内容，脚本自动转换为 LaTeX 片段并编译为 PDF。

![alt text](image.png)

## 概览

| 文件 | 说明 |
|---|---|
| `content.md` | 简历内容源文件（主要维护此文件） |
| `resume.tex` | LaTeX 编译入口，定义整体版式 |
| `sync_resume.sh` | 将 `content.md` 转换为 TeX 片段 |
| `resume.pdf` | 最终输出文件 |

## 环境准备

### 1. 安装 VS Code

下载地址：https://code.visualstudio.com/

### 2. 安装 LaTeX 发行版

本项目使用 XeLaTeX 编译，需要安装完整的 LaTeX 发行版：

- macOS：[MacTeX](https://www.tug.org/mactex/)
- Windows：[TeX Live](https://www.tug.org/texlive/acquire-netinstall.html)（下载 `install-tl-windows.exe`）

验证安装：

```bash
xelatex --version
```

### 3. 安装 VS Code 插件

安装 [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)（插件 ID：`James-Yu.latex-workshop`）。

## VS Code 配置

仓库已内置 `.vscode/settings.json`，包含以下配置：

- 保存时自动触发同步与编译（`onSave`）
- 默认编译链：`Sync Markdown -> XeLaTeX`
- PDF 预览方式：VS Code 标签页
- 编译完成后自动清理中间文件

通常无需手动修改此文件。若将项目迁移至其他目录，需同步携带 `.vscode/settings.json`。

**最小配置参考**（手动新建时可直接使用）：

```json
{
  "latex-workshop.latex.tools": [
    { "name": "sync-md", "command": "./sync_resume.sh", "args": [] },
    {
      "name": "xelatex",
      "command": "xelatex",
      "args": ["-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%DOC%"]
    }
  ],
  "latex-workshop.latex.recipes": [
    { "name": "Sync Markdown -> XeLaTeX", "tools": ["sync-md", "xelatex"] }
  ],
  "latex-workshop.latex.recipe.default": "Sync Markdown -> XeLaTeX",
  "latex-workshop.latex.autoBuild.run": "onSave",
  "latex-workshop.view.pdf.viewer": "tab"
}
```

## 使用流程

### 1. 打开项目

用 VS Code 打开项目根目录（含 `resume.tex` 与 `content.md`）。

### 2. 打开入口文件

在 VS Code 中打开 `resume.tex`。LaTeX Workshop 以此文件作为 `%DOC%` 执行 XeLaTeX。

### 3. 编辑内容

修改 `content.md`。`content_header.tex` 与 `content_body.tex` 为脚本自动生成，不建议直接编辑，否则会在下次同步时被覆盖。

### 4. 构建

**自动构建**：保存 `content.md` 或 `resume.tex` 后自动执行：

1. `./sync_resume.sh` — 将 Markdown 转换为 TeX 片段
2. `xelatex resume.tex` — 编译生成 PDF

**手动构建**：

```bash
zsh sync_resume.sh
xelatex resume.tex
```

或在 VS Code 命令面板执行 `LaTeX Workshop: Build with recipe`。

## 字体

仓库内置两套默认字体，编译时从 `fonts/` 目录加载并嵌入 PDF，无需在系统中单独安装字体。

### 英文字体：Carlito

- `fonts/Carlito-Regular.ttf`
- `fonts/Carlito-Bold.ttf`
- `fonts/Carlito-Italic.ttf`
- `fonts/Carlito-BoldItalic.ttf`

### 中文字体：Noto Sans CJK SC

- `fonts/NotoSansCJKsc-Regular.otf`
- `fonts/NotoSansCJKsc-Bold.otf`

以上字体均采用 SIL Open Font License 1.1（OFL），可用于商业用途。详见 `fonts/FONTS.md`。

## 项目结构

```
.
├── resume.tex            # 编译入口，版式定义
├── content.md            # 简历内容源文件
├── sync_resume.sh        # Markdown → TeX 转换脚本
├── content_header.tex    # 自动生成，页眉片段
├── content_body.tex      # 自动生成，正文片段
├── fonts/                # 内置字体目录
│   ├── Carlito-*.ttf
│   ├── NotoSansCJKsc-*.otf
│   └── FONTS.md
├── logo.png              # 可选，学校或组织 logo
└── photo.jpg             # 可选，个人照片
```

## 内容语法

`content.md` 支持以下标记语法：

| 标记 | 说明 |
|---|---|
| `## 标题` | 章节标题 |
| `- 文本` | 项目符号 |
| `@edu 学校 \| 专业学位 \| 时间 \| 地点` | 教育经历 |
| `@work 公司 \| 岗位 \| 时间 \| 地点` | 工作经历 |
| `@entry 项目名 \| 时间 \| 角色 \| 地点` | 项目经历 |
| `@practice 组织 \| 职位 \| 时间 \| 地点` | 实践经历 |

> 地点字段可为空。

## 常见问题

**保存后未生成 PDF**

按以下顺序排查：

1. 确认 `xelatex --version` 有正常输出
2. 确认已安装 LaTeX Workshop 插件
3. 确认当前 VS Code 打开的是 `resume.tex`
4. 在终端手动执行构建命令，观察错误输出

**编译报字体错误**

确认 `fonts/` 目录中字体文件完整存在。若修改过字体配置，检查 `resume.tex` 中的字体文件名与实际文件名是否完全一致（包括大小写）。
