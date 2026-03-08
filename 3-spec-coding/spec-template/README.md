# Spec Coding 快速开始

> **一键创建新项目的规则驱动开发结构**

---

## 🚀 快速开始

### 方法 1：复制模板目录

```bash
# 1. 复制模板到新项目
cp -r spec-template/ new-project/

# 2. 进入新项目
cd new-project/

# 3. 重命名模板文件
cd .specify/
mv constitution.template.md constitution.md
cd specs/
mv spec.template.md README.md  # 删除，只保留示例
cd ../plans/
mv plan.template.md README.md
mv tasks.template.md README.md

# 4. 编辑 constitution.md
# 5. 开始第一个功能
```

### 方法 2：使用脚本（推荐）

```bash
# 1. 运行创建脚本
./scripts/create-spec-project.sh my-new-project

# 2. 脚本会自动：
#    - 创建目录结构
#    - 复制模板文件
#    - 初始化 Git（可选）
```

---

## 📁 模板结构

```
spec-template/
├── .specify/
│   ├── constitution.template.md     # 项目宪法模板
│   ├── specs/
│   │   └── spec.template.md         # 需求规范模板
│   ├── plans/
│   │   ├── plan.template.md         # 技术方案模板
│   │   └── tasks.template.md        # 任务列表模板
│   └── contracts/                   # API 接口定义（可选）
└── README.md                         # 本文件
```

---

## 📝 使用步骤

### 第一步：定制宪法
1. 编辑 `constitution.md`
2. 定义技术栈、代码规范、设计规范
3. 设置约束和禁止项

### 第二步：创建第一个功能
1. 在 `specs/` 创建新目录（如 `001-user-auth/`）
2. 复制 `spec.template.md` 到新目录
3. 填写需求描述和验收标准

### 第三步：生成技术方案
1. 在 `plans/` 创建对应目录
2. 复制 `plan.template.md`
3. 填写技术架构和实现细节

### 第四步：拆解任务
1. 复制 `tasks.template.md`
2. 拆解为可执行的子任务
3. 估算时间

### 第五步：执行
选择执行方式：
- 手动执行
- Ralph Wiggum Plugin
- Claude Code

---

## 🎯 最佳实践

### 项目命名
- 使用小写 + 连字符：`my-awesome-project`
- 版本号递增：`001`, `002`, `003`

### 功能命名
- 简洁明了：`user-auth`, `dark-mode`, `toast-notification`
- 使用英文连字符

### 任务编号
- 全局递增：T001, T002, T003...
- 或按功能编号：AUTH-001, UI-001...

---

## 📚 参考资料

- [Spec-Kit 官方文档](https://github.com/github/spec-kit)
- [智谱 AI 最佳实践](https://docs.bigmodel.cn/cn/coding-plan/best-practice/spec-kit)

---

**核心理念：代码为规格服务，而不是规格为代码服务！**
