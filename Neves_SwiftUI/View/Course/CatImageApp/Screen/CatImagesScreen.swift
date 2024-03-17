//
//  CatImagesScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct CatImageScreen: View {
    @Environment(\.catApiManager) var apiManager: CatAPIManager
    @Binding var favorites: [FavoriteItem]
    
    @State private var catImages: [CatImageViewModel] = []
    @State private var didFirstLoad: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("阔爱喵喵")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // FIXME: 不该等网络请求结束才有动画
                Button("换一批") { Task { await loadRandomImages() } }
                    .buttonStyle(.bordered)
                    .font(.headline)
            }.padding(.horizontal)
            
            ScrollView {
                ForEach(catImages) { catImage in
                    let isFavourited = favorites.contains(where: \.imageID == catImage.id)
                    CatImageView(catImage, isFavourited: isFavourited) {
                        Task {
                            // FIXME: error handling & pass async closure?
                            try! await toggleFavorite(catImage)
                        }
                    }
                }
            }
        }
        .task {
            if !didFirstLoad {
                await loadRandomImages()
                didFirstLoad = true
            }
        }
    }
}

private extension CatImageScreen {
    func loadRandomImages() async {
        // FIXME: error handling
        catImages = try! await apiManager.getImages().map(CatImageViewModel.init)
    }
    
    func toggleFavorite(_ cat: CatImageViewModel) async throws {
        if let index = favorites.firstIndex(where: \.imageID == cat.id) {
            try await favorites.remove(at: index, apiManager: apiManager)
        } else {
            try await favorites.add(cat, apiManager: apiManager)
        }
    }
}

struct CatImageScreen_Previews: PreviewProvider, View {
    @State private var favorites: [FavoriteItem] = []
    
    var body: some View {
        CatImageScreen(favorites: $favorites)
            .environment(\.catApiManager, .stub) // 自定义环境变量
    }
    
    static var previews: some View {
        Self()
    }
}
