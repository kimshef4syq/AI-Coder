# Ralph 监控指南 - 避免上下文爆炸

## ❌ 绝对禁止的操作

```bash
# 1. 不要读取 PTY 输出（会爆上下文！）
process action:log sessionId:ralph-xxx
process action:log sessionId:ralph-xxx limit:100

# 2. 不要 attach 到 tmux 会话（会看到几千行输出）
tmux attach -t ralph-xxx

# 3. 不要直接读取 Claude 输出日志（可能很大）
cat .ralph/logs/claude_output_*.log
```

## ✅ 安全的监控操作

### 1. 检查进程是否活着
```bash
# 方式 1：通过 process 工具
process action:poll sessionId:ralph-xxx

# 方式 2：检查 tmux 会话
tmux has-session -t ralph-xxx && echo "Running" || echo "Stopped"
```

### 2. 检查 Git 提交
```bash
# 查看最近的提交
git log --oneline -5

# 查看是否有新提交
git log --oneline --since="10 minutes ago"
```

### 3. 检查任务进度
```bash
# 统计完成的任务数
cat .ralph/fix_plan.md | grep "\[x\]" | wc -l

# 查看未完成的任务
cat .ralph/fix_plan.md | grep "\[ \]"
```

### 4. 检查日志（只看元数据）
```bash
# 只看最后几行（不包含 TUI 输出）
tail -20 .ralph/logs/ralph.log

# 检查日志文件大小
du -sh .ralph/logs/*.log

# 统计日志行数
wc -l .ralph/logs/*.log
```

### 5. 检查 Ralph 循环次数
```bash
# 从日志中提取循环次数
grep "Starting Loop" .ralph/logs/ralph.log | tail -1

# 查看调用计数
grep "Call [0-9]*/" .ralph/logs/ralph.log | tail -1
```

## 🎯 使用 Wake Event 机制（推荐）

在启动 Ralph 时加入 wake event：

```bash
claude --dangerously-skip-permissions "任务描述

When finished, run: openclaw system event --text 'Ralph done: XXX' --mode now"
```

这样 Ralph 完成后会**主动通知**，不需要轮询。

## 📊 完整监控脚本示例

```bash
#!/bin/bash
# safe-monitor-ralph.sh

SESSION="ralph-1772904769"
LOG_DIR=".ralph/logs"

echo "=== Ralph Status Check ==="

# 1. 检查进程
if tmux has-session -t $SESSION 2>/dev/null; then
    echo "✅ Process: Running"
else
    echo "❌ Process: Stopped"
fi

# 2. 检查 Git
echo ""
echo "📝 Recent commits:"
git log --oneline -3

# 3. 检查任务进度
echo ""
echo "✅ Completed tasks:"
cat .ralph/fix_plan.md 2>/dev/null | grep "\[x\]" | wc -l

echo ""
echo "⏳ Pending tasks:"
cat .ralph/fix_plan.md 2>/dev/null | grep "\[ \]" | wc -l

# 4. 检查循环次数
echo ""
echo "🔄 Loop status:"
grep "Starting Loop" $LOG_DIR/ralph.log 2>/dev/null | tail -1

# 5. 检查日志大小
echo ""
echo "📊 Log sizes:"
du -sh $LOG_DIR/*.log 2>/dev/null
```

## 🚨 紧急情况处理

如果发现上下文快满了：

1. **立即停止监控** - 不要再读取任何日志
2. **检查 Git** - 确认工作已提交
3. **启动新会话** - 用 `/new` 开始新会话
4. **继续监控** - 从 Git 状态恢复上下文

## 📝 记住

- **Text > Brain** - 不要依赖"记住"，写下来
- **不要读 PTY** - 永远不要用 `process action:log`
- **用 wake event** - 让 Ralph 主动通知你
- **只看元数据** - 文件大小、行数、状态，不要看内容
