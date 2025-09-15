//
//  tart_prototypeApp.swift
//  tart_prototype
//
//  Created by ZhengXian Lin on 4/28/25.
//

import SwiftUI
import Amplify

@main
struct tart_prototypeApp: App {
    init() {
        // 初始化Amplify
        AmplifyManager.shared.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
