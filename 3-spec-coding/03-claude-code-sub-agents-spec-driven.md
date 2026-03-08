# Claude Code Sub Agents + Spec-Driven 开发

> 来源：AI超元域 YouTube 频道
> 视频：https://www.youtube.com/watch?v=GjlkRcNNONo
> 笔记：https://www.aivi.fyi/aiagents/introduce-Sub-agents

---

## 什么是 Sub Agents？

Sub Agents 本质上是预配置的专业 AI 助手，它们能够被 Claude Code 主系统委托处理特定类型的任务。

每个 Sub Agent 都拥有：
- 独立的上下文窗口
- 定制化的系统提示词
- 特定的工具访问权限

**核心理念：术业有专攻**

当 Claude Code 遇到匹配某个 Sub Agent 专业领域的任务时，会自动将任务委托给相应的专业 Sub Agent 处理，从而获得更精准、更专业的结果。

---

## 核心优势

### 1. 上下文保护

每个 Sub Agent 在独立的上下文环境中运行，避免了主对话被任务细节污染，使主线程能够专注于高层次的目标规划。

### 2. 专业化程度提升

Sub Agents 可以针对特定领域进行深度定制，包含详细的专业指令和约束条件，这使得它们在指定任务上的成功率显著提高。

**例子：**
- **代码审查 Sub Agent**：专门关注代码质量、安全性和最佳实践
- **数据科学 Sub Agent**：专注于数据处理和分析工作流

### 3. 可重用性和灵活权限管理

一旦创建，Sub Agents 可以在不同项目间复用，团队成员可以共享这些专业助手，确保工作流程的一致性。

同时，每个 Sub Agent 都可以配置不同的工具访问级别，管理员可以根据需要限制强大工具的使用范围。

---

## 技术实现与配置

### 文件系统架构

Sub Agents 以 Markdown 文件形式存储，包含 YAML 前置元数据，可以部署在：

- **项目级别**：`.claude/agents/`（优先级更高）
- **用户级别**：`~/.claude/agents/`

### 配置内容

每个 Sub Agent 需要定义：
- **名称**：唯一标识符
- **描述**：用于自动任务委托的匹配
- **工具列表**（可选）：控制 Sub Agent 的能力边界
- **MCP 工具**（可选）：扩展功能的可能性

---

## 核心 Sub Agents 示例

### 1. 代码审查专家

```yaml
---
name: code-reviewer
description: 专业代码审查专家。主动审查代码质量、安全性和可维护性。在编写或修改代码后必须立即使用。擅长代码质量评估、安全漏洞检测、性能优化建议和最佳实践推荐。
tools: file_search, bash, file_edit
---
```

**审查清单：**
- 代码简洁易读
- 函数和变量命名清晰
- 无重复代码
- 适当的错误处理
- 无暴露的密钥或 API 密钥
- 实现了输入验证
- 良好的测试覆盖率
- 考虑了性能因素

**反馈组织：**
- 严重问题（必须修复）
- 警告问题（应该修复）
- 建议改进（考虑改进）

### 2. 调试专家

```yaml
---
name: debugger
description: 错误调试和问题排查专家。专门处理程序错误、测试失败和异常行为。当遇到任何技术问题、代码报错、功能异常或需要问题排查时必须主动使用。擅长根因分析、错误定位、Bug 修复和系统诊断。
tools: file_search, file_edit, bash
---
```

**调试流程：**
- 分析错误信息和日志
- 检查最近的代码更改
- 形成并测试假设
- 添加策略性调试日志
- 检查变量状态

**输出要求：**
- 根本原因解释
- 支持诊断的证据
- 具体的代码修复
- 测试方法
- 预防建议

### 3. 数据科学家

```yaml
---
name: data-scientist
description: 数据分析和数据科学专家。专门处理 SQL 查询、BigQuery 操作和数据洞察分析。当需要数据分析、数据库查询、数据挖掘、统计分析、数据可视化或数据驱动决策时必须主动使用。擅长 SQL 优化、数据建模、统计分析和商业智能。
tools: bash, file_search, file_edit
---
```

**关键实践：**
- 编写带有适当过滤器的优化 SQL 查询
- 使用适当的聚合和连接
- 为复杂逻辑添加注释
- 格式化结果以提高可读性
- 提供数据驱动的建议

### 4. PRD 文档生成专家

```yaml
---
name: prd-writer
description: 专业的产品需求文档(PRD)生成专家和产品经理助手。当用户需要生成 PRD 文档、产品需求文档、产品规格书、功能需求分析、产品设计文档、需求整合、产品规划或编写用户故事时必须优先使用。擅长结构化需求分析、用户故事编写、功能规格定义和产品文档标准化。
tools: file_edit, web_search, file_search
---
```

**标准 PRD 文档结构：**
1. **产品概述**：产品背景与目标、目标用户群体、核心价值主张、成功指标定义
2. **功能需求**：用户故事、验收标准、优先级、依赖关系
3. **非功能需求**：性能要求、安全要求、兼容性要求
4. **技术方案**：系统架构概述、关键技术选型、数据模型设计、API 接口规范
5. **用户体验设计**：用户旅程地图、关键页面流程、交互原型描述、UI 规范要求
6. **实施计划**：开发里程碑、资源需求评估、风险识别与应对、测试验收计划

---

## Kiro 的 Spec-Driven 开发（规范驱动开发）

### 核心理念

引入一种结构化的、规范驱动的"计划与执行"（Plan & Execute）开发模式，以取代随意的"氛围编程"（vibe coding）。

**目标：** 引导 AI 生成文档完善、易于维护且达到生产标准的代码。

---

## 两阶段工作流

### 阶段 1：规划阶段（Planning Phase）

**AI 角色：** 初级架构师（Junior Architect）

**任务：**
- 开发者提供一个高层级的功能描述（例如"添加用户认证功能"）
- AI 通过一个交互式的问答流程，引导开发者创建一套完整的技术规范
- 规范包括：需求、设计和任务拆解

### 阶段 2：执行阶段（Execution Phase）

**AI 角色：** 细致的工程师（Meticulous Engineer）

**任务：**
- AI 读取并严格遵守在规划阶段批准的技术规范
- 一次执行一个任务，逐步完成功能的代码实现

---

## 项目结构与工件

```
.
├── .ai-rules/              # 工具无关的全局上下文
│   ├── product.md         # 项目愿景和目标（"为什么"）
│   ├── tech.md            # 技术栈和工具（"用什么"）
│   └── structure.md       # 文件结构和约定（"在哪里"）
└── specs/                 # 功能特定的规范
    └── your-feature-name/
        ├── requirements.md # 用户故事和验收标准（"什么"）
        ├── design.md      # 技术架构（"如何"）
        └── tasks.md       # 逐步实现计划（"待办"）
```

---

## 三个核心 Spec-Driven Sub Agents

### 1. Steering Architect（项目分析师和文档架构师）

**职责：** 分析现有代码库并创建项目核心指导文件（`.ai-rules/`）

**工作流：**

1. **深度代码库分析**
   - 分析技术栈（`tech.md`）
   - 分析项目结构（`structure.md`）
   - 分析产品愿景（`product.md`）

2. **创建初始指导文件**
   - `.ai-rules/product.md`
   - `.ai-rules/tech.md`
   - `.ai-rules/structure.md`

3. **交互式优化**
   - 向用户展示创建的文件
   - 询问缺失的信息
   - 根据反馈修改

### 2. Strategic Planner（专家级软件架构师和协作规划师）

**职责：** 功能需求分析、技术设计和任务规划

**规则：**
- **PLANNING MODE: Q&A ONLY — ABSOLUTELY NO CODE, NO FILE CHANGES.**
- 只做规划设计，绝对不编写代码
- 例外：允许创建或修改 `requirements.md`、`design.md`、`tasks.md`

**三阶段工作流：**

**Phase 1: Requirements Definition**
- 询问功能名称（kebab-case）
- 生成 `requirements.md` 草案
- 交互式优化直到用户满意

**Phase 2: Technical Design**
- 基于批准的需求生成 `design.md`
- 识别并展示架构选择
- 交互式优化直到用户满意

**Phase 3: Task Generation**
- 生成 `tasks.md`，包含详细的任务清单
- 确保任务按合理顺序排列
- 所有依赖任务先于依赖它的任务

### 3. Task Executor（AI 软件工程师）

**职责：** 专注于执行单个具体任务，具有外科手术般的精确度

**规则：**
- EXECUTOR MODE — ONE TASK AT A TIME
- 每个运行只执行一个任务
- 严格限制变更范围，不合并、不预期未来步骤

**工作流：**

1. **识别任务**：打开 `specs/<feature>/tasks.md`，找到第一个未勾选的任务
2. **理解任务**：读取任务描述，参考 `design.md` 和 `requirements.md`
3. **实现变更**：严格只实现当前任务描述的内容
4. **验证变更**：根据任务的验收标准验证
5. **反思学习**：记录项目级的通用经验（不只是实现细节）
6. **更新状态并报告**：
   - 如果是自动化测试通过：标记任务为 `[x]`
   - 如果是手动测试或无测试：不标记，询问用户审核

---

## 使用方式

```bash
# 1. 项目分析和初始化
"@steering-architect 分析现有代码库并创建项目指导文件"

# 2. 功能规划
"@strategic-planner 规划用户认证功能"
# 输出: specs/user-authentication/requirements.md, design.md, tasks.md

# 3. 逐步实现
"@task-executor 执行 specs/user-authentication/tasks.md 中的任务"
# 重复直到所有任务完成

# 4. 新功能继续
"@strategic-planner 规划支付系统功能"
"@task-executor 执行 specs/payment-system/tasks.md 中的任务"
```

---

## 关键资源

- 作者开源项目：https://github.com/win4r/AISuperDomain
- 作者微信：stoeng
- 请作者喝咖啡：https://ko-fi.com/aila
