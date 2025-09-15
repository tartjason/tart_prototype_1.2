import SwiftUI
import Amplify

// MARK: - Amplify Login Example View

struct AmplifyLoginExampleView: View {
    @StateObject private var loginModel = AmplifyLoginModel()
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var confirmationCode = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isSignUpMode = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerView
                    
                    // Authentication Forms
                    if loginModel.needsEmailConfirmation {
                        confirmationView
                    } else if loginModel.needsMFAConfirmation {
                        mfaView
                    } else if isSignUpMode {
                        signUpView
                    } else {
                        signInView
                    }
                    
                    // Social Login Buttons
                    if !loginModel.needsEmailConfirmation && !loginModel.needsMFAConfirmation {
                        socialLoginView
                    }
                    
                    // Toggle Sign In / Sign Up
                    if !loginModel.needsEmailConfirmation && !loginModel.needsMFAConfirmation {
                        toggleModeView
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Tart Login")
            .navigationBarTitleDisplayMode(.large)
            .alert("提示", isPresented: $showingAlert) {
                Button("确定") { }
            } message: {
                Text(alertMessage)
            }
            .onChange(of: loginModel.error) { error in
                if let error = error {
                    alertMessage = error
                    showingAlert = true
                    loginModel.error = nil
                }
            }
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(spacing: 10) {
            Image(systemName: "paintbrush.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Tart Art Platform")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(isSignUpMode ? "创建账户" : "欢迎回来")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
        .padding(.bottom, 30)
    }
    
    // MARK: - Sign In View
    
    private var signInView: some View {
        VStack(spacing: 15) {
            // Email Field
            TextField("邮箱地址", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            // Password Field
            SecureField("密码", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Sign In Button
            Button(action: signIn) {
                if loginModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("登录")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(loginModel.isLoading || email.isEmpty || password.isEmpty)
            
            // Forgot Password
            Button("忘记密码？") {
                forgotPassword()
            }
            .font(.footnote)
            .foregroundColor(.blue)
        }
    }
    
    // MARK: - Sign Up View
    
    private var signUpView: some View {
        VStack(spacing: 15) {
            // Username Field
            TextField("用户名", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            // Email Field
            TextField("邮箱地址", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            // Password Field
            SecureField("密码", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Sign Up Button
            Button(action: signUp) {
                if loginModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("注册")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(loginModel.isLoading || email.isEmpty || password.isEmpty || username.isEmpty)
        }
    }
    
    // MARK: - Confirmation View
    
    private var confirmationView: some View {
        VStack(spacing: 15) {
            Text("邮箱验证")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("我们已向 \(loginModel.pendingEmail) 发送验证码")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            TextField("验证码", text: $confirmationCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            
            Button(action: confirmSignUp) {
                if loginModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("验证")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(loginModel.isLoading || confirmationCode.isEmpty)
            
            Button("重新发送验证码") {
                resendCode()
            }
            .font(.footnote)
            .foregroundColor(.blue)
        }
    }
    
    // MARK: - MFA View
    
    private var mfaView: some View {
        VStack(spacing: 15) {
            Text("多因素认证")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("请输入短信验证码")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            TextField("验证码", text: $confirmationCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            
            Button(action: confirmMFA) {
                if loginModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("验证")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(loginModel.isLoading || confirmationCode.isEmpty)
        }
    }
    
    // MARK: - Social Login View
    
    private var socialLoginView: some View {
        VStack(spacing: 12) {
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.secondary)
                
                Text("或")
                    .foregroundColor(.secondary)
                    .font(.footnote)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 10)
            
            // Google Sign In
            Button(action: signInWithGoogle) {
                HStack {
                    Image(systemName: "globe")
                    Text("使用 Google 登录")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(loginModel.isLoading)
            
            // Apple Sign In
            Button(action: signInWithApple) {
                HStack {
                    Image(systemName: "applelogo")
                    Text("使用 Apple 登录")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(loginModel.isLoading)
            
            // Facebook Sign In
            Button(action: signInWithFacebook) {
                HStack {
                    Image(systemName: "f.square.fill")
                    Text("使用 Facebook 登录")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(loginModel.isLoading)
        }
    }
    
    // MARK: - Toggle Mode View
    
    private var toggleModeView: some View {
        HStack {
            Text(isSignUpMode ? "已有账户？" : "没有账户？")
                .foregroundColor(.secondary)
            
            Button(isSignUpMode ? "登录" : "注册") {
                withAnimation {
                    isSignUpMode.toggle()
                    clearFields()
                }
            }
            .foregroundColor(.blue)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Action Methods
    
    private func signIn() {
        Task {
            do {
                try await loginModel.signInWithEmail(email, password: password)
            } catch {
                // Error handling is done in the model
            }
        }
    }
    
    private func signUp() {
        Task {
            do {
                try await loginModel.signUpWithEmail(email, password: password, username: username)
            } catch {
                // Error handling is done in the model
            }
        }
    }
    
    private func confirmSignUp() {
        Task {
            do {
                try await loginModel.confirmSignUp(confirmationCode: confirmationCode)
                confirmationCode = ""
            } catch {
                // Error handling is done in the model
            }
        }
    }
    
    private func confirmMFA() {
        Task {
            do {
                try await loginModel.confirmSignIn(challengeResponse: confirmationCode)
                confirmationCode = ""
            } catch {
                // Error handling is done in the model
            }
        }
    }
    
    private func resendCode() {
        Task {
            do {
                try await loginModel.resendSignUpCode()
                alertMessage = "验证码已重新发送"
                showingAlert = true
            } catch {
                // Error handling is done in the model
            }
        }
    }
    
    private func forgotPassword() {
        Task {
            do {
                try await loginModel.resetPassword(for: email)
                alertMessage = "密码重置邮件已发送"
                showingAlert = true
            } catch {
                // Error handling is done in the model
            }
        }
    }
    
    private func signInWithGoogle() {
        Task {
            do {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else {
                    alertMessage = "无法获取窗口引用"
                    showingAlert = true
                    return
                }
                
                try await loginModel.signInWithGoogle(presentationAnchor: window)
            } catch {
                // Error handling is done in the model
            }
        }
    }
    
    private func signInWithApple() {
        Task {
            do {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else {
                    alertMessage = "无法获取窗口引用"
                    showingAlert = true
                    return
                }
                
                try await loginModel.signInWithApple(presentationAnchor: window)
            } catch {
                // Error handling is done in the model
            }
        }
    }
    
    private func signInWithFacebook() {
        Task {
            do {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else {
                    alertMessage = "无法获取窗口引用"
                    showingAlert = true
                    return
                }
                
                try await loginModel.signInWithFacebook(presentationAnchor: window)
            } catch {
                // Error handling is done in the model
            }
        }
    }
    
    private func clearFields() {
        email = ""
        password = ""
        username = ""
        confirmationCode = ""
        loginModel.clearState()
    }
}

// MARK: - Preview

struct AmplifyLoginExampleView_Previews: PreviewProvider {
    static var previews: some View {
        AmplifyLoginExampleView()
    }
} 