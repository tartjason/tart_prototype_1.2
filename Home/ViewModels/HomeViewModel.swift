import Foundation
import SwiftUI
import Combine

// 导入模型
//import Models.Artwork
//import Models.LifeUpdate

class HomeViewModel: ObservableObject {
    @Published var selectedTab: Tab = .art
    @Published var selectedArtwork: Artwork?
    @Published var isInputOverlayVisible: Bool = false
    @Published var showingBackButton: Bool = false
    @Published var selectedAppTab: AppTab = .art
    @Published var inputText: String = ""
    
    let homeService: HomeService
    
    enum Tab {
        case art
        case lifeUpdates
    }
    
    init(homeService: HomeService = HomeService()) {
        self.homeService = homeService
        setupBindings()
    }
    
    private func setupBindings() {
        // 监听 HomeService 的数据变化
        homeService.$artworks
            .sink { [weak self] _ in
                // 可以在这里处理 artworks 变化
            }
            .store(in: &cancellables)
        
        homeService.$lifeUpdates
            .sink { [weak self] _ in
                // 可以在这里处理 lifeUpdates 变化
            }
            .store(in: &cancellables)
    }
    
    func toggleTab(_ tab: Tab) {
        selectedTab = tab
    }
    
    func showInputOverlay() {
        isInputOverlayVisible = true
        showingBackButton = true
    }
    
    func clearInput() {
        isInputOverlayVisible = false
        showingBackButton = false
        inputText = ""
    }
    
    func fetchArtworks() async {
        do {
            try await homeService.fetchArtworks()
        } catch {
            print("Error fetching artworks: \(error)")
        }
    }
    
    func fetchLifeUpdates() async {
        do {
            try await homeService.fetchLifeUpdates()
        } catch {
            print("Error fetching life updates: \(error)")
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
} 
