import Foundation
import Combine

// 导入模型
//import Models

enum HomeServiceError: LocalizedError {
    case networkError
    case decodingError
    case storageError
    case invalidData
    case unauthorized
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network error occurred"
        case .decodingError:
            return "Failed to decode data"
        case .storageError:
            return "Failed to save data"
        case .invalidData:
            return "Invalid data provided"
        case .unauthorized:
            return "Unauthorized access"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

class HomeService: ObservableObject {
    @Published var artworks: [Artwork] = []
    @Published var lifeUpdates: [LifeUpdate] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private let storageService: StorageService
    private var cancellables = Set<AnyCancellable>()
    
    init(storageService: StorageService = .shared) {
        self.storageService = storageService
        loadLocalData()
    }
    
    private func loadLocalData() {
        do {
            artworks = try storageService.loadArtworks()
            lifeUpdates = try storageService.loadLifeUpdates()
        } catch {
            self.error = error
        }
    }
    
    func fetchArtworks() async throws {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: 实现实际的网络请求
        // 这里暂时使用模拟数据
        let mockArtworks: [Artwork] = [
            Artwork(
                id: "1",
                imageURL: "https://example.com/art1.jpg",
                title: "Mock Artwork 1",
                artist: "Mock Artist",
                medium: "Oil on Canvas",
                description: "A beautiful mock artwork",
                inspiration: "Nature",
                relatedImages: [],
                location: "Gallery",
                createdAt: Date(),
                likes: 0,
                isLiked: false,
                isSaved: false,
                comments: []
            )
        ]
        
        try await storageService.saveArtworks(mockArtworks)
        artworks = mockArtworks
    }
    
    func fetchLifeUpdates() async throws {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: 实现实际的网络请求
        // 这里暂时使用模拟数据
        let mockUpdates: [LifeUpdate] = [
            LifeUpdate(
                id: "1",
                username: "Mock User",
                content: "A mock life update",
                imageURLs: nil,
                location: nil,
                createdAt: Date(),
                likes: 0,
                isLiked: false,
                comments: []
            )
        ]
        
        try await storageService.saveLifeUpdates(mockUpdates)
        lifeUpdates = mockUpdates
    }
    
    func likeArtwork(_ artwork: Artwork) async throws {
        guard let index = artworks.firstIndex(where: { $0.id == artwork.id }) else {
            throw HomeServiceError.invalidData
        }
        
        var updatedArtwork = artwork
        updatedArtwork.isLiked.toggle()
        updatedArtwork.likes += updatedArtwork.isLiked ? 1 : -1
        
        artworks[index] = updatedArtwork
        try await storageService.saveArtworks(artworks)
    }
    
    func saveArtwork(_ artwork: Artwork) async throws {
        guard let index = artworks.firstIndex(where: { $0.id == artwork.id }) else {
            throw HomeServiceError.invalidData
        }
        
        var updatedArtwork = artwork
        updatedArtwork.isSaved.toggle()
        
        artworks[index] = updatedArtwork
        try await storageService.saveArtworks(artworks)
    }
    
    func likeLifeUpdate(_ update: LifeUpdate) async throws {
        guard let index = lifeUpdates.firstIndex(where: { $0.id == update.id }) else {
            throw HomeServiceError.invalidData
        }
        
        var updatedUpdate = update
        updatedUpdate.isLiked.toggle()
        updatedUpdate.likes += updatedUpdate.isLiked ? 1 : -1
        
        lifeUpdates[index] = updatedUpdate
        try await storageService.saveLifeUpdates(lifeUpdates)
    }
    
    func addComment(to update: LifeUpdate, content: String) async throws {
        guard let index = lifeUpdates.firstIndex(where: { $0.id == update.id }) else {
            throw HomeServiceError.invalidData
        }
        
        let newComment = Comment(
            id: UUID().uuidString,
            content: content,
            username: "Current User", // TODO: 使用实际的用户名
            createdAt: Date()
        )
        
        var updatedUpdate = update
        updatedUpdate.comments.append(newComment)
        
        lifeUpdates[index] = updatedUpdate
        try await storageService.saveLifeUpdates(lifeUpdates)
    }
} 
