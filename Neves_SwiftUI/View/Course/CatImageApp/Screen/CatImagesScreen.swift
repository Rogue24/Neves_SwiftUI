//
//  CatImagesScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct CatImageScreen: View {
    @Environment(\.catApiManager) var apiManager: CatAPIManager
    @Binding var favorites: [CatImageViewModel]
    
    @State private var catImages: [CatImageViewModel] = []
    @State private var didFirstLoad: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("阔爱喵喵")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("换一批") { Task { await loadRandomImages() } }
                    .buttonStyle(.bordered)
                    .font(.headline)
            }.padding(.horizontal)
            
            ScrollView {
                ForEach(catImages) { catImage in
                    let isFavourited = favorites.contains(where: \.id == catImage.id)
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
        guard let index = favorites.firstIndex(where: \.id == cat.id)  else {
            try await add(cat)
            return
        }
        try await remove(index: index)
    }
}


private extension CatImageScreen {
    func add(_ cat: CatImageViewModel) async throws {
        let id = try await apiManager.addToFavorite(imageID: cat.id)
        JPrint("已添加：", id)
        favorites.append(cat)
        // TODO: send update to the server
    }
    
    func remove(index: Int) async throws {
        favorites.remove(at: index)
        // TODO:  send update to the server
    }
}


struct CatImageScreen_Previews: PreviewProvider, View {
    @State private var favorites: [CatImageViewModel] = []
    
    var body: some View {
        CatImageScreen(favorites: $favorites)
            .environment(\.catApiManager, .stub) // 自定义环境变量
    }
    
    static var previews: some View {
        Self()
    }
}
