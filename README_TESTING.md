# 📋 Tart App 测试指南

## 🧪 单元测试

### 运行方式
```bash
# 在Xcode中
Product → Test (⌘U)

# 或命令行
xcodebuild test -project tart_prototype.xcodeproj -scheme tart_prototype -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest'
```

### 测试覆盖
- **LoginModelTests** (19个测试)
  - 邮箱格式验证
  - 登录功能（Email/Google/Apple/Facebook）
  - 注册功能（Email/Google/Apple）
  - OTP验证（有效/无效格式）
  - 状态管理（loading/error/success）
  - 用户数据持久化

## 📱 UI测试清单

### 登录流程测试
- [ ] **Welcome页面**
  - [ ] "Register"按钮跳转到注册页
  - [ ] "Continue as Guest"按钮功能
  - [ ] 页面布局正确显示

- [ ] **Register页面**
  - [ ] Google注册按钮响应
  - [ ] Apple注册按钮响应
  - [ ] 邮箱/用户名输入验证
  - [ ] "Create Account"按钮功能
  - [ ] "Already have an account?"链接跳转

- [ ] **Login页面**
  - [ ] 邮箱格式验证提示
  - [ ] 社交登录按钮响应
  - [ ] "Remember Me"选项
  - [ ] 错误提示显示

- [ ] **VerifyEmail页面**
  - [ ] OTP输入框功能
  - [ ] "Verify"按钮状态变化
  - [ ] "Resend Code"功能
  - [ ] 倒计时显示

### 主界面测试
- [ ] **Home页面**
  - [ ] 作品网格显示
  - [ ] 生活动态加载
  - [ ] 刷新功能

- [ ] **Collection页面**
  - [ ] 收藏作品显示
  - [ ] 个人资料对齐

- [ ] **Profile页面**
  - [ ] 生活动态卡片布局
  - [ ] 空状态显示
  - [ ] 交互按钮功能

## 🔧 API集成测试

### 测试环境配置
1. 设置后端服务器
2. 更新 `NetworkConfig` 中的 `baseURL`
3. 修改 `LoginModel.isDevelopmentMode = false`

### API端点测试
- [ ] `POST /auth/register` - 用户注册
- [ ] `POST /auth/login` - 用户登录
- [ ] `POST /auth/send-otp` - 发送验证码
- [ ] `POST /auth/verify-otp` - 验证OTP
- [ ] `GET /auth/validate` - Token验证
- [ ] `POST /auth/refresh` - 刷新Token

### 错误场景测试
- [ ] 网络连接失败
- [ ] 服务器错误 (500)
- [ ] 认证失败 (401)
- [ ] 用户已存在 (409)
- [ ] 请求超时

## 📊 性能测试

### 内存使用
- [ ] 登录过程内存占用
- [ ] 图片加载内存管理
- [ ] 页面切换内存释放

### 响应时间
- [ ] 登录响应时间 < 3秒
- [ ] 页面跳转 < 1秒
- [ ] 图片加载优化

## 🐛 已知问题

### 已修复
- ✅ OTP验证只检查长度不检查格式
- ✅ Profile页面生活动态布局问题
- ✅ Collection页面对齐问题

### 待修复
- [ ] 网络错误重试机制
- [ ] 离线模式支持
- [ ] 社交登录真实集成

## 📝 测试报告模板

### 测试结果记录
```
测试日期: ___________
测试环境: ___________
测试版本: ___________

单元测试通过率: ___/19
UI测试通过率: ___/___
API测试通过率: ___/___

发现问题:
1. _________________
2. _________________
3. _________________
``` 