import SwiftUI

struct InputOverlay: View {
    @Binding var isVisible: Bool
    @Binding var inputText: String
    @Binding var showBackButton: Bool
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    // Dismiss overlay when tapping outside
                    withAnimation {
                        isVisible = false
                    }
                }
            
            // Input card
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Type Anything...")
                        .font(AppFont.body.font)
                        .padding(.top, 8)
                    
                    TextField("How you are feeling? Artists you look for?", text: $inputText)
                        .font(AppFont.body.font)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            if !inputText.isEmpty {
                                withAnimation {
                                    isVisible = false
                                    showBackButton = true
                                }
                            }
                        }) {
                            Image(systemName: "arrow.turn.up.right")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                                .padding(8)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10)
                .padding(.horizontal, 20)
            }
        }
    }
}

struct InputOverlay_Previews: PreviewProvider {
    static var previews: some View {
        @State var isVisible = true
        @State var inputText = ""
        @State var showBackButton = false
        
        return InputOverlay(
            isVisible: $isVisible,
            inputText: $inputText,
            showBackButton: $showBackButton
        )
    }
}
