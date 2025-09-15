import Foundation

// MARK: - AWS Configuration Manager

class AWSConfigManager {
    static let shared = AWSConfigManager()
    
    private init() {}
    
    // MARK: - Configuration Properties
    
    /// AWS区域
    var region: String {
        return getConfigValue(for: "AWS_REGION") ?? "us-east-1"
    }
    
    /// S3存储桶名称
    var bucketName: String {
        return getConfigValue(for: "S3_BUCKET_NAME") ?? "tart-app-artworks"
    }
    
    /// AWS Access Key ID
    var accessKeyId: String {
        return getConfigValue(for: "AWS_ACCESS_KEY_ID") ?? ""
    }
    
    /// AWS Secret Access Key
    var secretAccessKey: String {
        return getConfigValue(for: "AWS_SECRET_ACCESS_KEY") ?? ""
    }
    
    /// S3 Base URL
    var s3BaseURL: String {
        return "https://\(bucketName).s3.\(region).amazonaws.com"
    }
    
    // MARK: - Configuration Methods
    
    /// 获取S3配置
    func getS3Configuration() -> S3Configuration {
        return S3Configuration(
            region: region,
            bucketName: bucketName,
            accessKeyId: accessKeyId,
            secretAccessKey: secretAccessKey,
            baseURL: s3BaseURL
        )
    }
    
    /// 验证配置是否完整
    func validateConfiguration() -> Bool {
        return !accessKeyId.isEmpty && 
               !secretAccessKey.isEmpty && 
               !bucketName.isEmpty && 
               !region.isEmpty
    }
    
    // MARK: - Private Methods
    
    /// 从多个来源获取配置值
    /// 优先级：Info.plist > 环境变量 > UserDefaults
    private func getConfigValue(for key: String) -> String? {
        // 1. 尝试从Info.plist获取
        if let value = Bundle.main.object(forInfoDictionaryKey: key) as? String, !value.isEmpty {
            return value
        }
        
        // 2. 尝试从环境变量获取（开发时）
        if let value = ProcessInfo.processInfo.environment[key], !value.isEmpty {
            return value
        }
        
        // 3. 尝试从UserDefaults获取（本地配置）
        let userDefaultsValue = UserDefaults.standard.string(forKey: key)
        if let value = userDefaultsValue, !value.isEmpty {
            return value
        }
        
        return nil
    }
    
    /// 设置配置值到UserDefaults（用于开发和测试）
    func setConfigValue(_ value: String, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    /// 清除所有配置
    func clearConfiguration() {
        let keys = ["AWS_REGION", "S3_BUCKET_NAME", "AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}

// MARK: - Development Configuration Helper

#if DEBUG
extension AWSConfigManager {
    /// 设置开发环境配置（仅用于开发和测试）
    func setDevelopmentConfiguration(
        region: String = "us-east-1",
        bucketName: String,
        accessKeyId: String,
        secretAccessKey: String
    ) {
        setConfigValue(region, for: "AWS_REGION")
        setConfigValue(bucketName, for: "S3_BUCKET_NAME")
        setConfigValue(accessKeyId, for: "AWS_ACCESS_KEY_ID")
        setConfigValue(secretAccessKey, for: "AWS_SECRET_ACCESS_KEY")
    }
    
    /// 打印当前配置状态（不显示敏感信息）
    func printConfigurationStatus() {
        print("=== AWS Configuration Status ===")
        print("Region: \(region)")
        print("Bucket: \(bucketName)")
        print("Access Key ID: \(accessKeyId.isEmpty ? "❌ Not Set" : "✅ Set (\(accessKeyId.prefix(4))...)")")
        print("Secret Key: \(secretAccessKey.isEmpty ? "❌ Not Set" : "✅ Set")")
        print("Base URL: \(s3BaseURL)")
        print("Valid Configuration: \(validateConfiguration() ? "✅" : "❌")")
        print("================================")
    }
}
#endif 