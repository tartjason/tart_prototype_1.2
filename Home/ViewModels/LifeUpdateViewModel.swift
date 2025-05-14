import Foundation
import SwiftUI
import Combine

// 导入模型
//import Models.LifeUpdate
//import Models.Comment

class LifeUpdateViewModel: ObservableObject {
    @Published var showCommentOptions: Bool = false
    @Published var comments: [Comment] = []
    @Published var isLiked: Bool = false
    @Published var likeCount: Int = 0
    
    private let update: LifeUpdate
    private let homeService: HomeService
    private var cancellables = Set<AnyCancellable>()
    
    init(update: LifeUpdate, homeService: HomeService = HomeService()) {
        self.update = update
        self.homeService = homeService
        
        // 初始化状态
        self.isLiked = update.isLiked
        self.likeCount = update.likes
        self.comments = update.comments
        
        setupBindings()
    }
    
    private func setupBindings() {
        // 监听 HomeService 中的 lifeUpdates 变化
        homeService.$lifeUpdates
            .sink { [weak self] updates in
                if let updatedUpdate = updates.first(where: { $0.id == self?.update.id }) {
                    self?.isLiked = updatedUpdate.isLiked
                    self?.likeCount = updatedUpdate.likes
                    self?.comments = updatedUpdate.comments
                }
            }
            .store(in: &cancellables)
    }
    
    func toggleLike() {
        Task {
            do {
                try await homeService.likeLifeUpdate(update)
            } catch {
                print("Error toggling like: \(error)")
            }
        }
    }
    
    func toggleCommentOptions() {
        showCommentOptions.toggle()
    }
    
    func addComment(_ content: String) {
        Task {
            do {
                try await homeService.addComment(to: update, content: content)
            } catch {
                print("Error adding comment: \(error)")
            }
        }
    }
} 
