#!/usr/bin/env python3
"""
应用流程测试脚本
验证认证状态管理和界面切换
"""

import os
import subprocess

def check_file_exists(file_path):
    """检查文件是否存在"""
    return os.path.exists(file_path)

def check_imports_in_file(file_path, imports):
    """检查文件中的导入"""
    if not check_file_exists(file_path):
        return False, f"文件不存在: {file_path}"
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            missing_imports = []
            for imp in imports:
                if imp not in content:
                    missing_imports.append(imp)
            
            if missing_imports:
                return False, f"缺少导入: {', '.join(missing_imports)}"
            return True, "所有导入都存在"
    except Exception as e:
        return False, f"读取文件错误: {e}"

def main():
    print("🧪 测试应用认证流程...")
    print("=" * 50)
    
    # 检查关键文件
    key_files = [
        "tart_prototype/ContentView.swift",
        "Login/LoginViews/LoginView.swift", 
        "Login/LoginModels/AmplifyLoginModel.swift",
        "Profile/ProfileViews/ProfileView.swift",
        "Profile/ProfileViews/BottomSlidingMenuView.swift",
        "Shared/Extensions/NotificationCenter+Extensions.swift",
        "tart-prototype-Info.plist",
        "amplifyconfiguration.json"
    ]
    
    print("📁 检查关键文件:")
    for file_path in key_files:
        exists = check_file_exists(file_path)
        status = "✅" if exists else "❌"
        print(f"  {status} {file_path}")
    
    print("\n📦 检查导入:")
    
    # 检查 ContentView 的导入
    content_view_imports = ["import SwiftUI", "import Amplify"]
    success, message = check_imports_in_file("tart_prototype/ContentView.swift", content_view_imports)
    status = "✅" if success else "❌"
    print(f"  {status} ContentView.swift: {message}")
    
    # 检查 LoginView 的导入
    login_view_imports = ["import SwiftUI"]
    success, message = check_imports_in_file("Login/LoginViews/LoginView.swift", login_view_imports)
    status = "✅" if success else "❌"
    print(f"  {status} LoginView.swift: {message}")
    
    # 检查 AmplifyLoginModel 的导入
    amplify_model_imports = ["import Foundation", "import SwiftUI", "import Amplify"]
    success, message = check_imports_in_file("Login/LoginModels/AmplifyLoginModel.swift", amplify_model_imports)
    status = "✅" if success else "❌"
    print(f"  {status} AmplifyLoginModel.swift: {message}")
    
    # 检查 ProfileView 的导入
    profile_view_imports = ["import SwiftUI", "import Amplify"]
    success, message = check_imports_in_file("Profile/ProfileViews/ProfileView.swift", profile_view_imports)
    status = "✅" if success else "❌"
    print(f"  {status} ProfileView.swift: {message}")
    
    print("\n🔍 检查关键功能:")
    
    # 检查认证管理器
    with open("tart_prototype/ContentView.swift", 'r', encoding='utf-8') as f:
        content = f.read()
        checks = [
            ("AuthenticationManager", "认证管理器类"),
            ("@Published var isAuthenticated", "认证状态属性"),
            ("checkAuthenticationState", "检查认证状态方法"),
            ("signOut", "登出方法"),
            ("NotificationCenter", "通知中心"),
            ("MainAppView", "主应用视图"),
            ("LoginView", "登录视图")
        ]
        
        for check, description in checks:
            found = check in content
            status = "✅" if found else "❌"
            print(f"  {status} {description}: {check}")
    
    # 检查通知扩展
    with open("Shared/Extensions/NotificationCenter+Extensions.swift", 'r', encoding='utf-8') as f:
        content = f.read()
        if "authenticationStateChanged" in content:
            print("  ✅ 认证状态变化通知: 已定义")
        else:
            print("  ❌ 认证状态变化通知: 未定义")
    
    # 检查菜单登出功能
    with open("Profile/ProfileViews/BottomSlidingMenuView.swift", 'r', encoding='utf-8') as f:
        content = f.read()
        if "onSignOutTapped" in content and "Sign Out" in content:
            print("  ✅ 菜单登出功能: 已添加")
        else:
            print("  ❌ 菜单登出功能: 未添加")
    
    print("\n🎯 应用流程总结:")
    print("1. 应用启动时检查认证状态")
    print("2. 如果未认证，显示登录界面")
    print("3. 如果已认证，显示主应用界面")
    print("4. 用户可以通过菜单登出")
    print("5. 登出后自动返回登录界面")
    
    print("\n✨ 测试完成！")
    print("\n💡 下一步:")
    print("- 在 Xcode 中构建并运行项目")
    print("- 测试登录流程")
    print("- 测试登出功能")
    print("- 验证界面切换")

if __name__ == "__main__":
    main() 