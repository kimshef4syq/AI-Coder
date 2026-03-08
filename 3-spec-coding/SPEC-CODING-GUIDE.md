# Spec Coding 规则驱动开发 - 完整指南

> **基于 Spec-Kit 的 AI 时代软件工程最佳实践**

---

## 📚 文档导航

### 核心文档
- **快速开始**：`spec-template/README.md`
- **流程说明**：`vocabulary-app/.specify/README.md`
- **项目宪法示例**：`vocabulary-app/.specify/constitution.md`

### 模板文件
- **宪法模板**：`spec-template/.specify/constitution.template.md`
- **需求规范模板**：`spec-template/.specify/specs/spec.template.md`
- **技术方案模板**：`spec-template/.specify/plans/plan.template.md`
- **任务列表模板**：`spec-template/.specify/plans/tasks.template.md`

### 实际案例
- **Toast 功能**：`vocabulary-app/.specify/specs/001-toast-notification/`
- **技术方案**：`vocabulary-app/.specify/plans/001-toast-notification/`

---

## 🎯 核心理念

```
传统开发：规格(文档) → 代码(瞎写) → 代码是真理
Spec Coding：规格(可执行) → 计划 → 任务 → 代码 → 规格是真理
```

**代码为规格服务，而不是规格为代码服务！**

---

## 🔄 六步流水线

| 步骤 | 命令 | 输出文件 | 作用 |
|------|------|----------|------|
| 1️⃣ | `/constitution` | `constitution.md` | 立规矩（技术栈、规范、约束） |
| 2️⃣ | `/specify` | `specs/XXX/spec.md` | 提需求（用户故事、验收标准） |
| 3️⃣ | `/clarify` | 更新 `spec.md` | 清疑点（AI 反问澄清） |
| 4️⃣ | `/plan` | `plans/XXX/plan.md` | 出方案（技术架构、实现细节） |
| 5️⃣ | `/tasks` | `plans/XXX/tasks.md` | 拆任务（可执行的子任务） |
| 6️⃣ | `/implement` | 执行编码 | 写代码（按任务列表执行） |

---

## 🚀 快速开始

### 新建项目

```bash
# 方法 1: 使用脚本（推荐）
cd ~/Documents/07-skill-prompt/01-cluade-skills/coding-workspace
./scripts/create-spec-project.sh my-new-project

# 方法 2: 手动复制
cp -r spec-template/ my-new-project/
cd my-new-project
# 重命名模板文件
```

### 现有项目

```bash
# 在项目根目录创建 .specify
mkdir -p .specify/specs .specify/plans .specify/contracts

# 复制模板
cp ../spec-template/.specify/constitution.template.md .specify/constitution.md

# 编辑 constitution.md
```

---

## 📁 目录结构

```
project-root/
├── .specify/
│   ├── constitution.md          # 项目宪法（必填）
│   ├── README.md                # 流程说明（可选）
│   ├── specs/                   # 需求规范
│   │   ├── 001-first-feature/
│   │   │   └── spec.md
│   │   ├── 002-second-feature/
│   │   │   └── spec.md
│   │   └── ...
│   ├── plans/                   # 技术方案
│   │   ├── 001-first-feature/
│   │   │   ├── plan.md          # 技术方案
│   │   │   └── tasks.md         # 任务列表
│   │   ├── 002-second-feature/
│   │   │   ├── plan.md
│   │   │   └── tasks.md
│   │   └── ...
│   └── contracts/               # API/组件接口（可选）
│       └── api.md
├── src/                         # 源代码
├── docs/                        # 项目文档
└── README.md
```

---

## 📝 文档模板

### constitution.md 核心内容

```markdown
# 项目宪法

## 🎯 项目定位
[项目描述和核心价值]

## 🛠 技术栈
- 前端框架
- 路由 & 状态
- UI & 样式
- 后端服务

## 📏 代码规范
- 组件风格
- 文件命名
- 样式规范

## 🎨 设计规范
- 色彩体系
- 字体
- 动效

## ✅ 质量要求
- 功能测试
- 代码审查
- 文档

## 🚫 约束 & 禁止
[技术禁止项和设计禁止项]
```

### spec.md 核心内容

```markdown
# Spec: [功能名称]

## 📝 需求描述
- 用户故事
- 核心功能

## ✅ 验收标准
- 功能验收
- 视觉验收
- 技术验收

## 🔍 边界条件
- 正常流程
- 异常处理

## 🎯 优先级
- P0（必须有）
- P1（应该有）
- P2（可以有）
```

### plan.md 核心内容

```markdown
# Plan: [功能名称]

## 🏗️ 技术架构
- 状态管理
- 组件结构

## 📦 组件结构
[目录结构]

## 🎨 UI 设计
- 布局
- 样式
- 动画

## 🔧 实现细节
[关键代码片段]

## 🔗 集成点
[在哪些地方使用]

## 📊 风险评估
[潜在问题和缓解措施]
```

### tasks.md 核心内容

```markdown
# Tasks: [功能名称]

## Phase 1: [阶段名称]
- [ ] T001: [任务描述]
  - 文件：[路径]
  - 预计时间：[时间]

- [ ] T002: [任务描述]
  - 文件：[路径]
  - 预计时间：[时间]

## 进度统计
- 总任务数：X
- 预计总时间：X小时
- 当前进度：0%
```

---

## 🎯 最佳实践

### 项目命名
- ✅ 使用小写 + 连字符：`my-project`
- ❌ 避免空格和特殊字符

### 功能命名
- ✅ 简洁明了：`user-auth`, `toast-notification`
- ✅ 使用英文连字符
- ✅ 版本号递增：`001`, `002`

### 任务编号
- ✅ 全局递增：`T001`, `T002`
- ✅ 或按功能：`AUTH-001`, `UI-001`

### 需求变更
1. 回到 `/specify` 创建新版本
2. 走完整流程（spec → plan → tasks → implement）
3. 保留历史版本

### Bug 修复
1. 小规模 spec（描述问题）
2. 简化流程：spec → task → fix
3. 记录到文档

---

## 🛠️ 工具支持

### Claude Code
- 直接给它 `tasks.md` 文件
- 让它按任务列表执行

### Ralph Wiggum Plugin
- 运行 `/ralph-loop`
- 自动执行所有任务

### 手动执行
- 逐个任务完成
- 打勾 `[x]` 跟踪进度

---

## 📊 实际案例：Toast 通知系统

### 创建时间
2025-07-14

### 文件位置
```
vocabulary-app/.specify/
├── constitution.md
├── specs/001-toast-notification/spec.md
└── plans/001-toast-notification/
    ├── plan.md
    └── tasks.md
```

### 任务进度
- **总任务数：** 10
- **预计时间：** 3小时40分钟
- **状态：** 待执行

### 技术栈
- React Context + useReducer
- TailwindCSS 样式
- 赛博朋克风格

---

## 🔗 参考资料

### 官方文档
- [Spec-Kit GitHub](https://github.com/github/spec-kit)
- [智谱 AI 最佳实践](https://docs.bigmodel.cn/cn/coding-plan/best-practice/spec-kit)

### 相关文章
- [Spec Coding 保姆级教程](https://mp.weixin.qq.com/s/CRH4WWtrA_3APBBFD1zMiQ)
- [Vibe Coding 已死，Spec Coding 当立](https://docs.bigmodel.cn/cn/coding-plan/best-practice/spec-kit)

---

## 💡 常见问题

### Q: Spec-Kit 会不会增加工作量？
A: 上手有学习成本，但中大型项目长期来看大大提升效率。小 demo 可以直接用 AI 助手。

### Q: 能在老项目里用吗？
A: 可以。在项目根目录创建 `.specify/`，从新功能开始试用。

### Q: 需求变了怎么办？
A: 回到 `/specify` 创建新版本，保留历史版本，再走一遍流程。

### Q: 支持哪些 AI 工具？
A: 几乎所有主流 AI 编程工具：Claude Code, GitHub Copilot, Gemini, Cursor, 通义千问等。

---

## 🎉 总结

**Spec Coding 的核心价值：**
1. 高质量、可预测的输出
2. 自动化文档生成
3. 团队协作效率飙升
4. 沉淀团队最佳实践
5. 真正的"AI工程师"伙伴

**从 Vibe Coding 到 Spec Coding，告别反复拉扯，拥抱确定性开发！**

---

**更新时间：** 2025-07-14
**维护者：** Code Master + 蛇哥

---

> **"先想清楚再动手，让规格成为唯一真理"**
