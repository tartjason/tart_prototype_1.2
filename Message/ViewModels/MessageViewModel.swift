import SwiftUI
import UIKit

class MessageViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var conversations: [MessagePreview] = []
    @Published var chatMessages: [Int: [ChatMessage]] = [:]
    @Published var settings: MessageSettings
    @Published var statistics: MessageStatistics?
    
    // MARK: - Services
    private let messageService: MessageService
    private let searchService: MessageSearchService
    private let cache: MessageCache
    private let syncService: MessageSyncService
    private let analytics: MessageAnalytics
    private let settingsManager: MessageSettingsManager
    
    // MARK: - Initialization
    init() {
        self.messageService = MessageService()
        self.searchService = MessageSearchService()
        self.cache = MessageCache()
        self.syncService = MessageSyncService()
        self.analytics = MessageAnalytics()
        self.settingsManager = MessageSettingsManager()
        self.settings = settingsManager.getCurrentSettings()
        
        // Load initial data
        Task {
            await loadInitialData()
        }
    }
    
    // MARK: - Public Methods
    func loadInitialData() async {
        do {
            // Fetch conversations
            let fetchedConversations = try await messageService.fetchConversations()
            await MainActor.run {
                self.conversations = fetchedConversations
            }
            
            // Load settings
            let currentSettings = settingsManager.getCurrentSettings()
            await MainActor.run {
                self.settings = currentSettings
            }
            
            // Load statistics
            let stats = try await analytics.getStatistics()
            await MainActor.run {
                self.statistics = stats
            }
        } catch {
            print("Error loading initial data: \(error)")
        }
    }
    
    func sendMessage(_ text: String, images: [UIImage] = [], to conversationId: Int) async {
        let newMessage = ChatMessage(
            id: (chatMessages[conversationId]?.count ?? 0) + 1,
            isFromMe: true,
            text: text,
            timestamp: Date(),
            imageAttachments: images
        )
        
        do {
            try await messageService.sendMessage(newMessage, to: conversationId)
            
            await MainActor.run {
                if chatMessages[conversationId] != nil {
                    chatMessages[conversationId]?.append(newMessage)
                } else {
                    chatMessages[conversationId] = [newMessage]
                }
                
                // Update conversation preview
                if let index = conversations.firstIndex(where: { $0.id == conversationId }) {
                    conversations[index].lastMessage = text
                    conversations[index].time = formatCurrentTime()
                }
            }
            
            // Cache the updated messages
            cache.cacheMessages(chatMessages[conversationId] ?? [], for: conversationId)
            
            // Track the event
            analytics.trackMessageEvent(MessageEvent.messageSent)
        } catch {
            print("Error sending message: \(error)")
        }
    }
    
    func markAsRead(id: Int) {
        Task {
            do {
                try await messageService.markConversationAsRead(id)
                
                await MainActor.run {
                    if let index = conversations.firstIndex(where: { $0.id == id }) {
                        conversations[index].isRead = true
                        conversations[index].unreadCount = 0
                    }
                }
            } catch {
                print("Error marking conversation as read: \(error)")
            }
        }
    }
    
    func searchMessages(query: String) async throws -> [MessageSearchResult] {
        return try await searchService.searchMessages(query: query)
    }
    
    func updateSettings(_ newSettings: MessageSettings) async {
        do {
            try await settingsManager.updateSettings(newSettings)
            await MainActor.run {
                self.settings = newSettings
            }
        } catch {
            print("Error updating settings: \(error)")
        }
    }
    
    // MARK: - Private Methods
    private func formatCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}

// MARK: - Message Event
struct MessageEvent {
    static let messageSent = "message_sent"
    static let messageReceived = "message_received"
    static let messageRead = "message_read"
    static let conversationOpened = "conversation_opened"
    static let searchPerformed = "search_performed"
}

// MARK: - Message Report
struct MessageReport {
    let date: Date
    let totalMessages: Int
    let activeUsers: Int
    let averageResponseTime: TimeInterval
    let mostActiveHours: [Int]
    let messageTypes: [MessageType: Int]
} 