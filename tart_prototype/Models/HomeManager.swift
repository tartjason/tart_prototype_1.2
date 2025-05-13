import SwiftUI

class HomeManager: ObservableObject {
    @Published var homeService: HomeService
    
    init(homeService: HomeService = HomeService()) {
        self.homeService = homeService
    }
}

// 用于在视图中访问 HomeManager 的便捷属性包装器
@propertyWrapper
struct HomeManagerEnvironment: DynamicProperty {
    @EnvironmentObject private var homeManager: HomeManager
    
    var wrappedValue: HomeManager {
        homeManager
    }
}

// 用于在视图中访问 HomeService 的便捷属性包装器
@propertyWrapper
struct HomeServiceEnvironment: DynamicProperty {
    @EnvironmentObject private var homeManager: HomeManager
    
    var wrappedValue: HomeService {
        homeManager.homeService
    }
} 