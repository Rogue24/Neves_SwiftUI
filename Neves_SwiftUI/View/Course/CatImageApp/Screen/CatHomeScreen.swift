//
//  CatHomeScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

// FIXME: Better implementation for handling favorites.
struct CatHomeScreen: View {
    @Environment(\.catApiManager) var apiManager: CatAPIManager
    @State private var tab: Tab = .images
    @State private var favoriteImages: [FavoriteItem] = []
    @State private var isLoadFailed: Bool = false
    @State private var loadError: Error? = nil
    
    var body: some View {
        TabView(selection: $tab) {
            CatImageScreen(favorites: $favoriteImages)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.images)
            
            CatFavoriteScreen(favorites: $favoriteImages)
                .tabItem { Label("Favorite", systemImage: "heart.fill") }
                .tag(Tab.favorites)
        }
        .alert("「我的最爱」加载失败", isPresented: $isLoadFailed) {
            Button("OK") { loadError = nil }
        } message: {
            if let loadError {
                Text(loadError.localizedDescription)
            }
        }
        .task { await loadFavorites() }
    }
}

private extension CatHomeScreen {
    func loadFavorites() async {
        do {
            favoriteImages = try await apiManager.getFavorites()
        } catch {
            loadError = error
            isLoadFailed = true
        }
    }
}

private extension CatHomeScreen {
    enum Tab {
        case images, favorites
    }
}

struct CatHomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        CatHomeScreen()
            .environment(\.catApiManager, .stub) // 自定义环境变量
    }
}
