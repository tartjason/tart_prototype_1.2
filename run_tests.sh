#!/bin/bash

# 测试运行脚本 - Tart项目
echo "🧪 开始运行 Tart 项目测试..."

# 配置
PROJECT_NAME="tart_prototype"
SCHEME="tart_prototype"
SIMULATOR_NAME="iPhone 16"

echo "📱 项目: $PROJECT_NAME"
echo "🎯 Scheme: $SCHEME"
echo "📟 模拟器: $SIMULATOR_NAME"
echo "📁 工作目录: $(pwd)"

# 检查是否有可用的模拟器
echo "🔍 检查模拟器..."
SIMULATOR_ID=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | head -1 | grep -E -o '\([A-F0-9-]{36}\)' | tr -d '()')

if [ -z "$SIMULATOR_ID" ]; then
    echo "❌ 未找到 $SIMULATOR_NAME 模拟器"
    exit 1
fi

echo "✅ 找到模拟器: $SIMULATOR_NAME ($SIMULATOR_ID)"

# 启动模拟器
echo "🚀 启动模拟器..."
xcrun simctl boot $SIMULATOR_ID 2>/dev/null || echo "📱 模拟器已启动"

# 等待模拟器启动完成
echo "⏳ 等待模拟器就绪..."
sleep 2

# 尝试运行测试 - 先构建再测试
echo "🔨 构建并运行测试..."

# 方法1: 直接运行测试
echo "📋 方法1: 尝试直接测试..."
xcodebuild test \
    -project ${PROJECT_NAME}.xcodeproj \
    -scheme $SCHEME \
    -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
    -only-testing:${PROJECT_NAME}Tests/LoginModelTests 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ 测试运行成功！"
    exit 0
fi

echo "⚠️  方法1失败，尝试方法2..."

# 方法2: 先构建再测试
echo "📋 方法2: 先构建测试目标..."
xcodebuild build-for-testing \
    -project ${PROJECT_NAME}.xcodeproj \
    -scheme $SCHEME \
    -destination "platform=iOS Simulator,id=$SIMULATOR_ID"

if [ $? -eq 0 ]; then
    echo "🔨 构建成功，现在运行测试..."
    xcodebuild test-without-building \
        -project ${PROJECT_NAME}.xcodeproj \
        -scheme $SCHEME \
        -destination "platform=iOS Simulator,id=$SIMULATOR_ID"
    
    if [ $? -eq 0 ]; then
        echo "✅ 测试运行成功！"
        exit 0
    fi
fi

echo "⚠️  方法2失败，尝试方法3..."

# 方法3: 直接运行测试包
echo "📋 方法3: 直接运行测试包..."
TEST_BUNDLE_PATH="$HOME/Library/Developer/Xcode/DerivedData/${PROJECT_NAME}-*/Build/Products/Debug-iphonesimulator/${PROJECT_NAME}.app/PlugIns/${PROJECT_NAME}Tests.xctest"

if ls $TEST_BUNDLE_PATH 1> /dev/null 2>&1; then
    echo "✅ 找到测试包: $TEST_BUNDLE_PATH"
    xcrun simctl spawn $SIMULATOR_ID xctest $(echo $TEST_BUNDLE_PATH)
    
    if [ $? -eq 0 ]; then
        echo "✅ 测试运行成功！"
        exit 0
    fi
fi

# 如果所有方法都失败
echo "❌ 所有测试方法都失败了"
echo "📝 请检查以下内容："
echo "   - Xcode scheme 是否配置了测试"
echo "   - 测试目标是否正确添加到 scheme"
echo "   - 模拟器是否正常运行"

echo ""
echo "🔧 手动运行测试的方法："
echo "   1. 在 Xcode 中打开项目"
echo "   2. 选择 Product -> Test (⌘U)"
echo "   3. 或者在测试文件中点击测试方法旁的播放按钮"

exit 1 