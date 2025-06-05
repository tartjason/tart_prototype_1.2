import SwiftUI

struct ChatDetailView: View {
    @ObservedObject var viewModel: MessageViewModel
    let conversationId: Int
    @State private var messageText = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker = false
    
    var messages: [ChatMessage] {
        viewModel.getMessages(for: conversationId)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Input Area
            VStack(spacing: 0) {
                // Selected Images Preview
                if !selectedImages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(selectedImages.indices, id: \.self) { index in
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(
                                        Button(action: {
                                            selectedImages.remove(at: index)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                        }
                                        .padding(4),
                                        alignment: .topTrailing
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 80)
                }
                
                HStack(spacing: 12) {
                    // Image Picker Button
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                    
                    // Text Input
                    TextField("Message", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 8)
                    
                    // Send Button
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                    }
                    .disabled(messageText.isEmpty && selectedImages.isEmpty)
                }
                .padding()
                .background(Color(.systemBackground))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.systemGray4)),
                    alignment: .top
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showImagePicker) {
            CustomImagePickerSheet(isPresented: $showImagePicker, selectedImages: $selectedImages)
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty || !selectedImages.isEmpty else { return }
        
        Task {
            await viewModel.sendMessage(messageText, images: selectedImages, to: conversationId)
            messageText = ""
            selectedImages = []
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromMe {
                Spacer()
            }
            
            VStack(alignment: message.isFromMe ? .trailing : .leading, spacing: 4) {
                // Message Text
                if !message.text.isEmpty {
                    Text(message.text)
                        .font(AppFont.body.font)
                        .padding(12)
                        .background(message.isFromMe ? Color.blue : Color(.systemGray5))
                        .foregroundColor(message.isFromMe ? .white : .primary)
                        .cornerRadius(16)
                }
                
                // Image Attachments
                if !message.imageAttachments.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(message.imageAttachments.indices, id: \.self) { index in
                                Image(uiImage: message.imageAttachments[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
                
                // Time
                Text(formatTime(message.timestamp))
                    .font(AppFont.caption.font)
                    .foregroundColor(.gray)
            }
            
            if !message.isFromMe {
                Spacer()
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MessageViewModel()
        let conversation = viewModel.conversations[0]
        ChatDetailView(viewModel: viewModel, conversationId: conversation.id)
    }
}
