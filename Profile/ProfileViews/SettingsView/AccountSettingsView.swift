import SwiftUI

struct AccountSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                
                Text("Account Settings")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.leading)
                
                Spacer()
            }
            .padding()
            
            // Account Settings List
            ScrollView {
                VStack(spacing: 0) {
                    AccountSettingsRow(
                        title: "Mobile",
                        value: "+86 136****1832"
                    ) {
                        // Handle mobile number change
                    }
                    
                    AccountSettingsRow(
                        title: "Email",
                        value: "workstation_soft..."
                    ) {
                        // Handle email change
                    }
                }
                .padding(.top)
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct AccountSettingsRow: View {
    let title: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(Color.gray.opacity(0.05))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView()
    }
}
