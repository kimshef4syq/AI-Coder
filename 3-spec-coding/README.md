# Spec Coding - 规则驱动开发

> 基于规格说明的开发流程

## 简介

Spec Coding 是一种"先定义需求，再实现代码"的开发流程，通过 6 个步骤确保需求明确、方案可控、任务可追踪。

## 特点

- ✅ **需求明确** - 提前定义用户故事和验收标准
- ✅ **方案可控** - 技术方案经过充分讨论
- ✅ **任务可追踪** - 拆解成小任务，进度清晰
- ✅ **适合团队** - 规格文档可作为团队协作基础

## 六步流程

```
1. /constitution  → 立规矩（技术栈、代码规范）
2. /specify       → 提需求（用户故事、验收标准）
3. /clarify       → 清疑点（技术细节确认）
4. /plan          → 出方案（架构设计）
5. /tasks         → 拆任务（实现步骤）
6. /implement     → 写代码（逐步实现）
```

## 文件说明

| 文件/目录 | 说明 |
|-----------|------|
| `SPEC-CODING-GUIDE.md` | 完整教程 |
| `DEVELOPMENT-METHODS.md` | 三种方式对比 |
| `03-claude-code-sub-agents-spec-driven.md` | 子代理实践 |
| `create-spec-project.sh` | 快速启动脚本 |
| `spec-template/` | 模板目录 |

## 快速开始

```bash
# 使用脚本创建新项目
./create-spec-project.sh my-project

# 或手动创建
mkdir -p .specify/specs/001-my-feature
cp -r spec-template/.specify ./
```

## 目录结构

```
project/
├── .specify/
│   ├── constitution.md    # 项目规范
│   └── specs/
│       └── 001-feature/
│           ├── spec.md    # 需求规范
│           ├── plan.md    # 技术方案
│           └── tasks.md   # 任务列表
└── spec-template/         # 模板（可复用）
```

## 状态

✅ **可用** - 推荐用于规范化项目

## 参考资源

- [智谱 AI - Spec-Kit 最佳实践](https://docs.bigmodel.cn/cn/coding-plan/best-practice/spec-kit)
- [GitHub - Spec-Kit](https://github.com/github/spec-kit)

---

**更新时间：** 2026-03-09
