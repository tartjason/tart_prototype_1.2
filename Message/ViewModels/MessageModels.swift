import SwiftUI
import UIKit
import PhotosUI

// MARK: - Data Models

/// Represents a preview of a message conversation in the list
struct MessagePreview: Identifiable {
    let id: Int
    let username: String
    let avatar: String
    var lastMessage: String
    var time: String
    var unreadCount: Int = 0
    var isRead: Bool = false
}

/// Represents an individual message in a conversation
struct ChatMessage: Identifiable {
    let id: Int
    let isFromMe: Bool
    let text: String
    let timestamp: Date
    var imageAttachments: [UIImage] = []
}

// MARK: - View Model

class MessageViewModel: ObservableObject {
    // Sample conversations data
    @Published var conversations: [MessagePreview] = [
        MessagePreview(id: 1, username: "SmartKiwi", avatar: "kiwi_avatar", lastMessage: "Hello, I feel sooo bored!", time: "15:43", unreadCount: 1),
        MessagePreview(id: 2, username: "illion", avatar: "illion_avatar", lastMessage: "Hello, Jason. I hope my artwork...", time: "15:43", unreadCount: 1),
        MessagePreview(id: 3, username: "illion", avatar: "illion_avatar", lastMessage: "Hello, Jason. I hope my artwork...", time: "15:43", unreadCount: 2),
        MessagePreview(id: 4, username: "Picklelover", avatar: "pickle_avatar", lastMessage: "Hi Jason. You seem to have good...", time: "15:43", isRead: true)
    ]
    
    // Sample conversation messages
    @Published var chatMessages: [Int: [ChatMessage]] = [
        1: [
            ChatMessage(id: 1, isFromMe: false, text: "Hello, thanks for connecting with me!", timestamp: Date()),
            ChatMessage(id: 2, isFromMe: true, text: "I really enjoyed your work \"Scissor\". I reminded me of my grandpa.", timestamp: Date())
        ]
    ]
    
    /// Mark a conversation as read
    func markAsRead(id: Int) {
        if let index = conversations.firstIndex(where: { $0.id == id }) {
            conversations[index].isRead = true
            conversations[index].unreadCount = 0
        }
    }
    
    /// Send a new message to a conversation
    func sendMessage(to conversationId: Int, text: String, images: [UIImage] = []) {
        // Create new message
        let newMessageId = (chatMessages[conversationId]?.count ?? 0) + 1
        let newMessage = ChatMessage(
            id: newMessageId,
            isFromMe: true,
            text: text,
            timestamp: Date(),
            imageAttachments: images
        )
        
        // Add to messages array
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
    
    /// Get messages for a specific conversation
    func getMessages(for conversationId: Int) -> [ChatMessage] {
        return chatMessages[conversationId] ?? []
    }
    
    /// Format the current time for message timestamps
    private func formatCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}

// MARK: - Image Picker Helper

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            let itemProviders = results.map(\.itemProvider)
            
            for (_, itemProvider) in itemProviders.enumerated() {
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self?.parent.selectedImages.append(image)
                            }
                        }
                    }
                }
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Helper Extensions

extension Color {
    /// Initialize a Color from a hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    /// Apply corner radius to specific corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
