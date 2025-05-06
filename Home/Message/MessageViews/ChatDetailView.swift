import SwiftUI

struct ChatDetailView: View {
    @ObservedObject var viewModel: MessageViewModel
    let conversation: MessagePreview
    @State private var messageText: String = ""
    @State private var showImagePicker: Bool = false
    @State private var showPhotoLibraryPicker: Bool = false
    @State private var selectedImages: [UIImage] = []
    @State private var isInVoiceMessageMode: Bool = false
    @State private var isRecordingAudio: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    private var messages: [ChatMessage] {
        viewModel.getMessages(for: conversation.id)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Header with properly centered profile info
                HStack(alignment: .center, spacing: 0) {
                    // Back button on the left
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 16)
                    .frame(width: 60, alignment: .leading)
                    
                    // Center profile info - takes up remaining space symmetrically
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
                    .frame(maxWidth: .infinity)
                    
                    // Empty space on the right to balance the back button
                    Spacer()
                        .frame(width: 60)
                }
                .frame(height: 80)
                
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
                    
                    // Voice message mode or text input mode
                    if isInVoiceMessageMode {
                        // "Press to talk" field
                        Text(isRecordingAudio ? "Recording..." : "Press to talk")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(isRecordingAudio ? Color.red : Color.blue)
                            .cornerRadius(20)
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        isRecordingAudio = true
                                    }
                                    .onEnded { _ in
                                        isRecordingAudio = false
                                        // Here you would handle the end of recording
                                    }
                            )
                        
                        // X button to cancel voice mode
                        Button(action: {
                            isInVoiceMessageMode = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                    } else {
                        // Normal text field
                        TextField("Message...", text: $messageText)
                            .padding(10)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(20)
                    }
                    
                    // Microphone button - toggles voice message mode
                    Button(action: {
                        isInVoiceMessageMode.toggle()
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
