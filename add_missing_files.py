#!/usr/bin/env python3
"""
添加缺失文件到 Xcode 项目
"""

import os
import subprocess

def check_file_in_project(file_path):
    """检查文件是否已在 Xcode 项目中"""
    try:
        result = subprocess.run([
            'grep', '-q', os.path.basename(file_path), 
            'tart_prototype.xcodeproj/project.pbxproj'
        ], capture_output=True)
        return result.returncode == 0
    except:
        return False

def main():
    print("🔍 检查缺失的文件...")
    
    # 需要检查的文件列表
    files_to_check = [
        "Shared/Extensions/NotificationCenter+Extensions.swift"
    ]
    
    missing_files = []
    
    for file_path in files_to_check:
        if os.path.exists(file_path):
            if check_file_in_project(file_path):
                print(f"✅ {file_path} - 已在项目中")
            else:
                print(f"❌ {file_path} - 存在但未添加到项目")
                missing_files.append(file_path)
        else:
            print(f"❌ {file_path} - 文件不存在")
    
    if missing_files:
        print("\n📋 需要手动添加到 Xcode 项目的文件:")
        for file_path in missing_files:
            print(f"  - {file_path}")
        
        print("\n💡 手动添加步骤:")
        print("1. 在 Xcode 中打开项目")
        print("2. 右键点击项目导航器中的 'Shared' 文件夹")
        print("3. 选择 'Add Files to [项目名]'")
        print("4. 导航到文件位置并选择文件")
        print("5. 确保 'Add to target' 已勾选")
        print("6. 点击 'Add'")
        
        print("\n🔧 或者，你可以删除这些文件，因为我已经在 ContentView.swift 中添加了临时解决方案")
    else:
        print("\n✅ 所有文件都已正确添加到项目中")

if __name__ == "__main__":
    main() 