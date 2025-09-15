#!/usr/bin/env python3
"""
Xcode项目文件同步脚本
用于将文件系统中的Swift文件添加到Xcode项目中
"""

import os
import subprocess
import sys
from pathlib import Path

def find_swift_files():
    """查找所有Swift文件"""
    swift_files = []
    for root, dirs, files in os.walk('.'):
        # 跳过Xcode项目文件
        if 'tart_prototype.xcodeproj' in root:
            continue
        if '.git' in root:
            continue
            
        for file in files:
            if file.endswith('.swift'):
                swift_files.append(os.path.join(root, file))
    
    return swift_files

def check_file_in_project(file_path):
    """检查文件是否已在Xcode项目中"""
    try:
        result = subprocess.run([
            'grep', '-q', os.path.basename(file_path), 
            'tart_prototype.xcodeproj/project.pbxproj'
        ], capture_output=True)
        return result.returncode == 0
    except:
        return False

def main():
    print("🔍 扫描项目文件...")
    swift_files = find_swift_files()
    
    print(f"📁 找到 {len(swift_files)} 个Swift文件")
    
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
        
        print("\n💡 建议操作:")
        print("1. 在Xcode中手动添加这些文件")
        print("2. 或者使用以下命令批量添加:")
        print("   xcodebuild -project tart_prototype.xcodeproj -target tart_prototype -add-file <file_path>")
    
    # 检查关键文件
    critical_files = [
        'tart-prototype-Info.plist',
        'amplifyconfiguration.json'
    ]
    
    print("\n🔧 检查关键配置文件:")
    for file_name in critical_files:
        if os.path.exists(file_name):
            print(f"  ✅ {file_name} - 存在")
        else:
            print(f"  ❌ {file_name} - 缺失")

if __name__ == "__main__":
    main() 