# Tart Prototype 模型测试文档

## 概述

这个测试套件为 Tart Prototype 项目中的所有核心 Model 提供了全面的单元测试。测试使用 XCTest 框架编写，确保模型的功能正确性、数据完整性和边界条件处理。

## 测试文件结构

```
tart_prototypeTests/
├── ModelsTests.swift               # User 模型测试
├── ArtworkTests.swift             # Artwork 模型测试
├── CommentTests.swift             # Comment 模型测试
├── LoginModelTests.swift          # LoginModel 测试
├── MessageBaseModelsTests.swift   # 消息相关模型测试
├── ModelTestSuite.swift           # 测试套件管理
└── README.md                      # 这个文档
```

## 测试覆盖的模型

### 核心数据模型
- **User** - 用户基础信息模型
- **Artwork** - 艺术作品模型
- **Comment** - 评论模型

### 视图模型
- **LoginModel** - 登录相关业务逻辑

### 消息系统模型
- **MessageType** - 消息类型枚举
- **MessageStatus** - 消息状态枚举
- **MessagePreview** - 消息预览
- **ChatMessage** - 聊天消息
- **MessageMetadata** - 消息元数据
- **MessageContent** - 消息内容
- **MessageNotification** - 消息通知
- **MessageGroup** - 消息群组
- **GroupSettings** - 群组设置
- **CommentItem** - 评论项目

## 如何运行测试

### 在 Xcode 中运行

1. **运行所有测试**
   - 快捷键: `Cmd + U`
   - 或者: Product → Test

2. **运行特定测试类**
   - 在测试导航器中点击特定测试类旁的播放按钮
   - 或者在代码中点击类名旁的菱形图标

3. **运行单个测试方法**
   - 点击测试方法旁的菱形图标
   - 或者将光标放在测试方法中按 `Cmd + U`

### 命令行运行

```bash
# 运行所有测试
xcodebuild test -scheme tart_prototype -destination 'platform=iOS Simulator,name=iPhone 15'

# 运行特定测试类
xcodebuild test -scheme tart_prototype -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:tart_prototypeTests/ModelsTests

# 运行特定测试方法
xcodebuild test -scheme tart_prototype -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:tart_prototypeTests/ModelsTests/testUserInitialization
```

## 测试类型说明

### 1. 初始化测试 (Initialization Tests)
验证模型对象能否正确初始化，所有属性是否设置正确。

```swift
func testUserInitialization() {
    // 测试 User 模型的初始化
}
```

### 2. 相等性测试 (Equality Tests)
验证模型的 `Equatable` 协议实现，确保相等性逻辑正确。

```swift
func testUserEquality() {
    // 测试具有相同 ID 的用户应该被认为是相等的
}
```

### 3. 哈希测试 (Hashable Tests)
验证模型的 `Hashable` 协议实现，确保哈希逻辑一致。

```swift
func testUserHashable() {
    // 测试相同 ID 的对象应该有相同的 hash 值
}
```

### 4. 编码解码测试 (Codable Tests)
验证模型的 JSON 序列化和反序列化功能。

```swift
func testUserCoding() {
    // 测试 User 模型的 JSON 编码/解码
}
```

### 5. 业务逻辑测试 (Business Logic Tests)
验证模型中的业务逻辑方法，如点赞、保存等功能。

```swift
func testArtworkLikesFunctionality() {
    // 测试艺术作品的点赞功能
}
```

### 6. 边界条件测试 (Edge Case Tests)
验证模型在边界条件下的行为，如空值、特殊字符等。

```swift
func testCommentWithEmptyContent() {
    // 测试空内容的评论
}
```

### 7. 异步测试 (Async Tests)
验证异步操作，特别是 LoginModel 中的登录功能。

```swift
func testSignInWithEmailSuccess() async {
    // 测试邮箱登录功能
}
```

## 测试最佳实践

### 1. 测试命名规范
- 使用描述性的测试方法名
- 遵循 `test[WhatIsBeingTested][ExpectedBehavior]` 格式
- 使用中文注释说明测试目的

### 2. 测试数据管理
```swift
override func setUp() {
    super.setUp()
    // 在每个测试前设置测试数据
}

override func tearDown() {
    // 在每个测试后清理资源
    super.tearDown()
}
```

### 3. 断言使用
- `XCTAssertEqual` - 验证相等性
- `XCTAssertNotEqual` - 验证不相等
- `XCTAssertTrue/False` - 验证布尔值
- `XCTAssertNil/NotNil` - 验证可选值
- `XCTAssertThrowsError` - 验证错误抛出

### 4. 异步测试
```swift
func testAsyncFunction() async {
    // 使用 async/await 语法测试异步功能
    let expectation = XCTestExpectation(description: "Async operation")
    // ... 测试逻辑
    await fulfillment(of: [expectation], timeout: 5.0)
}
```

## 测试覆盖率

要启用代码覆盖率报告：

1. 在 Xcode 中打开 Scheme Editor (Product → Scheme → Edit Scheme)
2. 选择 "Test" 选项卡
3. 在 "Info" 部分勾选 "Code Coverage"
4. 运行测试后在 Report Navigator 中查看覆盖率报告

## 故障排除

### 常见问题
3
1. **测试找不到模型类**
   - 确保在测试文件中添加了 `@testable import tart_prototype`
   - 检查模型类是否为 `public` 或 `internal` 访问级别

2. **异步测试超时**
   - 增加 `timeout` 值
   - 检查异步操作是否正确调用了 `expectation.fulfill()`

3. **编码解码测试失败**
   - 确保所有属性都符合 `Codable` 协议
   - 检查日期编码策略是否一致

4. **Combine 相关测试失败**
   - 确保导入了 `Combine` 框架
   - 正确管理 `AnyCancellable` 订阅

## 扩展测试

要为新模型添加测试：

1. 创建新的测试文件: `[ModelName]Tests.swift`
2. 继承 `XCTestCase`
3. 实现必要的测试方法
4. 更新 `ModelTestSuite.swift` 中的测试类列表

## 性能测试

对于性能敏感的操作，可以添加性能测试：

```swift
func testModelPerformance() {
    measure {
        // 执行需要测量性能的代码
    }
}
```

## 总结

这个测试套件确保了 Tart Prototype 项目中所有核心模型的质量和可靠性。定期运行这些测试可以：

- 及早发现回归问题
- 确保代码重构的安全性
- 提高代码质量和可维护性
- 为新功能开发提供信心

记住：好的测试是项目成功的关键组成部分！ 
