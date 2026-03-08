# Ralph 驱动开发（Ralph Wiggum + Ralph Loop）

> 来源：AI超元域 YouTube 频道
> 整理时间：2026-03-06

---

## 🎯 核心概念

**Ralph** 是一个 AI 驱动的**自主迭代开发**机制，主要包含两个层面：

1. **Ralph Wiggum** - Claude Code 的官方插件
2. **Ralph Loop** - OpenClaw 的自主代理执行模式

命名来源于《辛普森一家》角色 Ralph，象征"反复尝试不放弃"。

---

## 1️⃣ Ralph Wiggum（Claude Code 插件）

### 什么是 Ralph Wiggum？

Ralph Wiggum 是 Claude Code 的**官方插件**，将 Claude Code 从单次对话工具转变为**持久执行循环**，允许 Claude 在任务上工作数小时而无需人工干预。

### 核心原理

**Stop Hook 拦截机制：**

当 Claude 尝试退出任务时，插件检查输出是否包含特定 **completion promise**（如 `<promise>COMPLETE</promise>`）：
- ✅ **如果达到标准** → 允许退出
- ❌ **如果未达到标准** → 注入反馈（测试失败日志、Git 历史等），强制 AI 在同一会话中继续迭代

这解决了 AI "半途而废"的问题。

### 安装

```bash
/plugin install ralph-wiggum@claude-plugins-official
```

### 运行示例

```bash
/ralph-loop "为当前项目添加单元测试。
Completion criteria: Tests passing (coverage > 80%) - Output <promise>COMPLETE</promise>" \
  --completion-promise "COMPLETE" \
  --max-iterations 50
```

### 关键参数

| 参数 | 说明 | 建议 |
|------|------|------|
| `--completion-promise` | 退出钥匙（必须与输出中的 promise 匹配）| "COMPLETE" 或 "DONE" |
| `--max-iterations` | 最大迭代次数（防死循环）| 10-50 |

### 两种运行模式

| 模式 | 全称 | 描述 | 适用场景 |
|------|------|------|---------|
| **HITL** | Human-in-the-Loop | 单次运行，人监督干预 | 学习、提示优化 |
| **AFK** | Away From Keyboard | 循环后台运行 | 批量任务，睡前启动全自动开发 |

---

## 2️⃣ Ralph Loop（OpenClaw 自主代理模式）

### 什么是 Ralph Loop？

Ralph Loop 是 OpenClaw 的**自主代理执行模式**，通过持续循环（接收、思考、行动、评估、迭代）实现任务闭环自动化。

### 循环步骤

```
接收任务 → 思考规划 → 执行行动 → 评估结果 → 迭代改进
   ↑                                              ↓
   └────────────── 循环直到完成 ──────────────────┘
```

**具体执行：**
1. **接收任务**：理解用户需求
2. **思考规划**：制定执行计划
3. **执行行动**：联网搜索、浏览器操作、调用 Claude Code 等
4. **评估结果**：检查是否达到完成标准
5. **迭代改进**：根据反馈调整策略

### 配置示例

```bash
openclaw config set ralph.maxIterations 50
openclaw config set ralph.maxRuntime 120  # 分钟
```

支持迭代间暂停以控制 API 成本，并启用进度报告。

---

## 3️⃣ 改进版 Ralph Loop（双层架构）

### 普通版 vs 改进版

**❌ 普通 Ralph Loop：**
```
prompt → 执行 → 失败 → 同样 prompt 重试 → 继续失败
```

**✅ 改进版 Ralph Loop（OpenClaw + Claude Code）：**
```
prompt → 执行 → 失败 → 分析原因 → 重写 prompt → 成功
                    ↓
              记录学习："这种任务需要先给类型定义"
```

### 核心差异

| 对比项 | 普通 Loop | 改进版 Loop |
|--------|-----------|------------|
| **失败处理** | 静态 prompt 重试 | 动态调整 prompt |
| **学习能力** | 无 | 记录成功模式 |
| **上下文持有** | 执行层自己 | 编排层（OpenClaw）|
| **适用场景** | 简单任务 | 复杂业务任务 |

### 为什么 OpenClaw 能做改进版？

因为 OpenClaw 作为编排层持有执行层（Claude Code）没有的上下文：
- 客户在会议里说了什么
- 这家公司是做什么的
- 上次类似需求为什么失败了
- 成功的模式是什么

---

## 4️⃣ 规范驱动开发（Spec Driven Development）

### Ralph Wiggum + Spec Driven

Ralph Wiggum 支持**规范驱动开发**，从 PRD（产品需求文档）生成任务列表，按分支逐一执行：

1. **生成 PRD** → 详细产品需求文档
2. **生成任务列表** → 按特性分支分解（可能 1500+ 任务）
3. **执行** → 实现、测试、审查、合并

### 示例工作流

```bash
# 1. 创建 PRD
/ralph-loop "为电商应用创建 PRD，包含用户管理、商品管理、订单管理功能"

# 2. 生成任务列表
/ralph-loop "基于 PRD 生成详细的任务列表，按特性分支组织"

# 3. 执行开发
/ralph-loop "执行任务列表中的所有任务，每个任务完成后运行测试"
```

---

## 5️⃣ 实战案例

### 案例 1：iOS 背单词 App（20 轮迭代）

- **任务**：对 iOS 背单词 App 进行 20 轮迭代
- **结果**：自动修复 Bug、添加动画、深色模式、进度追踪等
- **耗时**：2 小时完成
- **人工干预**：无需手动调试

### 案例 2：REST API 开发

- **任务**：构建完整 REST API（CRUD、测试、文档）
- **模式**：AFK（睡前启动）
- **结果**：第二天早上完成

### 案例 3：React Native 习惯追踪器

- **结果**：AI "吐出完整 APP"
- **功能**：完整的前后端

---

## 6️⃣ 高级用法

### 多重角色审查

引入**多重角色**（如项目经理、QA、架构师）审查代码：

```bash
/ralph-loop "开发用户认证功能。
完成后依次调用：
1. @pm-reviewer 审查产品需求
2. @qa-reviewer 审查测试覆盖
3. @architect-reviewer 审查架构设计
Completion: 所有审查通过"
```

### 多 Agent 协作模式

OpenClaw 支持多种协作模式：
- **线性流水线**：任务 A → 任务 B → 任务 C
- **并行依赖图**：多个任务同时进行
- **AI 辩论模式**：多个 AI 讨论后决策

---

## 7️⃣ 优势与风险

### ✅ 优势

| 优势 | 说明 |
|------|------|
| **自主迭代** | AI 自动处理编写、测试、调试、优化 |
| **无需干预** | 长时间运行，人可以离开 |
| **失败即反馈** | 每次迭代提供上下文帮助 AI 改进 |
| **回合制开发** | 修改 → 验证 → 反馈，清晰可追踪 |

### ⚠️ 风险与注意事项

| 风险 | 说明 | 建议 |
|------|------|------|
| **Token 消耗高** | 一晚上可能消耗百美元 | 设置迭代上限（10-50）|
| **死循环** | AI 可能陷入无限循环 | 必须设置 `--max-iterations` |
| **方向偏离** | AI 可能走偏 | 定期检查，提供清晰完成标准 |

---

## 8️⃣ 与其他方案的关系

### Ralph Wiggum vs Hooks 零轮询

| 对比项 | Ralph Wiggum | Hooks 零轮询 |
|--------|-------------|-------------|
| **定位** | Claude Code 插件 | OpenClaw 架构层 |
| **触发机制** | Stop Hook 拦截退出 | Stop Hook + SessionEnd 回调 |
| **循环控制** | Claude Code 内部循环 | OpenClaw 外部调度 |
| **适用场景** | 单个复杂任务 | 多任务并行 |

### 配合使用

可以组合使用：
1. **OpenClaw** 作为编排层，持有业务上下文
2. **Claude Code + Ralph Wiggum** 作为执行层，处理单个复杂任务
3. **Hooks** 实现零轮询通知

---

## 9️⃣ 最佳实践建议

### 1. 明确完成标准

```bash
# ✅ 好
/ralph-loop "添加单元测试。Completion: Tests passing (coverage > 80%) - Output <promise>COMPLETE</promise>"

# ❌ 不好
/ralph-loop "添加单元测试"  # 没有明确的完成标准
```

### 2. 设置合理的迭代上限

- **简单任务**：10-20 次
- **中等任务**：20-50 次
- **复杂任务**：50-100 次（需要监控）

### 3. 使用 AFK 模式前的准备

- 确保有明确的完成标准
- 设置 `--max-iterations` 防止死循环
- 预估 Token 成本（准备好预算）
- 第二天早上检查结果

### 4. 模型选择策略

- **迭代阶段**：用便宜模型（如 GPT-4o-mini）
- **深度推理**：用贵模型（如 Claude Opus）
- **审查阶段**：用中等模型（如 Claude Sonnet）

---

## 🔗 关键资源

- **Claude Code 插件市场**：`/plugin install ralph-wiggum@claude-plugins-official`
- **作者开源项目**：https://github.com/win4r/AISuperDomain
- **作者微信**：stoeng
- **请作者喝咖啡**：https://ko-fi.com/aila

---

## 📊 总结对比表

| 方案 | 自主性 | 复杂度 | Token 消耗 | 适用场景 |
|------|--------|--------|-----------|---------|
| **Ralph Wiggum（HITL）** | ⭐⭐ | ⭐⭐ | ⭐⭐ | 学习、提示优化 |
| **Ralph Wiggum（AFK）** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | 批量任务、复杂开发 |
| **Ralph Loop（OpenClaw）** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | 多任务编排 |
| **改进版 Ralph Loop** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | 复杂业务任务 |
| **Hooks 零轮询** | ⭐⭐⭐ | ⭐⭐ | ⭐ | 长时间运行、多任务并行 |
