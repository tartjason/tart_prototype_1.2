#!/usr/bin/env swift

import Foundation
import UIKit

// 简单的S3连接测试脚本
// 使用方法: swift test_s3_connection.swift

print("🔧 AWS S3 连接测试工具")
print("========================\n")

// 检查配置
func checkS3Configuration() {
    print("📋 检查AWS配置...")
    
    let configManager = AWSConfigManager.shared
    
    #if DEBUG
    configManager.printConfigurationStatus()
    #endif
    
    if configManager.validateConfiguration() {
        print("✅ AWS配置验证通过\n")
        return true
    } else {
        print("❌ AWS配置不完整")
        print("请设置以下环境变量或在应用中配置:")
        print("- AWS_REGION")
        print("- S3_BUCKET_NAME") 
        print("- AWS_ACCESS_KEY_ID")
        print("- AWS_SECRET_ACCESS_KEY\n")
        return false
    }
}

// 测试S3连接
func testS3Connection() async {
    print("🔗 测试S3连接...")
    
    do {
        let s3Service = S3UploadService()
        
        // 创建测试图片
        let testImage = createTestImage()
        let testKey = "test/connection_test_\(Int(Date().timeIntervalSince1970)).jpg"
        
        print("📤 正在上传测试图片...")
        
        let response = try await s3Service.uploadImage(testImage, key: testKey)
        
        print("✅ 上传成功!")
        print("   URL: \(response.url)")
        print("   Key: \(response.key)")
        if let etag = response.etag {
            print("   ETag: \(etag)")
        }
        
    } catch {
        print("❌ 上传失败: \(error.localizedDescription)")
    }
}

// 创建测试图片
func createTestImage() -> UIImage {
    let size = CGSize(width: 100, height: 100)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    UIColor.blue.setFill()
    UIRectFill(CGRect(origin: .zero, size: size))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image ?? UIImage()
}

// 主执行函数
func main() async {
    // 检查配置
    guard checkS3Configuration() else {
        exit(1)
    }
    
    // 测试连接
    await testS3Connection()
    
    print("\n🎯 测试完成")
}

// 运行测试
Task {
    await main()
    exit(0)
} 