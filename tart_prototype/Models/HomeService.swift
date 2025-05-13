import Foundation
import Combine

class HomeService: ObservableObject {
    @Published var artworks: [Artwork] = []
    @Published var lifeUpdates: [LifeUpdate] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var currentPage: Int = 1
    private var hasMoreArtworks: Bool = true
    private var hasMoreUpdates: Bool = true
    
    // 获取艺术作品
    func fetchArtworks(page: Int = 1, limit: Int = 10) async throws {
        guard hasMoreArtworks else { return }
        
        await MainActor.run { isLoading = true }
        
        // 这里应该是实际的 API 调用
        // 为了演示，我们使用模拟数据
        let request = ArtworkRequest(
            page: page,
            limit: limit,
            sortBy: .latest,
            filterBy: nil
        )
        
        // 模拟网络延迟
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // 模拟数据
        let mockArtworks = [
            Artwork(
                id: UUID().uuidString,
                title: "Apple",
                artist: "Sai",
                medium: "Colored pencil",
                description: "A crisp apple, captured in vivid color, reflecting the essence of autumn.",
                inspiration: "I was inspired by the simple beauty of seasonal fruits.",
                imageURL: "apple",
                relatedImages: ["apple-sketch-1", "apple-sketch-2"],
                location: "Tokyo",
                createdAt: Date(),
                likes: 42,
                comments: [],
                tags: ["fruit", "autumn", "pencil"],
                isLiked: false,
                isSaved: false
            ),
            // 可以添加更多模拟数据
        ]
        
        await MainActor.run {
            if page == 1 {
                self.artworks = mockArtworks
            } else {
                self.artworks.append(contentsOf: mockArtworks)
            }
            self.currentPage = page
            self.hasMoreArtworks = mockArtworks.count == limit
            self.isLoading = false
        }
    }
    
    // 获取生活更新
    func fetchLifeUpdates(page: Int = 1, limit: Int = 10) async throws {
        guard hasMoreUpdates else { return }
        
        await MainActor.run { isLoading = true }
        
        // 这里应该是实际的 API 调用
        let request = LifeUpdateRequest(
            page: page,
            limit: limit,
            userId: nil,
            includeImages: true
        )
        
        // 模拟网络延迟
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // 模拟数据
        let mockUpdates = [
            LifeUpdate(
                id: UUID().uuidString,
                userId: "user1",
                username: "Vicky",
                content: "Michelin is a scheme.\nLife is a scheme.",
                createdAt: Date(),
                imageURLs: nil,
                likes: 15,
                comments: [],
                location: "Shanghai",
                tags: ["food", "life"],
                isLiked: false,
                isSaved: false
            ),
            // 可以添加更多模拟数据
        ]
        
        await MainActor.run {
            if page == 1 {
                self.lifeUpdates = mockUpdates
            } else {
                self.lifeUpdates.append(contentsOf: mockUpdates)
            }
            self.hasMoreUpdates = mockUpdates.count == limit
            self.isLoading = false
        }
    }
    
    // 点赞艺术作品
    func likeArtwork(_ artwork: Artwork) async throws {
        // 这里应该是实际的 API 调用
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            if let index = artworks.firstIndex(where: { $0.id == artwork.id }) {
                var updatedArtwork = artwork
                updatedArtwork.isLiked.toggle()
                updatedArtwork.likes += updatedArtwork.isLiked ? 1 : -1
                artworks[index] = updatedArtwork
            }
        }
    }
    
    // 点赞生活更新
    func likeLifeUpdate(_ update: LifeUpdate) async throws {
        // 这里应该是实际的 API 调用
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            if let index = lifeUpdates.firstIndex(where: { $0.id == update.id }) {
                var updatedUpdate = update
                updatedUpdate.isLiked.toggle()
                updatedUpdate.likes += updatedUpdate.isLiked ? 1 : -1
                lifeUpdates[index] = updatedUpdate
            }
        }
    }
    
    // 保存艺术作品
    func saveArtwork(_ artwork: Artwork) async throws {
        // 这里应该是实际的 API 调用
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            if let index = artworks.firstIndex(where: { $0.id == artwork.id }) {
                var updatedArtwork = artwork
                updatedArtwork.isSaved.toggle()
                artworks[index] = updatedArtwork
            }
        }
    }
    
    // 保存生活更新
    func saveLifeUpdate(_ update: LifeUpdate) async throws {
        // 这里应该是实际的 API 调用
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            if let index = lifeUpdates.firstIndex(where: { $0.id == update.id }) {
                var updatedUpdate = update
                updatedUpdate.isSaved.toggle()
                lifeUpdates[index] = updatedUpdate
            }
        }
    }
} 