#!/bin/bash

# Spec Coding 项目创建脚本
# 用法: ./create-spec-project.sh <project-name>

set -e

PROJECT_NAME=${1:-"my-project"}

echo "🚀 Creating Spec Coding project: $PROJECT_NAME"

# 检查项目名是否已存在
if [ -d "$PROJECT_NAME" ]; then
    echo "❌ Error: Directory '$PROJECT_NAME' already exists"
    exit 1
fi

# 创建项目目录
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 创建 .specify 目录结构
mkdir -p .specify/specs
mkdir -p .specify/plans
mkdir -p .specify/contracts

# 复制模板文件
TEMPLATE_DIR="../spec-template/.specify"

if [ -d "$TEMPLATE_DIR" ]; then
    cp "$TEMPLATE_DIR/constitution.template.md" .specify/constitution.md
    echo "✅ Created constitution.md"
    
    # 创建示例文件（可选，用于参考）
    cp "$TEMPLATE_DIR/specs/spec.template.md" .specify/specs/README.md
    cp "$TEMPLATE_DIR/plans/plan.template.md" .specify/plans/README.md
    cp "$TEMPLATE_DIR/plans/tasks.template.md" .specify/plans/README.md
    
    echo "✅ Created template structure"
else
    # 如果没有模板目录，创建基础文件
    cat > .specify/constitution.md << 'EOF'
# 项目宪法

> **说明：** 根据项目需求修改此文件

## 🎯 项目定位

**[项目名称]** 是一个 [项目描述]

## 🛠 技术栈

- **前端：** [React/Vue/Svelte]
- **语言：** [TypeScript/JavaScript]
- **样式：** [TailwindCSS/CSS Modules]

## 📏 代码规范

- ✅ 函数组件优先
- ✅ TypeScript 严格模式
- ✅ 单一职责原则

---

**更新时间：** $(date +%Y-%m-%d)
EOF
    
    echo "✅ Created basic constitution.md"
fi

# 创建项目 README
cat > README.md << EOF
# $PROJECT_NAME

> 基于 Spec Coding 规则驱动开发流程

---

## 📁 项目结构

\`\`\`
$PROJECT_NAME/
├── .specify/           # 规则驱动开发文件
│   ├── constitution.md # 项目宪法
│   ├── specs/          # 需求规范
│   ├── plans/          # 技术方案
│   └── contracts/      # 接口定义
└── README.md           # 项目说明
\`\`\`

---

## 🚀 快速开始

1. 编辑 \`.specify/constitution.md\`（定义技术栈和规范）
2. 创建第一个功能：\`.specify/specs/001-first-feature/spec.md\`
3. 生成技术方案：\`.specify/plans/001-first-feature/plan.md\`
4. 拆解任务：\`.specify/plans/001-first-feature/tasks.md\`
5. 执行！

---

**创建时间：** $(date +%Y-%m-%d)
EOF

echo "✅ Created README.md"

# 初始化 Git（可选）
read -p "Initialize Git repository? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git init
    echo "✅ Initialized Git repository"
    
    # 创建 .gitignore
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/

# Build
dist/
build/

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Env
.env
.env.local
EOF
    
    echo "✅ Created .gitignore"
fi

echo ""
echo "🎉 Project '$PROJECT_NAME' created successfully!"
echo ""
echo "Next steps:"
echo "  1. cd $PROJECT_NAME"
echo "  2. Edit .specify/constitution.md"
echo "  3. Start your first feature!"
echo ""
