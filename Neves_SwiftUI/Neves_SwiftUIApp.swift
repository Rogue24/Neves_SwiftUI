//
//  Neves_SwiftUIApp.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/9/25.
//

import SwiftUI
import FunnyButton_SwiftUI

@main
struct Neves_SwiftUIApp: App {
    @StateObject var hud = Hud()
    @StateObject var funny = Funny()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(hud)
                .overlay(TTProgressHUD($hud.visible, config: hud.config))
                .onOpenURL { url in
                    hud.info(url.absoluteString)
                }
                .environmentObject(funny)
                .onAppear() { FunnyWindow.show() }
        }
    }
    
    // 修改全局tabBar（滑动时有无内容在底下穿透）的背景
//    func applyTabBarBackground() {
//        let appearance = UITabBarAppearance()
//        appearance.configureWithTransparentBackground()
//        appearance.backgroundColor = .blue
//        appearance.backgroundEffect = UIBlurEffect(style: .extraLight)
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//    }
//
//    init() {
//        applyTabBarBackground()
//    }
}
