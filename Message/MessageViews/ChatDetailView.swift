import SwiftUI

struct ChatDetailView: View {
    @ObservedObject var viewModel: MessageViewModel
    let conversation: MessagePreview
    @State private var messageText: String = ""
    @State private var showImagePicker: Bool = false
    @State private var showPhotoLibraryPicker: Bool = false
    @State private var selectedImages: [UIImage] = []
    @Environment(\.presentationMode) var presentationMode
    
    private var messages: [ChatMessage] {
        viewModel.getMessages(for: conversation.id)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Image(conversation.avatar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .background(
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 44, height: 44)
                            )
                        
                        Text("You connected with \(conversation.username) on Sep 2, 2023")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            // View profile action
                        }) {
                            Text("View Profile")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.bottom, 16)
                
                // Chat messages
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messages) { message in
                            ChatBubbleView(message: message)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                
                // Input area
                HStack(spacing: 8) {
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
                        Image(systemName: "camera")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 8)
                    
                    TextField("Message...", text: $messageText)
                        .padding(10)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(20)
                    
                    Button(action: {
                        // Send voice message
                    }) {
                        Image(systemName: "mic")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        showPhotoLibraryPicker.toggle()
                    }) {
                        Image(systemName: "photo")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .background(Color.white)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Mark messages as read when conversation is opened
            viewModel.markAsRead(id: conversation.id)
        }
        // Camera picker (same as original)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImages: $selectedImages)
        }
        // Photo library picker (replaces color picker)
        .sheet(isPresented: $showPhotoLibraryPicker) {
            ImagePicker(selectedImages: $selectedImages)
        }
    }
}

// MARK: - Message Bubble View
struct ChatBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if message.isFromMe {
                Spacer()
                Text(message.text)
                    .padding(12)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.leading, 60)
            } else {
                Text(message.text)
                    .padding(12)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(16)
                    .padding(.trailing, 60)
                Spacer()
            }
        }
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MessageViewModel()
        let conversation = viewModel.conversations[0]
        ChatDetailView(viewModel: viewModel, conversation: conversation)
    }
}
