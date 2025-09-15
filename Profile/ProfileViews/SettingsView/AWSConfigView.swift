import SwiftUI

struct AWSConfigView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var region = ""
    @State private var bucketName = ""
    @State private var accessKeyId = ""
    @State private var secretAccessKey = ""
    @State private var showPassword = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isTestingConnection = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("AWS S3 配置")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("区域 (Region)")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(.secondary)
                        
                        TextField("例如: us-east-1", text: $region)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("存储桶名称 (Bucket Name)")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(.secondary)
                        
                        TextField("例如: my-app-bucket", text: $bucketName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Section(header: Text("AWS 凭证")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Access Key ID")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(.secondary)
                        
                        TextField("AWS Access Key ID", text: $accessKeyId)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Secret Access Key")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            if showPassword {
                                TextField("AWS Secret Access Key", text: $secretAccessKey)
                            } else {
                                SecureField("AWS Secret Access Key", text: $secretAccessKey)
                            }
                            
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Section(header: Text("操作")) {
                    Button(action: testConnection) {
                        HStack {
                            if isTestingConnection {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(0.8)
                            }
                            
                            Text(isTestingConnection ? "测试连接中..." : "测试连接")
                                .font(AppFont.body.font)
                        }
                    }
                    .disabled(isTestingConnection || !isFormValid)
                    
                    Button(action: saveConfiguration) {
                        Text("保存配置")
                            .font(AppFont.bodyBold.font)
                            .foregroundColor(.blue)
                    }
                    .disabled(!isFormValid)
                }
                
                Section(footer: Text("配置信息将安全存储在设备上。请确保使用有限权限的AWS IAM用户凭证。")) {
                    EmptyView()
                }
            }
            .navigationTitle("AWS S3 配置")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("完成") {
                    saveConfiguration()
                    dismiss()
                }
                .disabled(!isFormValid)
            )
            .onAppear {
                loadCurrentConfiguration()
            }
            .alert("提示", isPresented: $showAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var isFormValid: Bool {
        !region.isEmpty && 
        !bucketName.isEmpty && 
        !accessKeyId.isEmpty && 
        !secretAccessKey.isEmpty
    }
    
    // MARK: - Methods
    
    private func loadCurrentConfiguration() {
        let configManager = AWSConfigManager.shared
        region = configManager.region
        bucketName = configManager.bucketName
        accessKeyId = configManager.accessKeyId
        secretAccessKey = configManager.secretAccessKey
    }
    
    private func saveConfiguration() {
        #if DEBUG
        AWSConfigManager.shared.setDevelopmentConfiguration(
            region: region,
            bucketName: bucketName,
            accessKeyId: accessKeyId,
            secretAccessKey: secretAccessKey
        )
        #else
        // 在生产环境中，建议使用更安全的存储方式，如Keychain
        AWSConfigManager.shared.setConfigValue(region, for: "AWS_REGION")
        AWSConfigManager.shared.setConfigValue(bucketName, for: "S3_BUCKET_NAME")
        AWSConfigManager.shared.setConfigValue(accessKeyId, for: "AWS_ACCESS_KEY_ID")
        AWSConfigManager.shared.setConfigValue(secretAccessKey, for: "AWS_SECRET_ACCESS_KEY")
        #endif
        
        alertMessage = "配置已保存！"
        showAlert = true
    }
    
    private func testConnection() {
        isTestingConnection = true
        
        Task {
            do {
                // 创建测试用的S3服务
                let testConfig = S3Configuration(
                    region: region,
                    bucketName: bucketName,
                    accessKeyId: accessKeyId,
                    secretAccessKey: secretAccessKey,
                    baseURL: "https://\(bucketName).s3.\(region).amazonaws.com"
                )
                
                let s3Service = S3UploadService(configuration: testConfig)
                
                // 创建一个小的测试图片
                let testImage = createTestImage()
                let testKey = "test/connection_test_\(Int(Date().timeIntervalSince1970)).jpg"
                
                // 尝试上传测试图片
                let _ = try await s3Service.uploadImage(testImage, key: testKey)
                
                await MainActor.run {
                    isTestingConnection = false
                    alertMessage = "✅ 连接测试成功！可以正常上传到S3。"
                    showAlert = true
                }
                
            } catch {
                await MainActor.run {
                    isTestingConnection = false
                    alertMessage = "❌ 连接测试失败：\(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
    
    private func createTestImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.blue.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

#Preview {
    AWSConfigView()
} 