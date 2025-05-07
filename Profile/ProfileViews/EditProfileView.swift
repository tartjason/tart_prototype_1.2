import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = "Jason"
    @State private var username = "jajasoso"
    @State private var bio = ""
    @State private var phoneNumber = "+1111"
    @State private var email = "jason.soltart@gmail.com"
    @State private var gender = "Male"
    @State private var birthdate = "02/18/2000"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Navigation Bar - Adjusted to have title next to back arrow
                HStack(spacing: 16) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                    
                    Text("Edit Profile")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                // Profile Picture Section - Aligned to left with avatar button next to it
                HStack(alignment: .center, spacing: 20) {
                    // Profile Avatar
                    ZStack {
                        // Background circle
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        // Character illustration
                        VStack(spacing: 0) {
                            // Head
                            Circle()
                                .fill(Color.white)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    // Simple face
                                    HStack(spacing: 4) {
                                        Circle()
                                            .fill(Color.black)
                                            .frame(width: 3, height: 3)
                                        Circle()
                                            .fill(Color.black)
                                            .frame(width: 3, height: 3)
                                    }
                                    .offset(y: -2)
                                )
                            
                            // Body
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green.opacity(0.8))
                                .frame(width: 35, height: 25)
                                .offset(y: -2)
                        }
                    }
                    .padding(.leading, 16)
                    
                    // Change Avatar Button - Now next to the profile image
                    Button(action: {}) {
                        Text("Change Avatar")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black, lineWidth: 0.8)
                            )
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 30)
                
                // Public Information Section
                Text("Public Information")
                    .font(.system(size: 20, weight: .medium))
                    .padding(.leading, 16)
                    .padding(.bottom, 16)
                
                VStack(spacing: 16) {
                    // Name Field
                    HStack(alignment: .center) {
                        Text("Name")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField("", text: $name)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 16)
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    // Username Field
                    HStack(alignment: .center) {
                        Text("Username")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField("", text: $username)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 16)
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    // Bio Field
                    HStack(alignment: .center) {
                        Text("Bio")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField("", text: $bio)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 16)
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    // Public Profile Permissions
                    Button(action: {}) {
                        HStack {
                            Text("Public Profile Permissions")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .frame(width: 220, alignment: .leading)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 30)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal, 16)
                
                // Private Information Section
                Text("Private Information")
                    .font(.system(size: 20, weight: .medium))
                    .padding(.leading, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                
                VStack(spacing: 16) {
                    // Phone Field
                    HStack(alignment: .center) {
                        Text("Phone no.")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField("", text: $phoneNumber)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .keyboardType(.phonePad)
                    }
                    .padding(.horizontal, 16)
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    // Email Field
                    HStack(alignment: .center) {
                        Text("Email")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField("", text: $email)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .keyboardType(.emailAddress)
                    }
                    .padding(.horizontal, 16)
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    // Gender Field
                    HStack(alignment: .center) {
                        Text("Gender")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField("", text: $gender)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 16)
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    // Birthdate Field
                    HStack(alignment: .center) {
                        Text("Birthdate")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField("", text: $birthdate)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal, 16)
                
                Spacer(minLength: 40)
            }
        }
        .navigationBarHidden(true)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
