import SwiftUI

// MARK: - UI Component Library
/// A collection of reusable UI components across the app
/// Note: Tab bar components have been moved to AppTabBar.swift

// MARK: - Button Components

/// Standard button with text and optional icon
struct AppButton: View {
    let title: String
    var iconName: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .font(.system(size: 16))
                }
                
                Text(title)
                    .font(AppFont.body.font)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

/// Icon button with background circle
struct CircleIconButton: View {
    let iconName: String
    let backgroundColor: Color
    let foregroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 50, height: 50)
                
                Image(systemName: iconName)
                    .font(.system(size: 20))
                    .foregroundColor(foregroundColor)
            }
        }
    }
}

// MARK: - Text Components

/// Standard header text
struct HeaderText: View {
    let text: String
    var alignment: TextAlignment = .center
    
    var body: some View {
        Text(text)
            .font(AppFont.title.font)
            .multilineTextAlignment(alignment)
    }
}

/// Secondary text style
struct SecondaryText: View {
    let text: String
    var color: Color = .gray
    
    var body: some View {
        Text(text)
            .font(AppFont.subheadline.font)
            .foregroundColor(color)
    }
}

// MARK: - Input Components

/// Standard text input field
struct AppTextField: View {
    let placeholder: String
    @Binding var text: String
    var onCommit: (() -> Void)? = nil
    
    var body: some View {
        TextField(placeholder, text: $text, onCommit: onCommit ?? {})
            .font(AppFont.body.font)
            .padding(12)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
    }
}

/// Message input field with rounded corners
struct MessageInputField: View {
    @Binding var text: String
    var placeholder: String
    var onCommit: () -> Void
    
    var body: some View {
        TextField(placeholder, text: $text, onCommit: onCommit)
            .font(AppFont.body.font)
            .padding(10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(20)
    }
}

// MARK: - Image Components

/// User avatar view
struct AvatarView: View {
    let avatar: String
    let size: CGFloat
    let backgroundColor: Color
    
    init(avatar: String, size: CGFloat = 40, backgroundColor: Color = Color.blue.opacity(0.1)) {
        self.avatar = avatar
        self.size = size
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        Image(avatar)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .background(
                Circle()
                    .fill(backgroundColor)
                    .frame(width: size + 4, height: size + 4)
            )
    }
}

// MARK: - Layout Components

/// Divider with custom padding
struct PaddedDivider: View {
    var leadingPadding: CGFloat = 0
    var trailingPadding: CGFloat = 0
    
    var body: some View {
        Divider()
            .padding(.leading, leadingPadding)
            .padding(.trailing, trailingPadding)
    }
}

/// Container with card-like appearance
struct CardContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Previews
struct ComponentsLibrary_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            AppButton(title: "Press Me", iconName: "star.fill") {}
            
            CircleIconButton(
                iconName: "link",
                backgroundColor: Color.blue.opacity(0.2),
                foregroundColor: .blue,
                action: {}
            )
            
            HeaderText(text: "This is a Header")
            
            SecondaryText(text: "This is secondary text")
            
            AppTextField(placeholder: "Enter text", text: .constant(""))
            
            MessageInputField(
                text: .constant(""),
                placeholder: "Message...",
                onCommit: {}
            )
            
            AvatarView(avatar: "kiwi_avatar", size: 50)
            
            PaddedDivider(leadingPadding: 70)
            
            CardContainer {
                Text("Card Content")
                    .padding()
            }
            .frame(width: 200)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
