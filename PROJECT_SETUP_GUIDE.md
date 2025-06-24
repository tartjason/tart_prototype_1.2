# 项目设置指南

## 问题解决

### 1. Info.plist 文件问题 ✅ 已解决

**问题**: 找不到 Info.plist 文件
**解决方案**: 已创建 `tart-prototype-Info.plist` 文件，包含：
- 基本的应用配置
- URL Schemes (tart://)
- 相机和相册权限
- 网络权限

### 2. amplifyconfiguration.json 文件问题 ✅ 已解决

**问题**: 找不到 amplifyconfiguration.json 文件
**解决方案**: 已创建配置文件，包含：
- AWS Cognito 认证配置
- GraphQL API 配置
- S3 存储配置

### 3. 文件同步问题 ✅ 已解决

**问题**: 很多文件没有同步到 Xcode 项目中
**解决方案**: 通过脚本检查发现所有 63 个 Swift 文件都已正确添加到项目中

## 下一步操作

### 1. 安装完整版 Xcode

由于你当前只有命令行工具，需要安装完整版 Xcode：

1. 从 App Store 下载并安装 Xcode
2. 安装完成后，运行以下命令设置开发者目录：
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   ```

### 2. 在 Xcode 中打开项目

1. 打开 Xcode
2. 选择 "Open a project or file"
3. 导航到项目文件夹，选择 `tart_prototype.xcodeproj`
4. 点击 "Open"

### 3. 验证项目配置

在 Xcode 中：

1. **检查 Info.plist**:
   - 在项目导航器中找到 `tart-prototype-Info.plist`
   - 确认 URL Schemes 配置正确
   - 检查权限设置

2. **检查 amplifyconfiguration.json**:
   - 确认文件在项目中
   - 检查配置是否正确

3. **检查文件结构**:
   - 确认所有模块文件都在正确的位置
   - 检查是否有缺失的引用

### 4. 构建和运行

1. 选择目标设备（模拟器或真机）
2. 点击运行按钮 (⌘+R)
3. 检查是否有编译错误

## 常见问题解决

### 如果仍有文件同步问题

1. **手动添加文件**:
   - 在 Xcode 中右键点击项目
   - 选择 "Add Files to [项目名]"
   - 选择要添加的文件
   - 确保 "Add to target" 已勾选

2. **检查文件引用**:
   - 确保文件在正确的 target 中
   - 检查文件路径是否正确

### 如果 Info.plist 配置有问题

1. **URL Schemes 配置**:
   ```xml
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

2. **权限配置**:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs access to camera to take photos for artwork uploads.</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>This app needs access to photo library to select images for artwork uploads.</string>
   ```

### 如果 amplifyconfiguration.json 配置有问题

1. **更新真实的 AWS 配置**:
   - 替换 PoolId、AppClientId 等为你的真实值
   - 更新 API 端点 URL
   - 更新 S3 存储桶名称

2. **检查区域设置**:
   - 确保所有服务都在同一区域
   - 当前配置为 us-east-2

## 验证清单

- [ ] 完整版 Xcode 已安装
- [ ] 项目能在 Xcode 中正常打开
- [ ] Info.plist 文件存在且配置正确
- [ ] amplifyconfiguration.json 文件存在且配置正确
- [ ] 所有 Swift 文件都在项目中
- [ ] 项目能正常编译
- [ ] 应用能正常启动

## 联系支持

如果遇到其他问题，请提供：
1. 具体的错误信息
2. Xcode 版本
3. iOS 版本
4. 错误发生的具体步骤 