#!/bin/bash

# Amplify 快速配置脚本
# 用于完成 iOS 项目的 Amplify 配置

set -e

echo "🚀 开始配置 Amplify..."

# 检查 Amplify CLI 是否安装
if ! command -v amplify &> /dev/null; then
    echo "❌ Amplify CLI 未安装"
    echo "请先安装 Amplify CLI:"
    echo "npm install -g @aws-amplify/cli"
    exit 1
fi

echo "✅ Amplify CLI 已安装"

# 检查是否已初始化
if [ ! -d "amplify" ]; then
    echo "❌ Amplify 未初始化"
    echo "请先运行: amplify init"
    exit 1
fi

echo "✅ Amplify 已初始化"

# 检查当前配置
echo "📋 检查当前配置..."

# 检查 API 配置
if ! grep -q '"api": {}' amplify/backend/backend-config.json; then
    echo "✅ API 已配置"
else
    echo "⚠️  API 未配置，需要添加 GraphQL API"
    echo "请运行: amplify add api"
    echo "选择: GraphQL, tartprototype12, Amazon Cognito User Pool"
fi

# 检查 Storage 配置
if ! grep -q '"storage": {}' amplify/backend/backend-config.json; then
    echo "✅ Storage 已配置"
else
    echo "⚠️  Storage 未配置，需要添加 S3 存储"
    echo "请运行: amplify add storage"
    echo "选择: Content (S3), tartprototypestorage, Auth users only"
fi

# 检查配置文件
if [ -f "amplifyconfiguration.json" ]; then
    echo "✅ amplifyconfiguration.json 存在"
else
    echo "❌ amplifyconfiguration.json 不存在"
    echo "请运行: amplify push 生成配置文件"
fi

# 检查 Info.plist
if [ -f "tart-prototype-Info.plist" ]; then
    echo "✅ Info.plist 存在"
    
    # 检查 URL Schemes
    if grep -q "tart" tart-prototype-Info.plist; then
        echo "✅ URL Schemes 已配置"
    else
        echo "⚠️  URL Schemes 未配置"
    fi
    
    # 检查权限
    if grep -q "NSCameraUsageDescription" tart-prototype-Info.plist; then
        echo "✅ 相机权限已配置"
    else
        echo "⚠️  相机权限未配置"
    fi
    
    if grep -q "NSPhotoLibraryUsageDescription" tart-prototype-Info.plist; then
        echo "✅ 相册权限已配置"
    else
        echo "⚠️  相册权限未配置"
    fi
else
    echo "❌ Info.plist 不存在"
fi

# 检查 Swift Package
echo "📦 检查 Swift Package 依赖..."

# 检查项目文件中的 Amplify 引用
if grep -q "Amplify" tart_prototype.xcodeproj/project.pbxproj; then
    echo "✅ Amplify Swift Package 已添加"
else
    echo "❌ Amplify Swift Package 未添加"
    echo "请在 Xcode 中添加: https://github.com/aws-amplify/amplify-swift"
fi

echo ""
echo "🎯 下一步操作:"
echo ""

# 如果 API 未配置
if grep -q '"api": {}' amplify/backend/backend-config.json; then
    echo "1. 添加 GraphQL API:"
    echo "   amplify add api"
    echo "   - 选择: GraphQL"
    echo "   - API name: tartprototype12"
    echo "   - Authorization: Amazon Cognito User Pool"
    echo ""
fi

# 如果 Storage 未配置
if grep -q '"storage": {}' amplify/backend/backend-config.json; then
    echo "2. 添加 S3 Storage:"
    echo "   amplify add storage"
    echo "   - 选择: Content (S3)"
    echo "   - Storage name: tartprototypestorage"
    echo "   - Access level: Auth users only"
    echo ""
fi

echo "3. 推送配置到云端:"
echo "   amplify push"
echo ""

echo "4. 在 Xcode 中验证:"
echo "   - 打开项目"
echo "   - 构建项目 (⌘+B)"
echo "   - 运行项目 (⌘+R)"
echo ""

echo "5. 检查控制台输出:"
echo "   - 查找 '✅ Amplify configured successfully'"
echo "   - 查找 '📱 Auth Plugin: ✅'"
echo "   - 查找 '🔗 API Plugin: ✅'"
echo "   - 查找 '💾 Storage Plugin: ✅'"
echo ""

echo "📚 详细指南请参考: AMPLIFY_COMPLETE_SETUP_GUIDE.md"
echo ""

# 检查是否有未推送的更改
if [ -f "amplify/backend/amplify-meta.json" ]; then
    echo "🔍 检查是否有未推送的更改..."
    amplify status
fi

echo "✨ 配置检查完成！" 