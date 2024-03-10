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
    @State private var favoriteImages: [CatImageViewModel] = []
    
    var body: some View {
        TabView(selection: $tab) {
            CatImageScreen(favorites: $favoriteImages)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.images)
            
            CatFavoriteScreen(favorites: $favoriteImages)
                .tabItem { Label("Favorite", systemImage: "heart.fill") }
                .tag(Tab.favorites)
        }
        .task {
            // FIXME: error handling
            try! await loadFavorites()
        }
    }
}

private extension CatHomeScreen {
    func loadFavorites() async throws {
        // TODO: fetch favorite
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
