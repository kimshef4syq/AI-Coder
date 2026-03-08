# Ralph Wiggum Plugin - 官方文档总结

> 来源：https://github.com/anthropics/claude-code/blob/main/plugins/ralph-wiggum/README.md
> 日期：2026-03-06

---

## ⚠️ 核心理解

**Ralph Wiggum 是 Claude Code 的内置 Plugin，不是外部 bash 脚本！**

---

## 📋 正确使用方式

### 1. 基本命令

```bash
# 在 Claude Code TUI 内部使用：
/ralph-loop "<任务描述>" --completion-promise "COMPLETE" --max-iterations 50
```

### 2. 工作原理

```
用户执行一次 /ralph-loop
↓
Claude 开始工作
↓
Claude 尝试退出
↓
Stop Hook 拦截退出
↓
Stop Hook 重新注入相同的 prompt
↓
Claude 看到之前的工作成果（文件、git 历史）
↓
继续改进
↓
重复直到输出 completion promise
```

---

## 🔧 命令参数

### `/ralph-loop`

```bash
/ralph-loop "<prompt>" --max-iterations <n> --completion-promise "<text>"
```

**参数：**
- `--max-iterations` - 最大迭代次数（防止无限循环）
- `--completion-promise` - 完成信号短语（精确匹配）

### `/cancel-ralph`

取消当前运行的 Ralph loop。

---

## ✅ 最佳实践

### 1. 总是设置 max-iterations

```bash
# ✅ 推荐
/ralph-loop "实现功能 X" --max-iterations 20

# ❌ 危险（可能无限循环）
/ralph-loop "实现功能 X"
```

### 2. Prompt 要清晰具体

**❌ 差：**
```
"Build a todo API and make it good."
```

**✅ 好：**
```
Build a REST API for todos.

When complete:
- All CRUD endpoints working
- Input validation in place
- Tests passing (coverage > 80%)
- README with API docs
- Output: <promise>COMPLETE</promise>
```

### 3. 包含失败处理指令

```
"After 15 iterations, if not complete:
- Document what's blocking progress
- List what was attempted
- Suggest alternative approaches"
```

---

## 🎯 适用场景

### ✅ 适合 Ralph

- 任务有明确的成功标准
- 需要迭代改进（如：让测试通过）
- 全新项目（可以随时离开）
- 有自动验证（测试、linter）

### ❌ 不适合 Ralph

- 需要人工判断或设计决策
- 一次性操作
- 成功标准不清晰
- 生产环境调试（用针对性调试）
- 需要频繁人工确认的任务

---

## 🚫 常见错误

### 错误 1：当成外部脚本

**❌ 错误：**
```bash
# 自己写 ralph.sh bash 脚本
while true; do
  claude "任务"
done
```

**✅ 正确：**
```bash
# 在 Claude Code TUI 内部：
/ralph-loop "任务" --completion-promise "DONE"
```

---

### 错误 2：在非交互模式使用

**❌ 错误：**
```bash
claude --print "任务"  # Ralph 无法工作
```

**✅ 正确：**
```bash
claude  # 进入 TUI
/ralph-loop "任务"
```

---

### 错误 3：用 --dangerously-skip-permissions

**❌ 不需要：**
```bash
claude --dangerously-skip-permissions "任务"
```

**✅ Ralph 自动处理权限：**
```bash
/ralph-loop "任务"  # Stop Hook 会自动处理
```

---

## 📝 关键机制

### Stop Hook

- 位置：`hooks/stop-hook.sh`
- 作用：拦截 Claude 的退出尝试
- 行为：重新注入相同的 prompt
- 结果：创建自引用反馈循环

### 自引用循环

- Prompt 永远不变
- Claude 之前的工作保存在文件中
- 每次迭代都能看到修改后的文件和 git 历史
- Claude 通过读取自己的工作成果自主改进

---

## 🎓 设计哲学

### 1. 拥抱不完美
不要追求第一次就完美。让循环来改进工作。

### 2. "确定性地坏"
失败是可预测且有用的。用失败来调整 prompt。

### 3. Prompt Engineering 至关重要
成功取决于写好 prompt，而不仅仅是好模型。

### 4. 坚持就是胜利
坚持尝试直到成功。循环自动处理重试逻辑。

---

## 📊 成功案例

- YC 黑客马拉松：一晚生成 6 个仓库
- $50k 合同，只花 $297 API 成本
- 3 个月创建完整编程语言（"cursed"）

---

## 🔗 相关资源

- 原始技术：https://ghuntley.com/ralph/
- Ralph Orchestrator：https://github.com/mikeyobrien/ralph-orchestrator
- Claude Code 帮助：在 TUI 中运行 `/help`

---

## 💡 关键要点总结

1. **Ralph 是内置 Plugin，不是外部脚本**
2. **在 Claude Code TUI 内部使用 `/ralph-loop`**
3. **总是设置 `--max-iterations`**
4. **写清晰具体的 prompt**
5. **适合有明确成功标准的任务**
6. **不适合需要人工判断的任务**

---

**记住：Ralph = 内置斜杠命令，不是 bash 脚本！**
