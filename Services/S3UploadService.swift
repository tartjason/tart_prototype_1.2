import Foundation
import UIKit
import Combine

// MARK: - S3 Configuration

struct S3Configuration {
    let region: String
    let bucketName: String
    let accessKeyId: String
    let secretAccessKey: String
    let baseURL: String
    
    static var `default`: S3Configuration {
        return AWSConfigManager.shared.getS3Configuration()
    }
}

// MARK: - S3 Upload Errors

enum S3UploadError: LocalizedError {
    case invalidConfiguration
    case invalidImageData
    case networkError(Error)
    case authenticationFailed
    case uploadFailed(statusCode: Int, message: String)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidConfiguration:
            return "S3配置无效"
        case .invalidImageData:
            return "图片数据无效"
        case .networkError(let error):
            return "网络错误: \(error.localizedDescription)"
        case .authenticationFailed:
            return "AWS认证失败"
        case .uploadFailed(let statusCode, let message):
            return "上传失败 (状态码: \(statusCode)): \(message)"
        case .invalidResponse:
            return "服务器响应无效"
        }
    }
}

// MARK: - Upload Progress Model

struct UploadProgress {
    let bytesUploaded: Int64
    let totalBytes: Int64
    let percentage: Double
    
    init(bytesUploaded: Int64, totalBytes: Int64) {
        self.bytesUploaded = bytesUploaded
        self.totalBytes = totalBytes
        self.percentage = totalBytes > 0 ? Double(bytesUploaded) / Double(totalBytes) : 0
    }
}

// MARK: - S3 Upload Response

struct S3UploadResponse {
    let url: String
    let key: String
    let etag: String?
}

// MARK: - S3 Upload Service

class S3UploadService: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    private let configuration: S3Configuration
    private let session: URLSession
    private let jsonDecoder = JSONDecoder()
    
    @Published var uploadProgress: UploadProgress?
    @Published var isUploading: Bool = false
    
    // MARK: - Initialization
    
    init(configuration: S3Configuration? = nil) {
        self.configuration = configuration ?? AWSConfigManager.shared.getS3Configuration()
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 300
        self.session = URLSession(configuration: config)
        
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// 上传单个图片到S3
    /// - Parameters:
    ///   - image: 要上传的图片
    ///   - key: S3对象键（文件路径）
    ///   - contentType: 内容类型，默认为image/jpeg
    /// - Returns: 上传结果，包含URL和其他信息
    func uploadImage(
        _ image: UIImage,
        key: String,
        contentType: String = "image/jpeg",
        compressionQuality: CGFloat = 0.8
    ) async throws -> S3UploadResponse {
        
        // 验证配置
        guard !configuration.accessKeyId.isEmpty,
              !configuration.secretAccessKey.isEmpty,
              !configuration.bucketName.isEmpty else {
            throw S3UploadError.invalidConfiguration
        }
        
        // 压缩图片
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            throw S3UploadError.invalidImageData
        }
        
        return try await uploadData(imageData, key: key, contentType: contentType)
    }
    
    /// 上传数据到S3
    /// - Parameters:
    ///   - data: 要上传的数据
    ///   - key: S3对象键
    ///   - contentType: 内容类型
    /// - Returns: 上传结果
    func uploadData(
        _ data: Data,
        key: String,
        contentType: String
    ) async throws -> S3UploadResponse {
        
        await MainActor.run {
            isUploading = true
            uploadProgress = UploadProgress(bytesUploaded: 0, totalBytes: Int64(data.count))
        }
        
        defer {
            Task { @MainActor in
                isUploading = false
                uploadProgress = nil
            }
        }
        
        do {
            // 创建S3 PUT请求
            let request = try createS3PutRequest(for: key, data: data, contentType: contentType)
            
            // 执行上传
            let (responseData, response) = try await performUpload(request: request, data: data)
            
            // 处理响应
            return try processUploadResponse(response: response, data: responseData, key: key)
            
        } catch let error as S3UploadError {
            throw error
        } catch {
            throw S3UploadError.networkError(error)
        }
    }
    
    // MARK: - Private Methods
    
    /// 创建S3 PUT请求
    private func createS3PutRequest(for key: String, data: Data, contentType: String) throws -> URLRequest {
        let url = URL(string: "\(configuration.baseURL)/\(key)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        
        // 添加AWS认证头
        let authHeaders = try createAWSAuthHeaders(
            method: "PUT",
            url: url,
            contentType: contentType,
            contentLength: data.count
        )
        
        for (key, value) in authHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    /// 创建AWS认证头
    private func createAWSAuthHeaders(
        method: String,
        url: URL,
        contentType: String,
        contentLength: Int
    ) throws -> [String: String] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let timestamp = dateFormatter.string(from: Date())
        let resource = "/\(configuration.bucketName)\(url.path)"
        
        // 创建签名字符串
        let stringToSign = """
        \(method)

        \(contentType)
        \(timestamp)
        \(resource)
        """
        
        // 使用HMAC-SHA1签名
        let signature = try hmacSHA1(key: configuration.secretAccessKey, message: stringToSign)
        let authorization = "AWS \(configuration.accessKeyId):\(signature)"
        
        return [
            "Date": timestamp,
            "Authorization": authorization
        ]
    }
    
    /// HMAC-SHA1签名
    private func hmacSHA1(key: String, message: String) throws -> String {
        guard let keyData = key.data(using: .utf8),
              let messageData = message.data(using: .utf8) else {
            throw S3UploadError.authenticationFailed
        }
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyData.withUnsafeBytes { $0.baseAddress }, keyData.count, messageData.withUnsafeBytes { $0.baseAddress }, messageData.count, &digest)
        
        return Data(digest).base64EncodedString()
    }
    
    /// 执行上传并跟踪进度
    private func performUpload(request: URLRequest, data: Data) async throws -> (Data, URLResponse) {
        
        return try await withCheckedThrowingContinuation { continuation in
            let task = session.uploadTask(with: request, from: data) { [weak self] data, response, error in
                if let error = error {
                    continuation.resume(throwing: S3UploadError.networkError(error))
                    return
                }
                
                guard let data = data, let response = response else {
                    continuation.resume(throwing: S3UploadError.invalidResponse)
                    return
                }
                
                continuation.resume(returning: (data, response))
            }
            
            // 开始上传任务
            task.resume()
        }
    }
    
    /// 处理上传响应
    private func processUploadResponse(
        response: URLResponse,
        data: Data,
        key: String
    ) throws -> S3UploadResponse {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw S3UploadError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw S3UploadError.uploadFailed(statusCode: httpResponse.statusCode, message: message)
        }
        
        let etag = httpResponse.allHeaderFields["ETag"] as? String
        let url = "\(configuration.baseURL)/\(key)"
        
        return S3UploadResponse(url: url, key: key, etag: etag)
    }
    
    /// 生成唯一的文件键
    static func generateUniqueKey(for type: ImageUploadType, fileExtension: String = "jpg") -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let uuid = UUID().uuidString.prefix(8)
        let folder = type == .artwork ? "artworks" : "inspirations"
        return "\(folder)/\(timestamp)_\(uuid).\(fileExtension)"
    }
}

// MARK: - CommonCrypto Import

import CommonCrypto 