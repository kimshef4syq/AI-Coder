# Ralph 卡住根本原因分析

## 🎯 核心问题

**GLM-5 模型输入 token 爆炸导致进程崩溃**

---

## 📊 证据链

### 1. 最后的 Claude 状态
```json
{
  "stop_reason": "tool_use",
  "usage": {
    "input_tokens": 94424,    // ← 94K tokens！
    "output_tokens": 265,
    "cache_read_input_tokens": 20160
  }
}
```

### 2. 执行流程
```
Loop #2 开始 (01:47:44)
  ↓
Claude 请求读取文件
  ├─ Review.tsx (274 行)
  └─ fix_plan.md (约 100 行)
  ↓
系统返回文件内容（完整文本）
  ↓
输入 token 累积到 94,424
  ↓
模型处理超时/崩溃
  ↓
进程退出（无错误日志）
  ↓
tmux 会话保持（tee 还在等待）
```

### 3. 对比 Loop #1
- Loop #1: 修改了 3 个文件，但**分批处理**
- Loop #2: 一次性读取 2 个大文件 → token 爆炸

---

## 💥 问题分析

### 为什么会爆 token？

1. **累积的上下文**
   - Loop #1 的所有对话历史
   - Loop #2 的 system prompt
   - 读取的文件内容（Review.tsx 274 行）

2. **GLM-5 的限制**
   - 上下文窗口: 约 1M tokens
   - 但处理速度和稳定性在高 token 时下降
   - 94K tokens 可能触发了某个内部限制

3. **Ralph 的问题**
   - 使用 `--resume` 继续会话（累积历史）
   - 没有定期压缩上下文
   - 没有检测到进程异常退出

---

## 🔧 解决方案

### 方案 1: 定期清理上下文（推荐）

```bash
# 修改 .ralphrc
CLAUDE_OUTPUT_FORMAT="json"
MAX_CONTEXT_TOKENS=50000  # 新增配置

# Ralph 应该：
# - 每隔几个 loop 重启会话
# - 或者使用 /compact 压缩上下文
```

### 方案 2: 限制文件读取大小

```bash
# Ralph 应该：
# - 读取文件前检查大小
# - 只读取必要的部分
# - 避免一次性加载大文件
```

### 方案 3: 添加健康检查

```bash
# 在 wait-for-ralph.sh 中添加：
if ! pgrep -f "claude.*stream-json" > /dev/null; then
    echo "⚠️ Claude process died unexpectedly"
    # 触发 wake event
    openclaw system event --text "⚠️ Ralph stopped: Claude process died"
    # 清理会话
    tmux kill-session -t $SESSION
    exit 1
fi
```

### 方案 4: 减少累积的历史

```bash
# 启动 Ralph 时不使用 --resume
# 每次都从新会话开始
CLAUDE_RESUME=false
```

---

## 🚨 当前状态

**已完成的工作：**
- ✅ Loop #1: 修改了 3 个文件
- ✅ 代码已优化（Dashboard, Learn, AddWord）
- ❌ 未提交到 Git

**卡住的位置：**
- 📍 Loop #2 准备更新 fix_plan.md
- 📍 读取了 Review.tsx
- 📍 然后崩溃了

---

## 📋 立即行动

### 清理并保存成果

```bash
# 1. 停止 Ralph
tmux kill-session -t ralph-1772904769
kill 34585  # wait-for-ralph

# 2. 提交 Loop #1 的成果
git add src/pages/
git commit -m "feat: optimize UI components (Ralph Loop #1)

- Refactor Dashboard layout
- Improve Learn page UX
- Optimize AddWord form

Note: Ralph Loop #2 crashed due to token overflow (94K input tokens)"

# 3. 更新 fix_plan.md（手动标记任务完成）

# 4. 重启 Ralph（如果需要）
# 考虑使用新的会话（不 --resume）
```

---

## 🎓 教训

1. **监控进程健康** - 不能只看 tmux 会话是否存在
2. **限制上下文大小** - AI 模型有处理限制
3. **及时提交** - 每完成一个任务就提交，避免丢失成果
4. **添加超时检测** - 16 分钟无响应应该报警

---

## 🔢 统计

- **运行时间**: 31 分钟
- **成功循环**: 1 个
- **崩溃循环**: 1 个（token 爆炸）
- **峰值 token**: 94,424 (输入)
- **丢失的工作**: Loop #2 的部分（读取了文件但未处理）
