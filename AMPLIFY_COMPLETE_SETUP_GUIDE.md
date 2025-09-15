# Amplify 完整配置指南

## 当前项目状态 ✅

### 已完成配置
1. **Amplify CLI 已初始化** - 项目根目录有 `amplify/` 文件夹
2. **认证服务已配置** - Cognito User Pool 和 Identity Pool 已设置
3. **Swift Package 已添加** - Amplify Swift SDK 已添加到 Xcode 项目
4. **基础代码已编写** - AmplifyManager 和登录相关代码已存在
5. **配置文件已更新** - `amplifyconfiguration.json` 包含真实配置

### 当前配置详情
- **AWS 区域**: us-east-2
- **Cognito User Pool ID**: us-east-2_UVLvPd428
- **Cognito Identity Pool ID**: us-east-2:fccb61f3-c78f-4f65-817d-45dcbeb96cfd
- **App Client ID**: 2gseemcp87hr7fh4e9kf7od01e
- **AppSync API**: d1f2zumggkpagr.appsync-api.us-east-2.amazonaws.com

## 需要完成的配置步骤

### 1. 添加 API 服务 ⚠️ 需要配置

当前 `backend-config.json` 显示 API 为空，需要添加 GraphQL API：

```bash
# 在项目根目录运行
amplify add api

# 选择以下选项：
# - GraphQL
# - API name: tartprototype12
# - Authorization type: Amazon Cognito User Pool
# - Schema: 使用默认或自定义
```

### 2. 添加存储服务 ⚠️ 需要配置

当前 `backend-config.json` 显示 Storage 为空，需要添加 S3 存储：

```bash
# 在项目根目录运行
amplify add storage

# 选择以下选项：
# - Content (S3)
# - Storage name: tartprototypestorage
# - Access level: Auth users only
# - Guest access: No
# - Lambda trigger: Yes (用于图片处理)
```

### 3. 推送配置到云端

```bash
# 推送所有配置到 AWS
amplify push

# 这将：
# - 创建 AppSync GraphQL API
# - 创建 S3 存储桶
# - 更新 amplifyconfiguration.json
# - 生成必要的 IAM 角色和策略
```

### 4. 更新 Xcode 项目配置

#### 4.1 确保所有必要的 Swift Package 依赖已添加

在 Xcode 中检查以下包是否已添加：
- `https://github.com/aws-amplify/amplify-swift`
- 包含以下产品：
  - Amplify
  - AWSCognitoAuthPlugin
  - AWSAPIPlugin
  - AWSS3StoragePlugin

#### 4.2 更新 Info.plist 权限

确保 `tart-prototype-Info.plist` 包含：

```xml
<!-- 网络权限 -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>

<!-- 相机权限 -->
<key>NSCameraUsageDescription</key>
<string>This app needs access to camera to take photos for artwork uploads.</string>

<!-- 相册权限 -->
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to photo library to select images for artwork uploads.</string>

<!-- URL Schemes -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.tart.prototype</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>tart</string>
        </array>
    </dict>
</array>
```

### 5. 创建 GraphQL Schema

在 `amplify/backend/api/tartprototype12/schema.graphql` 中添加：

```graphql
type User @model @auth(rules: [{allow: owner}]) {
  id: ID!
  username: String!
  email: String!
  profileImage: String
  bio: String
  createdAt: AWSDateTime!
  updatedAt: AWSDateTime!
  artworks: [Artwork] @hasMany(indexName: "byUser", fields: ["id"])
  comments: [Comment] @hasMany(indexName: "byUser", fields: ["id"])
  lifeUpdates: [LifeUpdate] @hasMany(indexName: "byUser", fields: ["id"])
}

type Artwork @model @auth(rules: [{allow: owner}, {allow: public, operations: [read]}]) {
  id: ID!
  title: String!
  description: String
  imageUrl: String!
  artistId: ID! @index(name: "byUser")
  artist: User! @belongsTo(fields: ["artistId"])
  likes: Int! @default(value: "0")
  createdAt: AWSDateTime!
  updatedAt: AWSDateTime!
  comments: [Comment] @hasMany(indexName: "byArtwork", fields: ["id"])
}

type Comment @model @auth(rules: [{allow: owner}, {allow: public, operations: [read]}]) {
  id: ID!
  content: String!
  userId: ID! @index(name: "byUser")
  user: User! @belongsTo(fields: ["userId"])
  artworkId: ID! @index(name: "byArtwork")
  artwork: Artwork! @belongsTo(fields: ["artworkId"])
  createdAt: AWSDateTime!
  updatedAt: AWSDateTime!
}

type LifeUpdate @model @auth(rules: [{allow: owner}, {allow: public, operations: [read]}]) {
  id: ID!
  content: String!
  imageUrl: String
  userId: ID! @index(name: "byUser")
  user: User! @belongsTo(fields: ["userId"])
  likes: Int! @default(value: "0")
  createdAt: AWSDateTime!
  updatedAt: AWSDateTime!
}
```

### 6. 测试配置

#### 6.1 在 Xcode 中构建项目

```bash
# 确保项目能正常编译
xcodebuild -project tart_prototype.xcodeproj -scheme tart_prototype -destination 'platform=iOS Simulator,name=iPhone 15' build
```

#### 6.2 测试 Amplify 初始化

在 `AmplifyManager` 中添加测试方法：

```swift
#if DEBUG
func testAmplifyConfiguration() {
    print("🧪 Testing Amplify Configuration...")
    
    Task {
        // 测试认证状态
        let isSignedIn = await isUserSignedIn()
        print("Auth Status: \(isSignedIn ? "Signed In" : "Not Signed In")")
        
        // 测试 API 连接
        do {
            let request = GraphQLRequest<String>(document: """
                query ListUsers {
                    listUsers {
                        items {
                            id
                            username
                            email
                        }
                    }
                }
            """)
            
            let result = try await Amplify.API.query(request: request)
            print("API Test: ✅ Success")
        } catch {
            print("API Test: ❌ Failed - \(error)")
        }
    }
}
#endif
```

## 验证清单

- [ ] Amplify CLI 已安装并配置
- [ ] API 服务已添加并推送
- [ ] Storage 服务已添加并推送
- [ ] GraphQL Schema 已定义
- [ ] Swift Package 依赖已正确添加
- [ ] Info.plist 权限已配置
- [ ] amplifyconfiguration.json 已更新
- [ ] 项目能正常编译
- [ ] Amplify 初始化成功
- [ ] API 连接测试通过

## 常见问题解决

### 1. 编译错误：找不到 Amplify 模块
**解决方案**: 确保 Swift Package 正确添加，并选择正确的 target

### 2. 运行时错误：配置文件找不到
**解决方案**: 确保 `amplifyconfiguration.json` 在正确的 Bundle 中

### 3. 认证错误：Cognito 配置问题
**解决方案**: 检查 `amplifyconfiguration.json` 中的 Pool ID 和 Client ID

### 4. API 错误：GraphQL 端点不可达
**解决方案**: 确保 AppSync API 已创建并推送

## 下一步

完成以上配置后，你的 iOS 应用将具备：
- ✅ 用户认证和授权
- ✅ GraphQL API 访问
- ✅ S3 文件存储
- ✅ 实时数据同步
- ✅ 离线数据支持

然后你就可以开始实现具体的业务功能了！ 