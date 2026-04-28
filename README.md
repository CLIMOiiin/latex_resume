# LaTeX Resume Template

一个基于 LaTeX + Markdown 的中文简历模板项目。

只需要修改 `content.md`，再运行同步脚本，即可自动生成排版内容并编译简历 PDF。

![alt text](image.png)

## 项目结构

- `resume.tex`：主 LaTeX 文件（模板与版式）
- `content.md`：简历内容源文件（推荐只改这里）
- `sync_resume.sh`：将 `content.md` 转换为 TeX 片段
- `content_header.tex`：自动生成，页眉信息
- `content_body.tex`：自动生成，正文内容
- `logo.png`：可选，学校/组织 logo
- `photo.jpg`：可选，个人照片

## 快速开始

### 1) 准备环境

建议使用 XeLaTeX（macOS 可通过 MacTeX 安装）。

### 2) 编辑内容

修改 `content.md` 中的字段：

- `name`
- `contact`
- `profile`
- 各章节条目（教育/实习/项目等）

### 3) 同步内容

```bash
zsh sync_resume.sh
```

执行后会自动更新：

- `content_header.tex`
- `content_body.tex`

### 4) 编译 PDF

```bash
xelatex resume.tex
```

## VS Code 配置（推荐）

本项目已内置 `.vscode/settings.json`，配合 [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) 插件可实现：

- 保存 `content.md` 或 `resume.tex` 时自动触发同步 + 编译
- 在编辑器侧边栏/标签页内预览 PDF
- 自动清理编译中间文件

### 安装插件

在 VS Code 扩展市场搜索并安装：

```
James-Yu.latex-workshop
```

或直接点击：[LaTeX Workshop - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)

### 使用方式

1. 用 VS Code 打开本项目根目录
2. 打开 `resume.tex`，插件会自动识别并在右上角显示编译/预览按钮
3. 编辑 `content.md` 后保存，插件自动执行 `sync_resume.sh` + `xelatex`，完成后在标签页中预览 PDF
4. 也可通过命令面板（`Cmd+Shift+P`）执行 `LaTeX Workshop: Build with recipe` 手动选择编译方案

### 内置 Recipe

| Recipe 名称 | 说明 |
|---|---|
| Sync Markdown -> XeLaTeX（默认） | 先同步 `content.md`，再用 XeLaTeX 编译 |
| XeLaTeX | 仅运行 XeLaTeX |
| PDFLaTeX | 仅运行 PDFLaTeX |
| XeLaTeX x2 | 运行两次 XeLaTeX（用于目录/引用） |

> 中间文件（`.aux`、`.log`、`.synctex.gz` 等）在每次编译后自动清理，无需手动删除。

如需目录更干净，可重复编译 1-2 次以稳定排版。

## 内容语法说明

`content.md` 支持以下标记：

- `## 标题`：章节标题
- `- 文本`：项目符号
- `@edu 学校 | 专业学位 | 时间 | 地点(可空)`
- `@work 公司 | 岗位 | 时间 | 地点(可空)`
- `@entry 项目名 | 时间 | 角色/来源 | 地点(可空)`
- `@practice 组织 | 职位 | 时间 | 地点(可空)`


## 常见问题

1. 字体报错或中文乱码

请确认本机存在模板中的字体（如 PingFang SC），或在 `resume.tex` 中替换为你的系统字体。

2. 内容修改后没有生效

请先执行：

```bash
zsh sync_resume.sh
```

再编译：

```bash
xelatex resume.tex
```
