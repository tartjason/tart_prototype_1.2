import Foundation
import SwiftUI
import Combine

// 导入模型
//import Models.Artwork
//import Models.Comment

class ArtworkViewModel: ObservableObject {
    @Published var isFavorite: Bool = false
    @Published var showCommentOptions: Bool = false
    @Published var likeCount: Int = 0
    @Published var comments: [Comment] = []
    
    private let artwork: Artwork
    private let homeService: HomeService
    private var cancellables = Set<AnyCancellable>()
    
    init(artwork: Artwork, homeService: HomeService = HomeService()) {
        self.artwork = artwork
        self.homeService = homeService
        
        // 初始化状态
        self.isFavorite = artwork.isSaved
        self.likeCount = artwork.likes
        self.comments = artwork.comments
        
        setupBindings()
    }
    
    private func setupBindings() {
        // 监听 HomeService 中的 artworks 变化
        homeService.$artworks
            .sink { [weak self] (artworks: [Artwork]) in
                if let updatedArtwork = artworks.first(where: { $0.id == self?.artwork.id }) {
                    self?.isFavorite = updatedArtwork.isSaved
                    self?.likeCount = updatedArtwork.likes
                    self?.comments = updatedArtwork.comments
                }
            }
            .store(in: &cancellables)
    }
    
    func toggleFavorite() {
        Task {
            do {
                try await homeService.saveArtwork(artwork)
            } catch {
                print("Error toggling favorite: \(error)")
            }
        }
    }
    
    func toggleCommentOptions() {
        showCommentOptions.toggle()
    }
    
    func addComment(_ content: String) {
        let newComment = Comment(
            id: UUID().uuidString,
            content: content,
            username: "Current User", // 这里应该使用实际的用户名
            createdAt: Date()
        )
        comments.append(newComment)
    }
} 
