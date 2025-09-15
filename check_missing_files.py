#!/usr/bin/env python3
"""
检查哪些 Swift 文件没有被添加到 Xcode 项目中
"""

import os
import subprocess

def get_all_swift_files():
    """获取所有 Swift 文件"""
    swift_files = []
    for root, dirs, files in os.walk('.'):
        # 跳过 Xcode 项目文件
        if 'tart_prototype.xcodeproj' in root:
            continue
        if '.git' in root:
            continue
            
        for file in files:
            if file.endswith('.swift'):
                swift_files.append(os.path.join(root, file))
    
    return swift_files

def check_file_in_project(file_path):
    """检查文件是否已在 Xcode 项目中"""
    try:
        # 使用文件名而不是完整路径来检查
        filename = os.path.basename(file_path)
        result = subprocess.run([
            'grep', '-q', filename, 
            'tart_prototype.xcodeproj/project.pbxproj'
        ], capture_output=True)
        return result.returncode == 0
    except:
        return False

def main():
    print("🔍 扫描项目文件...")
    swift_files = get_all_swift_files()
    
    print(f"📁 找到 {len(swift_files)} 个 Swift 文件")
    
    missing_files = []
    existing_files = []
    
    for file_path in swift_files:
        if check_file_in_project(file_path):
            existing_files.append(file_path)
        else:
            missing_files.append(file_path)
    
    print(f"✅ 已在项目中的文件: {len(existing_files)}")
    print(f"❌ 缺失的文件: {len(missing_files)}")
    
    if missing_files:
        print("\n📋 缺失的文件列表:")
        for file_path in missing_files:
            print(f"  - {file_path}")
        
        print("\n💡 手动添加步骤:")
        print("1. 在 Xcode 中打开项目")
        print("2. 右键点击相应的文件夹（如 Home、Login、Message 等）")
        print("3. 选择 'Add Files to [项目名]'")
        print("4. 导航到文件位置并选择文件")
        print("5. 确保 'Add to target' 已勾选")
        print("6. 点击 'Add'")
        
        print("\n📂 按文件夹分组:")
        folders = {}
        for file_path in missing_files:
            folder = os.path.dirname(file_path)
            if folder not in folders:
                folders[folder] = []
            folders[folder].append(file_path)
        
        for folder, files in folders.items():
            print(f"\n  📁 {folder}:")
            for file_path in files:
                print(f"    - {os.path.basename(file_path)}")
    else:
        print("\n✅ 所有 Swift 文件都已正确添加到项目中！")
    
    # 检查其他重要文件
    print("\n🔧 检查其他重要文件:")
    important_files = [
        "tart-prototype-Info.plist",
        "amplifyconfiguration.json",
        "awsconfiguration.json"
    ]
    
    for file_name in important_files:
        if os.path.exists(file_name):
            if check_file_in_project(file_name):
                print(f"  ✅ {file_name} - 已在项目中")
            else:
                print(f"  ❌ {file_name} - 存在但未添加到项目")
        else:
            print(f"  ⚠️  {file_name} - 文件不存在")

if __name__ == "__main__":
    main() 