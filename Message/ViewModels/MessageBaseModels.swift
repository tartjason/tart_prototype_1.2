import SwiftUI
import UIKit

// MARK: - Message Types
enum MessageType {
    case text(String)
    case image([UIImage])
    case voice(URL)
    case location(latitude: Double, longitude: Double)
    case file(URL)
}

enum MessageStatus {
    case sending
    case sent
    case delivered
    case read
    case failed
}

// MARK: - Base Models
struct MessagePreview: Identifiable {
    let id: Int
    let username: String
    let avatar: String
    var lastMessage: String
    var time: String
    var unreadCount: Int = 0
    var isRead: Bool = false
}

struct ChatMessage: Identifiable {
    let id: Int
    let isFromMe: Bool
    let text: String
    let timestamp: Date
    var imageAttachments: [UIImage] = []
    var status: MessageStatus = .sent
    var type: MessageType = .text("")
}

struct MessageMetadata {
    let messageId: String
    let status: MessageStatus
    let sentAt: Date
    let deliveredAt: Date?
    let readAt: Date?
    let error: Error?
}

struct MessageContent {
    let type: MessageType
    let metadata: MessageMetadata
    let replyTo: ChatMessage?
    let forwardFrom: ChatMessage?
}

// MARK: - Notification Models
struct MessageNotification {
    let id: String
    let type: NotificationType
    let message: String
    let timestamp: Date
    let isRead: Bool
    
    enum NotificationType {
        case newMessage
        case messageRead
        case typing
        case online
    }
}

// MARK: - Group Models
struct MessageGroup {
    let id: String
    let name: String
    let participants: [User]
    let avatar: String?
    let lastMessage: ChatMessage?
    let unreadCount: Int
    let isMuted: Bool
}

struct GroupSettings {
    var name: String
    var avatar: String?
    var isMuted: Bool
    var allowInvites: Bool
    var allowMessageEditing: Bool
    var allowMessageDeletion: Bool
} 