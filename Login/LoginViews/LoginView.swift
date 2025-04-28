import SwiftUI

struct LoginView: View {
    @State private var currentScreen: Screen = .welcome
    
    enum Screen {
        case welcome
        case login
        case verifyEmail
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                switch currentScreen {
                case .welcome:
                    WelcomeView(currentScreen: $currentScreen)
                case .login:
                    SigninView(currentScreen: $currentScreen)
                case .verifyEmail:
                    VerifyEmailView(currentScreen: $currentScreen)
                }
            }
        }
    }
}

struct WelcomeView: View {
    @Binding var currentScreen: LoginView.Screen
    
    var body: some View {
        ZStack {
            // Background Image
            Image("nightSky")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Header Text
                HStack {
                    Text("Welcome to")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.leading, 24)
                
                HStack {
                    Spacer()
                    
                    Text("Tart")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.trailing, 24)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        currentScreen = .login
                    }) {
                        Text("Login")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.35, green: 0.35, blue: 0.35))
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        // Action for register
                    }) {
                    }
                    
                    Button(action: {
                        // Action for continue as guest
                    }) {
                        
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

struct SigninView: View {
    @Binding var currentScreen: LoginView.Screen
    @State private var email: String = ""
    @State private var rememberMe: Bool = false
    
    var body: some View {
        ZStack {
            // White background
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with forest background
                ZStack(alignment: .leading) {
                    // Forest background image
                    Image("forestGlow")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                        .position(x: UIScreen.main.bounds.width/2, y: 100)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Glad to see you...")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 24)
                    .padding(.bottom, 24)
                }
                
                // Login options
                VStack(spacing: 16) {
                    // Social login options
                    Button(action: {
                        // Google login action
                    }) {
                        HStack {
                            Image(systemName: "g.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                            
                            Text("Sign in with Google")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        // Apple login action
                    }) {
                        HStack {
                            Image(systemName: "apple.logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 24)
                                .foregroundColor(.black)
                            
                            Text("Sign in with Apple")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        // Facebook login action
                    }) {
                        HStack {
                            Image(systemName: "f.square.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                            
                            Text("Sign in with Facebook")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Or text
                    Text("Or")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.vertical, 8)
                    
                    // Email field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        
                        TextField("Your email", text: $email)
                            .font(.system(size: 16))
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    
                    // Remember me checkbox
                    HStack {
                        Button(action: {
                            rememberMe.toggle()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(width: 20, height: 20)
                                
                                if rememberMe {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray)
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                        
                        Text("Remember me")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    // Sign in button
                    Button(action: {
                        currentScreen = .verifyEmail
                    }) {
                        Text("Sign in")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.3, green: 0.3, blue: 0.3))
                            .cornerRadius(12)
                    }
                    
                    // Sign up link
                    
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                
                Spacer()
            }
            
            // App title at the top
            VStack {
                HStack {
                    Text("tart")
                        .font(.system(size: 20, weight: .medium))
                        .padding(.leading, 24)
                        .padding(.top, 12)
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
}

struct VerifyEmailView: View {
    @Binding var currentScreen: LoginView.Screen
    @State private var otpFields: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    
    var body: some View {
        ZStack {
            // White background
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                // Navigation back button
                HStack {
                    Button(action: {
                        currentScreen = .login
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding(.top, 12)
                
                // Title and subtitle
                VStack(alignment: .leading, spacing: 8) {
                    Text("Check your email")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("tartart@gmail.com")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.6, green: 0.7, blue: 0.3))
                    
                    Text("If this email exist, you will receive an email with a\nOne Time Password (OTP).\nType that code below:")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineSpacing(4)
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // OTP input fields
                HStack(spacing: 12) {
                    ForEach(0..<6, id: \.self) { index in
                        OTPTextField(text: $otpFields[index],
                                    isFocused: focusedField == index,
                                    onCommit: {
                                        if otpFields[index].count > 0 && index < 5 {
                                            focusedField = index + 1
                                        }
                                    })
                            .focused($focusedField, equals: index)
                    }
                }
                
                // Help text
                VStack(alignment: .leading, spacing: 12) {
                    BulletPoint(text: "Emails can take up to 5 minutes to arrive")
                    
                    HStack(spacing: 4) {
                        BulletPoint(text: "If you did not receive an email, click")
                        
                        Button(action: {
                            // Action to request another OTP
                        }) {
                            Text("here")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                        }
                        
                        Text("to")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Text("request another OTP")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                    
                    HStack(spacing: 4) {
                        Text("If you need help, please visit our")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            // Action to go to support page
                        }) {
                            Text("support")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                        }
                        
                        Text("page.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 16)
                
                Spacer()
                
                // Sign in button
                Button(action: {
                    // Action for sign in with OTP
                }) {
                    Text("Sign in")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(red: 0.3, green: 0.3, blue: 0.3))
                        .cornerRadius(12)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
    }
}

struct OTPTextField: View {
    @Binding var text: String
    var isFocused: Bool
    var onCommit: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? Color.blue : Color.gray, lineWidth: 1)
                .background(Color.white)
                .frame(width: 48, height: 48)
            
            TextField("", text: $text)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 18, weight: .medium))
                .onChange(of: text) { newValue in
                    if newValue.count > 1 {
                        text = String(newValue.suffix(1))
                    }
                    
                    if newValue.count == 1 {
                        onCommit()
                    }
                }
        }
    }
}

struct BulletPoint: View {
    var text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
