# Ralph 前台运行操作指南

## 🎯 核心原则

**所有 Ralph/Claude Code 操作必须前台可见！**

- 用户可以随时查看运行过程
- 出问题立即看到原因
- 避免后台卡住不知道

---

## 📋 标准操作流程

### 方式 1: 直接前台运行（简单任务）

```bash
# 最简单的方式 - 直接运行
cd /path/to/project
ralph loop "任务描述"
```

**优点：**
- 简单直接
- 实时看到所有输出
- Ctrl+C 可立即停止

**缺点：**
- 需要保持终端打开
- 关闭终端会中断任务

---

### 方式 2: tmux 前台会话（推荐）

```bash
# 1. 创建前台 tmux 会话
tmux new-session -s ralph-dev

# 2. 在 tmux 内运行 Ralph
cd /path/to/project
ralph loop "autonomous development"

# 3. 用户可以随时：
Ctrl+B, D              # 暂时离开（进程继续）
tmux attach -t ralph-dev  # 重新查看
```

**优点：**
- 可以随时离开和回来
- 过程完全可见
- 关闭终端不影响进程

**缺点：**
- 需要学习 tmux 基本操作

---

### 方式 3: tmux 分屏（多任务监控）

```bash
# 创建分屏会话
tmux new-session -s ralph-monitor \; split-window -h

# 左边：运行 Ralph
ralph loop "task"

# 右边：监控 Git（Ctrl+B, 方向键切换）
watch -n 5 'git log --oneline -3 && echo && git status --short'
```

---

## 🛠️ Code Master 操作规范

### 启动 Ralph（前台）

```bash
# ✅ 正确方式
tmux new-session -s ralph-frontend

# 在 tmux 内运行（用户可以看到）
cd /path/to/project
ralph loop "autonomous development"
```

**必须告诉用户：**
```
🚀 Ralph 已在前台 tmux 会话中启动

📊 会话名: ralph-frontend
💡 查看方式: tmux attach -t ralph-frontend
⏸️  暂时离开: Ctrl+B, D
⏹️  停止运行: Ctrl+C

我会定期检查进度，但你可以随时自己查看！
```

---

### 监控 Ralph（不要读输出）

**❌ 绝对禁止：**
```bash
# 会爆上下文！
process action:log sessionId:ralph-xxx
tmux capture-pane -t ralph-xxx -p
cat .ralph/logs/claude_output_*.log
```

**✅ 正确监控：**
```bash
# 1. 检查进程是否活着
tmux has-session -t ralph-frontend && echo "✅ Running" || echo "❌ Stopped"

# 2. 检查 Git 提交
git log --oneline --since="10 minutes ago"

# 3. 检查任务进度
cat .ralph/fix_plan.md | grep "\[x\]" | wc -l

# 4. 检查日志大小（不读内容）
du -sh .ralph/logs/*.log
```

---

### 检查状态（定期）

```bash
# 每 5-10 分钟检查一次
tmux has-session -t ralph-frontend

# 如果会话还在，说明还在运行
# 如果会话没了，说明完成了或崩溃了
```

---

## 📊 用户操作指南

### 查看运行过程

```bash
# 1. 连接到 tmux 会话
tmux attach -t ralph-frontend

# 2. 你会看到：
- Claude Code 的实时输出
- Ralph 的循环进度
- 文件修改日志
- 错误信息（如果有）

# 3. 操作：
Ctrl+B, D     # 暂时离开（进程继续）
Ctrl+C        # 停止 Ralph
q             # 退出 less/more
```

---

### tmux 快捷键速查

```
Ctrl+B, D       断开（Detached）- 进程继续
Ctrl+B, [       进入复制模式（可翻页）
Ctrl+B, ]       粘贴
Ctrl+C          停止当前命令
Ctrl+B, ?       显示所有快捷键
```

---

## 🔧 异常处理

### 如果 Ralph 卡住了

```bash
# 1. 用户视角（推荐）
tmux attach -t ralph-frontend  # 查看
Ctrl+C                         # 停止

# 2. Code Master 视角（如果用户不在）
tmux kill-session -t ralph-frontend  # 强制停止
```

---

### 如果需要重启

```bash
# 1. 停止当前会话
tmux kill-session -t ralph-frontend

# 2. 重新启动（前台）
tmux new-session -s ralph-frontend
ralph loop "task"
```

---

## 💡 最佳实践

### 启动时

```bash
# 1. 检查是否有残留会话
tmux list-sessions

# 2. 如果有，先清理
tmux kill-session -t ralph-frontend

# 3. 启动新会话
tmux new-session -s ralph-frontend
```

---

### 运行时

```bash
# Code Master 定期检查：
- 每 10 分钟检查一次 tmux 会话
- 检查 Git 提交（看进度）
- 不要读取输出

# 用户可以：
- 随时 attach 查看
- 不影响进程运行
```

---

### 完成后

```bash
# 1. 会话自动关闭
tmux has-session -t ralph-frontend
# 返回: no session

# 2. 检查成果
git log --oneline -10
cat .ralph/fix_plan.md | grep "\[x\]"
```

---

## 📝 总结

| 操作 | 方式 | 是否可见 | 推荐度 |
|------|------|---------|--------|
| 直接运行 | `ralph loop` | ✅ 完全可见 | ⭐⭐⭐ 简单任务 |
| tmux 前台 | `tmux new` | ✅ 随时可看 | ⭐⭐⭐⭐⭐ 推荐 |
| tmux 后台 | `tmux new -d` | ❌ 不可见 | ❌ 禁止 |
| nohup | `nohup &` | ❌ 不可见 | ❌ 禁止 |

---

**核心：前台运行，过程可见，随时可控！**
