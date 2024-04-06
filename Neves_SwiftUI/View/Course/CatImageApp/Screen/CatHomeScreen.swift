//
//  CatHomeScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct CatHomeScreen: View {
    @State private var tab: Tab = .images
    
    // 📢 挪到`CatFavoriteScreen`内部获取
//    @EnvironmentObject private var apiManager: CatAPIManager
    // ⚠️`EnvironmentObject`的注意点：如果「上层或直至根层」都没有传递该值过来会直接【Crash】！！！
    
    // 📢 挪到`CatFavoriteScreen`内部处理
//    @State private var loadError: CatFriendlyError? = nil
    
    var body: some View {
        TabView(selection: $tab) {
            CatImageScreen()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.images)
            
            CatFavoriteScreen()
                .tabItem { Label("Favorite", systemImage: "heart.fill") }
                .tag(Tab.favorites)
        }
        // 📢 挪到`CatFavoriteScreen`内部处理
//        .cat_alert(error: $loadError)
//        .task { await loadFavorites() }
    }
}

// 📢 挪到`CatFavoriteScreen`内部获取
//private extension CatHomeScreen {
//    func loadFavorites() async {
//        do {
//            try await apiManager.getFavorites()
////            throw URLError(.cancelled) // for error test
//        } catch {
//            loadError = .init(title: "「我的最爱」加载失败", error: error)
//        }
//    }
//}

private extension CatHomeScreen {
    enum Tab {
        case images, favorites
    }
}

struct CatHomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        CatHomeScreen()
//            .environment(\.catApiManager, .preview) // 使用自定义的环境变量
            .environmentObject(CatAPIManager.preview) // 改用environmentObject：能跟随属性的变化去更新视图
    }
}
