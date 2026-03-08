# AI 辅助编码方式对比

本项目包含 3 种 AI 辅助开发方式的文档和工具。

---

## 📂 目录结构

```
ai-coding-methods/
├── 1-ralph-wiggum-plugin/    # Claude Code 内置自迭代插件
├── 2-ralph-for-claude-code/   # Frank Bria 的 Ralph 工具（GLM-5 不可用）
└── 3-spec-coding/             # 规则驱动开发流程
```

---

## 1️⃣ Ralph Wiggum Plugin

**Claude Code 内置的自迭代插件**

### 文件说明
- `ralph-wiggum-plugin-official.md` - 官方文档翻译
- `ralph-foreground-guide.md` - 前台运行指南
- `ralph-monitoring-guide.md` - 监控方法
- `05-ralph-driven-development.md` - Ralph 驱动开发实践

### 状态
✅ **可用** - 推荐

### 使用方式
```bash
# 在 Claude Code TUI 中
/ralph-loop "任务描述" --completion-promise "COMPLETE"
```

---

## 2️⃣ Ralph for Claude Code

**Frank Bria 开发的自动化工具**

- GitHub: https://github.com/frankbria/ralph-claude-code

### 文件说明
- `RALPH_GUIDE.md` - 使用指南
- `RALPH_CONFIG_GUIDE.md` - 配置详解
- `RALPH-ISSUE-REPORT.md` - 问题报告
- `RALPH-ROOT-CAUSE.md` - 根本原因分析
- `RALPH-WORK-SUMMARY.md` - 工作总结
- `.ralphrc` - 配置示例

### 状态
❌ **不可用** - GLM-5 模型存在多工具调用 bug

### 问题诊断
GLM-5 在处理 3+ 个并行工具调用时：
- 进程不退出
- 提前发送 `message_stop`
- 管道保持打开

**结论：放弃 ralph-claude-code + GLM-5 组合**

---

## 3️⃣ Spec Coding

**规则驱动开发流程**

### 文件说明
- `SPEC-CODING-GUIDE.md` - 完整教程
- `DEVELOPMENT-METHODS.md` - 三种方式对比
- `03-claude-code-sub-agents-spec-driven.md` - 子代理实践
- `create-spec-project.sh` - 快速启动脚本
- `spec-template/` - 模板目录

### 状态
✅ **可用** - 推荐用于规范化项目

### 六步流程
```
1. /constitution  → 立规矩
2. /specify       → 提需求
3. /clarify       → 清疑点
4. /plan          → 出方案
5. /tasks         → 拆任务
6. /implement     → 写代码
```

### 快速开始
```bash
./3-spec-coding/create-spec-project.sh my-project
```

---

## 📊 快速对比

| 方式 | 状态 | 适用场景 | 自动化程度 |
|------|------|----------|-----------|
| Ralph Wiggum Plugin | ✅ 可用 | 复杂迭代开发 | ⭐⭐⭐⭐⭐ |
| Ralph for Claude Code | ❌ 不可用 | - | - |
| Spec Coding | ✅ 可用 | 规范化项目 | ⭐⭐⭐ |

---

## 🎯 选择建议

### 使用 Ralph Wiggum Plugin 当：
- ✅ 任务明确，不需要大量设计决策
- ✅ 需要快速迭代和错误自愈
- ✅ 复杂多文件重构

### 使用 Spec Coding 当：
- ✅ 新功能开发，需求需要梳理
- ✅ 团队协作，需要文档沉淀
- ✅ 项目复杂，需要架构设计

### 避免 Ralph for Claude Code 当：
- ❌ 使用 GLM-5 模型（存在 bug）

---

## 📚 参考链接

- [Ralph Wiggum Plugin 官方文档](https://github.com/anthropics/claude-code/blob/main/plugins/ralph-wiggum/README.md)
- [Ralph for Claude Code GitHub](https://github.com/frankbria/ralph-claude-code)
- [智谱 AI - Spec-Kit 最佳实践](https://docs.bigmodel.cn/cn/coding-plan/best-practice/spec-kit)

---

**创建时间：** 2026-03-09  
**维护者：** Code Master 🚀
