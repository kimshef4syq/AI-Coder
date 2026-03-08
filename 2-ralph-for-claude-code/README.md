# Ralph for Claude Code

> Frank Bria 开发的 Claude Code 自动化工具

## 简介

Ralph for Claude Code 是一个通过 shell 脚本包装 Claude Code 的自动化工具，支持后台运行和监控。

- **GitHub:** https://github.com/frankbria/ralph-claude-code

## 状态

❌ **不可用** - GLM-5 模型存在 bug

## 问题诊断

### 诊断时间
2025-07-14 12:52 - 13:03

### 问题根源
GLM-5 模型存在 **多工具调用 bug**：
1. 发起 3+ 个并行工具调用时，进程不退出
2. 发起并行工具调用但不等待所有结果
3. 提前发送 `message_stop` 但管道保持打开

### 尝试修复
- 修改 `ralph_loop.sh` 添加 GLM-5 兼容性补丁
- 结果：❌ 失败（bug 在进程层，无法在脚本层修复）

### 结论
**放弃 ralph-claude-code + GLM-5 组合**

## 文件说明

| 文件 | 说明 |
|------|------|
| `RALPH_GUIDE.md` | 使用指南 |
| `RALPH_CONFIG_GUIDE.md` | 配置详解 |
| `RALPH-ISSUE-REPORT.md` | 问题报告 |
| `RALPH-ROOT-CAUSE.md` | 根本原因分析 |
| `RALPH-WORK-SUMMARY.md` | 工作总结 |
| `.ralphrc` | 配置示例 |

## 替代方案

- ✅ 使用 Ralph Wiggum Plugin（推荐）
- ✅ 使用 Spec Coding 流程
- ✅ 手动使用 Claude Code

---

**更新时间：** 2026-03-09
