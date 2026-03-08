# Ralph 使用指南 - Vocabulary App

## 🚀 快速开始

### 1. 启动 Ralph

```bash
cd ~/Documents/07-skill-prompt/01-cluade-skills/coding-workspace/vocabulary-app

# 推荐：集成监控模式
ralph --monitor

# 或：手动监控模式（两个终端）
# Terminal 1:
ralph

# Terminal 2:
ralph-monitor
```

---

## 📋 当前任务列表

### 🔥 高优先级（本周）
1. ✅ 优化移动端响应式布局
2. ✅ 添加加载状态动画
3. ✅ 优化表单交互
4. ✅ 添加 Toast 通知
5. ✅ 优化按钮反馈效果
6. ✅ 添加单词音标发音
7. ✅ 实现标签分类系统
8. ✅ 添加学习进度图表
9. ✅ 实现搜索筛选功能
10. ✅ 添加批量操作

---

## 🎯 监控 Ralph

### tmux 快捷键

- **分离会话**: `Ctrl+B` 然后 `D`
- **切换面板**: `Ctrl+B` 然后 `←/→`
- **查看会话**: `tmux list-sessions`
- **重新连接**: `tmux attach -t ralph`

### 查看日志

```bash
# 实时日志
tail -f .ralph/logs/ralph.log

# 查看状态
ralph --status

# 查看熔断器状态
ralph --circuit-status
```

---

## 🔧 常用命令

```bash
# 启动并限制每小时 50 次调用
ralph --monitor --calls 50

# 启用实时输出
ralph --monitor --live

# 详细模式
ralph --monitor --verbose

# 设置 30 分钟超时
ralph --monitor --timeout 30

# 重置会话
ralph --reset-session

# 重置熔断器
ralph --reset-circuit
```

---

## 📊 Ralph 状态说明

### 状态码

- **IN_PROGRESS**: 正在工作中
- **COMPLETE**: 任务完成
- **BLOCKED**: 遇到障碍

### 退出信号

Ralph 使用双条件退出检测：
1. `completion_indicators >= 2`（检测完成模式）
2. `EXIT_SIGNAL: true`（Claude 明确确认）

**只有两个条件都满足才会退出！**

---

## 🛡️ 安全机制

### Rate Limiting
- 默认：100 次/小时
- 可配置：`--calls 50`

### Circuit Breaker（熔断器）
- 3 次无进展 → 打开熔断器
- 5 次相同错误 → 打开熔断器
- 30 分钟后自动恢复

### Session 管理
- 默认 24 小时过期
- 可手动重置：`--reset-session`

---

## 📝 编辑任务

### 添加新任务

编辑 `.ralph/fix_plan.md`:

```markdown
## 🔥 High Priority
- [ ] 新任务描述
```

### 标记任务完成

```markdown
- [x] 已完成的任务
```

---

## 🐛 故障排查

### Ralph 不启动
```bash
# 检查 Claude Code
which claude

# 检查项目配置
cat .ralphrc
```

### 熔断器打开
```bash
# 查看状态
ralph --circuit-status

# 重置
ralph --reset-circuit
```

### 会话过期
```bash
# 重置会话
ralph --reset-session

# 重新启动
ralph --monitor
```

---

## 💡 最佳实践

1. **一次一个任务**: Ralph 每次循环只处理一个任务
2. **及时更新任务**: 完成 后立即更新 fix_plan.md
3. **定期检查日志**: 查看执行日志了解进度
4. **合理设置 Rate Limit**: 避免超过 API 限制
5. **使用监控模式**: `--monitor` 提供最佳体验

---

## 🎯 本周目标

1. 优化移动端体验
2. 添加音标发音
3. 实现标签系统
4. 完善加载状态

---

**准备好了吗？开始使用 Ralph 吧！** 🚀

```bash
ralph --monitor
```
