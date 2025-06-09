# AWS S3 艺术作品上传设置指南

## 📋 概述

本指南将帮助你配置AWS S3来为Tart艺术平台提供图片上传功能。用户可以上传艺术作品图片和灵感图片到你的S3存储桶。

## 🛠 AWS S3 设置步骤

### 1. 创建S3存储桶

1. 登录到 [AWS管理控制台](https://console.aws.amazon.com/)
2. 导航到S3服务
3. 点击"创建存储桶"
4. 配置存储桶：
   ```
   存储桶名称: tart-app-artworks (或你选择的名称)
   区域: us-east-1 (或你首选的区域)
   ```

### 2. 配置存储桶权限

#### CORS配置
在存储桶的"权限"标签页中，添加CORS配置：

```json
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET",
            "PUT",
            "POST",
            "DELETE"
        ],
        "AllowedOrigins": [
            "*"
        ],
        "ExposeHeaders": [
            "ETag"
        ]
    }
]
```

#### 存储桶策略
添加以下存储桶策略（替换`your-bucket-name`为实际的存储桶名称）：

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::your-bucket-name/*"
        }
    ]
}
```

### 3. 创建IAM用户

#### 创建专用IAM用户
1. 导航到IAM服务
2. 点击"用户" → "添加用户"
3. 配置用户：
   ```
   用户名: tart-app-s3-user
   访问类型: 编程访问 (选中)
   ```

#### 创建IAM策略
创建自定义策略（替换`your-bucket-name`）：

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::your-bucket-name/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::your-bucket-name"
            ]
        }
    ]
}
```

#### 附加策略到用户
1. 选择刚创建的用户
2. 在"权限"标签页中，点击"添加权限"
3. 选择"直接附加现有策略"
4. 选择你创建的自定义策略

### 4. 获取访问密钥

1. 在IAM用户详情页面，点击"安全证书"标签
2. 点击"创建访问密钥"
3. 选择"应用程序在AWS外部运行"
4. 保存以下信息：
   - Access Key ID
   - Secret Access Key

## 📱 iOS应用配置

### 1. 配置AWS凭证

在iOS应用中，有几种方式配置AWS凭证：

#### 方法1: 通过应用内设置界面
1. 在应用中打开"设置" → "AWS配置"
2. 输入以下信息：
   ```
   区域: us-east-1
   存储桶名称: your-bucket-name
   Access Key ID: AKIA...
   Secret Access Key: xxxxx...
   ```
3. 点击"测试连接"验证配置
4. 保存配置

#### 方法2: 通过Info.plist配置
在Info.plist中添加：
```xml
<key>AWS_REGION</key>
<string>us-east-1</string>
<key>S3_BUCKET_NAME</key>
<string>your-bucket-name</string>
<key>AWS_ACCESS_KEY_ID</key>
<string>your-access-key-id</string>
<key>AWS_SECRET_ACCESS_KEY</key>
<string>your-secret-access-key</string>
```

#### 方法3: 通过环境变量（开发时）
```bash
export AWS_REGION=us-east-1
export S3_BUCKET_NAME=your-bucket-name
export AWS_ACCESS_KEY_ID=your-access-key-id
export AWS_SECRET_ACCESS_KEY=your-secret-access-key
```

### 2. 代码使用示例

```swift
// 检查配置状态
#if DEBUG
AWSConfigManager.shared.printConfigurationStatus()
#endif

// 上传图片
let profileModel = ProfileModel()
try await profileModel.uploadArtwork(
    description: "我的艺术作品",
    inspirationDescription: "灵感来源...",
    medium: "油画",
    location: "纽约",
    artworkImage: artworkUIImage,
    inspirationImage: inspirationUIImage
)
```

## 🔒 安全最佳实践

### 1. 最小权限原则
- 只授予必要的S3权限
- 定期轮换访问密钥
- 使用专用的IAM用户，不要使用根账户

### 2. 网络安全
- 启用S3传输加密（HTTPS）
- 考虑使用VPC端点
- 监控访问日志

### 3. 数据保护
- 启用S3默认加密
- 配置生命周期策略管理旧文件
- 设置版本控制（如需要）

### 4. 成本优化
- 使用智能分层存储
- 设置删除不完整的分段上传
- 监控存储使用量

## 📊 存储桶结构

建议的文件夹结构：
```
your-bucket-name/
├── artworks/
│   ├── 1701234567_ABC12345.jpg
│   └── 1701234568_DEF67890.jpg
├── inspirations/
│   ├── 1701234569_GHI13579.jpg
│   └── 1701234570_JKL24680.jpg
└── test/
    └── connection_test_*.jpg
```

## 🚀 上传流程

1. **图片选择**: 用户在应用中选择图片
2. **数据验证**: 验证图片格式和大小
3. **图片压缩**: 自动压缩图片以优化上传速度
4. **生成唯一键**: 使用时间戳和UUID生成唯一文件名
5. **S3上传**: 使用HTTPS PUT请求上传到S3
6. **URL返回**: 返回图片的公共访问URL
7. **数据保存**: 将图片URL保存到艺术作品记录中

## 🔧 故障排除

### 常见错误及解决方案

#### 1. 配置错误
```
错误: S3配置无效
解决: 检查AWS凭证和存储桶名称是否正确
```

#### 2. 权限错误
```
错误: 上传失败 (状态码: 403)
解决: 检查IAM用户权限和存储桶策略
```

#### 3. 网络错误
```
错误: 网络连接错误
解决: 检查网络连接和S3服务状态
```

#### 4. CORS错误
```
错误: CORS policy blocked
解决: 检查S3存储桶的CORS配置
```

## 📞 支持与监控

### 监控设置
1. 启用CloudTrail记录API调用
2. 设置CloudWatch警报监控使用量
3. 配置S3访问日志

### 性能优化
1. 选择距离用户最近的AWS区域
2. 使用CloudFront CDN加速图片访问
3. 启用S3传输加速

## 📝 注意事项

1. **成本控制**: S3按存储量和请求次数收费，请监控使用情况
2. **数据备份**: 考虑启用跨区域复制进行备份
3. **合规性**: 根据你的业务需求配置数据保留策略
4. **扩展性**: 当前实现支持单文件上传，大文件可考虑分段上传

## 🎯 下一步

配置完成后，你的Tart应用就可以：
- ✅ 上传艺术作品图片到S3
- ✅ 上传灵感图片到S3  
- ✅ 跟踪上传进度
- ✅ 处理上传错误
- ✅ 生成公共访问URL
- ✅ 管理草稿和已发布的作品

准备就绪后，用户就可以开始上传和分享他们的艺术作品了！🎨 