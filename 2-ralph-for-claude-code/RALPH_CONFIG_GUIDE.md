# Ralph 配置详解

## 📁 文件结构

```
vocabulary-app/
├── .ralph/                    # Ralph 配置目录（隐藏）
│   ├── PROMPT.md             # 主要开发指令（给 Claude 的任务说明）
│   ├── fix_plan.md           # 任务列表（Ralph 会按优先级执行）
│   ├── AGENT.md              # 构建/测试/运行指令
│   ├── logs/                 # 执行日志
│   │   └── ralph.log         # 主要日志文件
│   ├── specs/                # 详细规范（可选）
│   ├── examples/             # 示例文件（可选）
│   └── docs/                 # 文档（可选）
├── .ralphrc                  # 项目配置（Rate Limit、工具权限等）
└── src/                      # 你的源代码
```

---

## ⚙️ .ralphrc 配置文件详解

### 1. 项目信息

```bash
PROJECT_NAME="temp-vite"      # 项目名称
PROJECT_TYPE="typescript"     # 项目类型：typescript, python, rust, go
```

**作用：**
- 帮助 Ralph 理解项目上下文
- 自动选择合适的构建命令

---

### 2. Claude Code 命令

```bash
CLAUDE_CODE_CMD="claude"      # 默认：全局安装的 claude

# 其他选项：
# CLAUDE_CODE_CMD="npx @anthropic-ai/claude-code"  # 使用 npx
# CLAUDE_CODE_CMD="/usr/local/bin/claude"          # 自定义路径
```

**如何选择：**
- ✅ 全局安装 → `"claude"`
- ✅ npx 运行 → `"npx @anthropic-ai/claude-code"`
- ✅ 自定义路径 → `"/path/to/claude"`

---

### 3. 循环设置

```bash
MAX_CALLS_PER_HOUR=100         # 每小时最大 API 调用次数
CLAUDE_TIMEOUT_MINUTES=15      # Claude Code 执行超时（分钟）
CLAUDE_OUTPUT_FORMAT="json"    # 输出格式：json 或 text
```

**调优建议：**

| 场景 | MAX_CALLS | TIMEOUT | 说明 |
|------|-----------|---------|------|
| **保守** | 50 | 10 | 节省 API 调用 |
| **标准** | 100 | 15 | 默认，平衡 |
| **激进** | 200 | 30 | 快速迭代 |

**启动时覆盖：**
```bash
ralph --monitor --calls 50 --timeout 30
```

---

### 4. 工具权限

```bash
ALLOWED_TOOLS="Write,Read,Edit,Bash(git add *),Bash(git commit *),..."
```

**已允许的工具：**
- ✅ `Write` - 写入文件
- ✅ `Read` - 读取文件
- ✅ `Edit` - 编辑文件
- ✅ `Bash(git add *)` - Git 添加
- ✅ `Bash(git commit *)` - Git 提交
- ✅ `Bash(npm *)` - npm 命令
- ✅ `Bash(pytest)` - Python 测试

**安全说明：**
- ❌ **不包含** `Bash(git clean)` - 危险！会删除未跟踪文件
- ❌ **不包含** `Bash(git rm *)` - 危险！会删除文件
- ✅ 只包含安全的 Git 子命令

**如何添加新权限：**
```bash
# 例如：允许 pnpm
ALLOWED_TOOLS="...,Bash(pnpm *)"

# 例如：允许所有 Python 命令
ALLOWED_TOOLS="...,Bash(python *)"
```

---

### 5. Session 管理

```bash
SESSION_CONTINUITY=true        # 保持会话上下文（推荐）
SESSION_EXPIRY_HOURS=24        # 会话过期时间（小时）
```

**工作原理：**
- ✅ `true` - Ralph 会在循环间保持上下文，更连贯
- ❌ `false` - 每次循环都是独立的，可能丢失上下文

**何时重置会话：**
```bash
# 手动重置
ralph --reset-session

# 自动触发：
# - 24 小时后过期
# - Circuit Breaker 打开
# - 手动中断（Ctrl+C）
```

---

### 6. Circuit Breaker（熔断器）

```bash
CB_NO_PROGRESS_THRESHOLD=3     # 3 次无进展 → 打开熔断器
CB_SAME_ERROR_THRESHOLD=5      # 5 次相同错误 → 打开熔断器
CB_OUTPUT_DECLINE_THRESHOLD=70 # 输出下降 70% → 打开熔断器
```

**熔断器状态：**
- **CLOSED** - 正常运行
- **OPEN** - 停止执行（检测到问题）
- **HALF_OPEN** - 尝试恢复

**自动恢复：**
- 等待 30 分钟 → HALF_OPEN
- 下次成功 → CLOSED
- 下次失败 → OPEN（继续等待）

**手动控制：**
```bash
# 查看状态
ralph --circuit-status

# 重置熔断器
ralph --reset-circuit

# 启动时自动重置
ralph --auto-reset-circuit
```

---

## 📝 PROMPT.md 详解

### 核心结构

```markdown
# Ralph Development Instructions

## Context
- 项目信息
- 技术栈

## Current Objectives
- 当前目标
- 遵循 fix_plan.md

## Key Principles
- 一次一个任务
- 写测试
- 更新文档

## Protected Files
- .ralph/ 目录
- .ralphrc 文件

## Status Reporting
- 必须包含 RALPH_STATUS 块
```

### 关键部分

**1. Protected Files（受保护文件）**
```markdown
## Protected Files (DO NOT MODIFY)
- .ralph/ (entire directory)
- .ralphrc

原因：这些是 Ralph 的控制文件，删除会破坏 Ralph
```

**2. Status Reporting（状态报告）**
```markdown
---RALPH_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING | FAILING | NOT_RUN
WORK_TYPE: IMPLEMENTATION | TESTING | DOCUMENTATION
EXIT_SIGNAL: false | true
RECOMMENDATION: 下一步建议
---END_RALPH_STATUS---
```

**退出检测逻辑：**
```python
if completion_indicators >= 2 AND EXIT_SIGNAL == true:
    exit("project_complete")
else:
    continue()
```

---

## 📋 fix_plan.md 详解

### 任务优先级

```markdown
## 🔥 High Priority（本周完成）
- [ ] 任务 1
- [ ] 任务 2

## 📊 Medium Priority（本月完成）
- [ ] 任务 3

## 🚀 Low Priority（后续优化）
- [ ] 任务 4

## ✅ Completed（已完成）
- [x] 已完成任务
```

### Ralph 的执行逻辑

```
1. 读取 fix_plan.md
2. 找到第一个未完成的 [ ] 任务
3. 从 High → Medium → Low 优先级
4. 执行任务
5. 成功后标记 [x]
6. 移动到 Completed
7. 继续下一个任务
```

### 如何编写好的任务

**❌ 模糊的任务：**
```markdown
- [ ] 优化代码
- [ ] 改进 UI
```

**✅ 清晰的任务：**
```markdown
- [ ] 优化移动端响应式布局（375px - 768px）
- [ ] 添加加载状态动画（骨架屏）
- [ ] 实现单词标签分类系统
```

**任务模板：**
```markdown
- [ ] <动词> <对象> <细节> (<优先级>)

例如：
- [ ] 添加 音标发音功能 (Web Speech API)
- [ ] 实现 标签分类系统 (数据库 + UI)
- [ ] 优化 移动端布局 (375px 断点)
```

---

## 🔧 AGENT.md 详解

### 标准模板

```markdown
# Ralph Agent Configuration

## Build Instructions
\`\`\`bash
pnpm build
\`\`\`

## Test Instructions
\`\`\`bash
pnpm test
\`\`\`

## Run Instructions
\`\`\`bash
pnpm start
\`\`\`

## Notes
- 环境变量设置
- 依赖说明
- 特殊配置
```

**作用：**
- 告诉 Ralph 如何构建/测试/运行项目
- 自动检测项目类型并生成
- 可以手动编辑调整

---

## 🚀 启动选项详解

### 基础选项

```bash
ralph                    # 基础启动
ralph --monitor          # tmux 集成监控（推荐）
ralph --help             # 查看帮助
ralph --status           # 查看当前状态
```

### 监控选项

```bash
ralph --live             # 实时输出 Claude Code
ralph --verbose          # 详细进度信息
ralph --monitor --live   # 集成监控 + 实时输出
```

### 控制选项

```bash
ralph --calls 50                # 限制每小时 50 次调用
ralph --timeout 30              # 30 分钟超时
ralph --reset-session           # 重置会话
ralph --reset-circuit           # 重置熔断器
ralph --auto-reset-circuit      # 启动时自动重置熔断器
```

### 输出选项

```bash
ralph --output-format json      # JSON 输出（默认）
ralph --output-format text      # 文本输出
```

---

## 📊 日志系统

### 日志文件

```bash
.ralph/logs/
├── ralph.log              # 主日志
├── ralph_error.log        # 错误日志
├── circuit_breaker.log    # 熔断器日志
└── session_history.log    # 会话历史
```

### 查看日志

```bash
# 实时查看
tail -f .ralph/logs/ralph.log

# 查看最近 100 行
tail -100 .ralph/logs/ralph.log

# 搜索错误
grep "ERROR" .ralph/logs/ralph.log

# 查看今天的日志
grep "$(date +%Y-%m-%d)" .ralph/logs/ralph.log
```

---

## 🛡️ 安全机制

### 1. Rate Limiting

```bash
MAX_CALLS_PER_HOUR=100
```

**工作原理：**
- 每 60 分钟重置计数器
- 达到限制时暂停
- 显示倒计时

### 2. Circuit Breaker

**触发条件：**
- 3 次循环无文件变化
- 5 次循环相同错误
- 输出量下降 70%

**恢复机制：**
- 30 分钟后自动尝试恢复
- 或手动重置：`--reset-circuit`

### 3. 双条件退出

```python
# 伪代码
if completion_indicators >= 2 AND EXIT_SIGNAL == true:
    exit("project_complete")
else:
    continue_next_loop()
```

**防止：**
- Claude 误判"完成了一阶段"
- 实际还有更多工作
- 过早退出循环

---

## 🎯 最佳实践

### 1. 任务管理

**每日：**
- 检查 `.ralph/fix_plan.md` 进度
- 添加新任务到 High Priority
- 移动已完成任务到 Completed

**每周：**
- 回顾任务优先级
- 调整 Low → Medium → High
- 清理过时任务

### 2. 监控策略

**轻度监控：**
```bash
ralph --monitor
# 每天检查一次
```

**深度监控：**
```bash
ralph --monitor --live --verbose
# 实时观察每个步骤
```

### 3. 故障处理

**Ralph 卡住时：**
```bash
# 1. 查看日志
tail -50 .ralph/logs/ralph.log

# 2. 检查熔断器
ralph --circuit-status

# 3. 重置
ralph --reset-circuit
ralph --reset-session

# 4. 重启
ralph --monitor
```

### 4. 性能优化

**快速迭代：**
```bash
ralph --monitor --calls 200 --timeout 10
```

**保守稳定：**
```bash
ralph --monitor --calls 50 --timeout 30
```

**调试模式：**
```bash
ralph --monitor --live --verbose --timeout 60
```

---

## 🔍 调试技巧

### 1. 查看 Ralph 状态

```bash
# 当前状态
ralph --status

# 熔断器状态
ralph --circuit-status

# 会话信息
cat .ralph/.ralph_session
```

### 2. 手动测试任务

```bash
# 运行一次 Claude Code（不循环）
claude "优化移动端响应式布局"

# 查看 Claude Code 帮助
claude --help
```

### 3. 检查配置

```bash
# 验证 .ralphrc
cat .ralphrc

# 验证任务列表
cat .ralph/fix_plan.md

# 验证构建指令
cat .ralph/AGENT.md
```

---

## 📚 相关资源

- **Ralph GitHub**: https://github.com/frankbria/ralph-claude-code
- **Claude Code 文档**: https://docs.anthropic.com/claude/docs/claude-code
- **OpenClaw 文档**: https://docs.openclaw.ai
- **问题反馈**: https://github.com/frankbria/ralph-claude-code/issues

---

## 🎓 进阶技巧

### 1. 多项目管理

```bash
# 项目 1
cd ~/projects/app1
ralph --monitor

# 项目 2（另一个终端）
cd ~/projects/app2
ralph --monitor

# 查看所有会话
tmux list-sessions
```

### 2. CI/CD 集成

```bash
# 非交互模式
ralph-enable-ci --from github

# 自动化部署
ralph --auto-reset-circuit --timeout 60
```

### 3. 团队协作

```bash
# 同步任务列表
git add .ralph/fix_plan.md
git commit -m "Update tasks"
git push

# 团队成员拉取
git pull
ralph --monitor
```

---

**准备好了吗？开始使用 Ralph 吧！** 🚀

```bash
ralph --monitor
```
