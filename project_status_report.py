#!/usr/bin/env python3
"""
项目状态报告
检查所有文件是否已正确添加到 Xcode 项目中
"""

import os
import subprocess

def check_file_in_project(file_path):
    """检查文件是否已在 Xcode 项目中"""
    try:
        filename = os.path.basename(file_path)
        result = subprocess.run([
            'grep', '-q', filename, 
            'tart_prototype.xcodeproj/project.pbxproj'
        ], capture_output=True)
        return result.returncode == 0
    except:
        return False

def get_all_swift_files():
    """获取所有 Swift 文件"""
    swift_files = []
    for root, dirs, files in os.walk('.'):
        if 'tart_prototype.xcodeproj' in root or '.git' in root:
            continue
        for file in files:
            if file.endswith('.swift'):
                swift_files.append(os.path.join(root, file))
    return swift_files

def get_all_resource_files():
    """获取所有资源文件"""
    resource_files = []
    for root, dirs, files in os.walk('.'):
        if 'tart_prototype.xcodeproj' in root or '.git' in root:
            continue
        for file in files:
            if file.endswith(('.png', '.jpg', '.jpeg', '.gif', '.xcassets', '.storyboard', '.xib')):
                resource_files.append(os.path.join(root, file))
    return resource_files

def main():
    print("📊 项目状态报告")
    print("=" * 50)
    
    # 检查 Swift 文件
    print("🔍 检查 Swift 文件...")
    swift_files = get_all_swift_files()
    missing_swift = []
    existing_swift = []
    
    for file_path in swift_files:
        if check_file_in_project(file_path):
            existing_swift.append(file_path)
        else:
            missing_swift.append(file_path)
    
    print(f"📁 Swift 文件总数: {len(swift_files)}")
    print(f"✅ 已在项目中: {len(existing_swift)}")
    print(f"❌ 缺失: {len(missing_swift)}")
    
    # 检查资源文件
    print("\n🖼️ 检查资源文件...")
    resource_files = get_all_resource_files()
    missing_resources = []
    existing_resources = []
    
    for file_path in resource_files:
        if check_file_in_project(file_path):
            existing_resources.append(file_path)
        else:
            missing_resources.append(file_path)
    
    print(f"📁 资源文件总数: {len(resource_files)}")
    print(f"✅ 已在项目中: {len(existing_resources)}")
    print(f"❌ 缺失: {len(missing_resources)}")
    
    # 检查配置文件
    print("\n⚙️ 检查配置文件...")
    config_files = [
        "tart-prototype-Info.plist",
        "amplifyconfiguration.json",
        "awsconfiguration.json"
    ]
    
    missing_configs = []
    for file_name in config_files:
        if os.path.exists(file_name):
            if check_file_in_project(file_name):
                print(f"  ✅ {file_name} - 已在项目中")
            else:
                print(f"  ❌ {file_name} - 存在但未添加到项目")
                missing_configs.append(file_name)
        else:
            print(f"  ⚠️  {file_name} - 文件不存在")
    
    # 显示缺失的文件
    if missing_swift or missing_resources or missing_configs:
        print("\n📋 需要添加的文件:")
        
        if missing_swift:
            print("\n  📝 Swift 文件:")
            for file_path in missing_swift:
                print(f"    - {file_path}")
        
        if missing_resources:
            print("\n  🖼️ 资源文件:")
            for file_path in missing_resources:
                print(f"    - {file_path}")
        
        if missing_configs:
            print("\n  ⚙️ 配置文件:")
            for file_name in missing_configs:
                print(f"    - {file_name}")
        
        print("\n💡 添加步骤:")
        print("1. 在 Xcode 中打开项目")
        print("2. 右键点击相应的文件夹")
        print("3. 选择 'Add Files to [项目名]'")
        print("4. 选择要添加的文件")
        print("5. 确保 'Add to target' 已勾选")
        print("6. 点击 'Add'")
    else:
        print("\n✅ 所有文件都已正确添加到项目中！")
    
    # 项目结构总结
    print("\n📂 项目结构总结:")
    modules = ["Home", "Login", "Message", "Profile", "Services", "Shared", "tart_prototype"]
    for module in modules:
        if os.path.exists(module):
            swift_count = len([f for f in swift_files if f.startswith(f"./{module}/")])
            print(f"  📁 {module}: {swift_count} 个 Swift 文件")
    
    print("\n✨ 项目状态: 准备就绪！")
    print("🎯 下一步: 在 Xcode 中构建并运行项目")

if __name__ == "__main__":
    main() 