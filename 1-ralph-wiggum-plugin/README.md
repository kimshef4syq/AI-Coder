# Ralph Wiggum Plugin

> Claude Code 内置的自迭代插件

## 简介

Ralph Wiggum Plugin 是 Claude Code 的官方插件，通过 `/ralph-loop` 命令实现自动迭代开发。

## 特点

- ✅ **完全自动化** - 自动迭代直到任务完成
- ✅ **错误自愈** - 自动检测错误并修复
- ✅ **Claude Code 原生** - 无需额外安装

## 使用方法

```bash
# 在 Claude Code TUI 中
/ralph-loop "任务描述" --completion-promise "COMPLETE" --max-iterations 50
```

## 文件说明

| 文件 | 说明 |
|------|------|
| `ralph-wiggum-plugin-official.md` | 官方文档翻译 |
| `ralph-foreground-guide.md` | 前台运行指南（推荐） |
| `ralph-monitoring-guide.md` | 监控方法 |
| `05-ralph-driven-development.md` | Ralph 驱动开发实践 |

## 官方文档

- [GitHub - Ralph Wiggum Plugin](https://github.com/anthropics/claude-code/blob/main/plugins/ralph-wiggum/README.md)

## 状态

✅ **可用** - 推荐使用

---

**更新时间：** 2026-03-09
