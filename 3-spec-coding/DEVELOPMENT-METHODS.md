# 开发方式对比指南

> 本文档对比 3 种 AI 辅助开发方式，帮助你选择合适的工具。

---

## 📊 快速对比

| 方式 | 状态 | 适用场景 | 学习成本 | 自动化程度 |
|------|------|----------|----------|-----------|
| Ralph Wiggum Plugin | ✅ 可用 | 复杂迭代开发 | 中 | ⭐⭐⭐⭐⭐ |
| Ralph for Claude Code | ❌ 不可用 | - | - | - |
| Spec Coding | ✅ 可用 | 规范化项目 | 高 | ⭐⭐⭐ |

---

## 1️⃣ Ralph Wiggum Plugin

### 简介
Claude Code 内置的自迭代插件，通过 `/ralph-loop` 命令自动循环修复和优化代码。

### ✅ 优点
- **完全自动化** - 自动迭代直到任务完成
- **Claude Code 原生** - 无需额外安装
- **错误自愈** - 自动检测错误并修复
- **适合复杂任务** - 多文件重构、功能实现

### ❌ 缺点
- **需要 Claude Code** - 必须在 Claude Code TUI 中使用
- **不可控** - 迭代过程完全自动，难以中途干预
- **消耗 Token** - 多次迭代会消耗大量 API 配额

### 使用方法

```bash
# 在 Claude Code TUI 中
/ralph-loop "任务描述" --completion-promise "COMPLETE" --max-iterations 50
```

### 典型用例
```
/ralph-loop "实现用户登录功能，包含表单验证和错误提示"
/ralph-loop "重构 API 层，使用 React Query 替代 fetch"
/ralph-loop "修复所有 TypeScript 类型错误"
```

### 官方文档
- [GitHub - Ralph Wiggum Plugin](https://github.com/anthropics/claude-code/blob/main/plugins/ralph-wiggum/README.md)

---

## 2️⃣ Ralph for Claude Code

### 简介
Frank Bria 开发的 Claude Code 自动化工具，通过 shell 脚本包装实现后台运行和监控。

- **GitHub:** https://github.com/frankbria/ralph-claude-code

### ❌ 不可用原因：GLM-5 Bug

#### 诊断时间
2025-07-14 12:52 - 13:03

#### 问题根源
GLM-5 模型存在 **多工具调用 bug**：
1. 发起 3+ 个并行工具调用时，进程不退出
2. 发起并行工具调用但不等待所有结果
3. 提前发送 `message_stop` 但管道保持打开

#### 尝试修复
- 修改 `ralph_loop.sh` 添加 GLM-5 兼容性补丁
- 结果：❌ 失败（bug 在进程层，无法在脚本层修复）

#### 结论
**放弃 ralph-claude-code + GLM-5 组合**

### 替代方案
- 使用 Ralph Wiggum Plugin（推荐）
- 使用 Spec Coding 流程
- 手动使用 Claude Code

---

## 3️⃣ Spec Coding（规则驱动开发）

### 简介
基于规格说明的开发流程，先定义需求、方案、任务，再逐步实现。

- **参考：** [智谱 AI - Spec-Kit 最佳实践](https://docs.bigmodel.cn/cn/coding-plan/best-practice/spec-kit)

### ✅ 优点
- **需求明确** - 提前定义用户故事和验收标准
- **方案可控** - 技术方案经过充分讨论
- **任务可追踪** - 拆解成小任务，进度清晰
- **适合团队** - 规格文档可作为团队协作基础
- **减少返工** - 提前发现设计问题

### ❌ 缺点
- **学习成本高** - 需要学习 6 步流程
- **前期投入大** - 需要时间编写规格文档
- **不适合快速原型** - 流程较重

### 六步流水线

```
1. /constitution  → 立规矩（技术栈、代码规范）
2. /specify       → 提需求（用户故事、验收标准）
3. /clarify       → 清疑点（技术细节确认）
4. /plan          → 出方案（架构设计、技术选型）
5. /tasks         → 拆任务（实现步骤、工作量估算）
6. /implement     → 写代码（逐步实现）
```

### 目录结构
```
project/
├── .specify/
│   ├── constitution.md    # 项目规范
│   └── specs/
│       └── 001-feature/
│           ├── spec.md    # 需求规范
│           ├── plan.md    # 技术方案
│           └── tasks.md   # 任务列表
└── spec-template/         # 模板目录（可复用）
```

### 快速开始

```bash
# 使用模板创建新项目
./scripts/create-spec-project.sh my-project

# 或者手动创建
mkdir -p .specify/specs/001-my-feature
cp spec-template/*.md .specify/specs/001-my-feature/
```

### 典型用例
- 新功能开发（Toast 通知、暗黑模式、数据导入导出）
- 大型重构
- 团队协作项目

### 完整文档
- [SPEC-CODING-GUIDE.md](./SPEC-CODING-GUIDE.md)

---

## 🎯 选择建议

### 使用 Ralph Wiggum Plugin 当：
- ✅ 任务明确，不需要大量设计决策
- ✅ 需要快速迭代和错误自愈
- ✅ 复杂多文件重构
- ✅ 你在 Claude Code TUI 中

### 使用 Spec Coding 当：
- ✅ 新功能开发，需求需要梳理
- ✅ 团队协作，需要文档沉淀
- ✅ 项目复杂，需要架构设计
- ✅ 你想控制开发节奏

### 避免 Ralph for Claude Code 当：
- ❌ 使用 GLM-5 模型（存在 bug）
- ⚠️ 使用其他模型时可能可用（未测试）

---

## 📚 相关文档

| 文档 | 说明 |
|------|------|
| [RALPH_GUIDE.md](../vocabulary-app/RALPH_GUIDE.md) | Ralph Wiggum Plugin 使用指南 |
| [RALPH_CONFIG_GUIDE.md](../vocabulary-app/RALPH_CONFIG_GUIDE.md) | Ralph 配置详解 |
| [SPEC-CODING-GUIDE.md](./SPEC-CODING-GUIDE.md) | Spec Coding 完整教程 |
| [MEMORY.md](../MEMORY.md) | 项目长期记忆 |

---

## 🔧 工具链现状（2026-03-08）

### ✅ 可用工具
- **Ralph Wiggum Plugin** - Claude Code 内置，推荐使用
- **Spec Coding 流程** - 已建立模板和脚本
- **Claude Code 手动模式** - 直接对话开发

### ❌ 不可用工具
- **ralph-claude-code + GLM-5** - GLM-5 多工具调用 bug

### ⏳ 待配置
- **Claude 模型（Anthropic API）** - 需要 API key

---

## 💡 最佳实践

### 组合使用

**场景 1：新功能开发**
```
1. 使用 Spec Coding 定义需求和方案
2. 使用 Ralph Wiggum Plugin 实现细节
3. 使用 Spec Coding 文档化结果
```

**场景 2：Bug 修复**
```
1. 使用 Claude Code 手动分析问题
2. 使用 Ralph Wiggum Plugin 自动修复
3. 验证并提交
```

**场景 3：大型重构**
```
1. 使用 Spec Coding 设计重构方案
2. 使用 Ralph Wiggum Plugin 分步实施
3. 使用 Spec Coding 追踪进度
```

---

**文档版本：** 1.0  
**更新时间：** 2026-03-08  
**维护者：** Code Master 🚀
