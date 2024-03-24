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
    @State private var isLoading: Bool = false
//    @State private var isLoadFailed: Bool = false
    @State private var loadError: CatFriendlyError? = nil
    
    var body: some View {
        VStack {
            HStack {
                Text("阔爱喵喵")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("换一批") { Task { await loadRandomImages() } }
                    .buttonStyle(.bordered)
                    .font(.headline)
                    .overlay {
                        if isLoading {
                            ProgressView()
                        }
                    }
                    .disabled(isLoading)
                
            }.padding(.horizontal)
            
            ScrollView {
                ForEach(catImages) { catImage in
                    let isFavourited = favorites.contains(where: \.imageID == catImage.id)
                    CatImageView(catImage, isFavourited: isFavourited) {
                        await toggleFavorite(catImage)
                    }
                }
            }
        }
//        .alert(loadError?.title ?? "Fail!", isPresented: $isLoadFailed) {
//            Button("OK") { loadError = nil }
//        } message: {
//            if let loadError {
//                Text(loadError.error.localizedDescription)
//            }
//        }
        .cat_alert($loadError)
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
        isLoading = true
        do {
            catImages = try await apiManager.getImages().map(CatImageViewModel.init)
//            throw URLError(.cancelled) // for error test
        } catch {
            loadError = .init(title: "「阔爱喵喵」加载失败", error: error)
//            isLoadFailed = true
        }
        isLoading = false
    }
    
    func toggleFavorite(_ cat: CatImageViewModel) async {
        var isDelete = false
        do {
            if let index = favorites.firstIndex(where: \.imageID == cat.id) {
                isDelete = true
                try await favorites.remove(at: index, apiManager: apiManager)
            } else {
                try await favorites.add(cat, apiManager: apiManager)
            }
//            throw URLError(.cancelled) // for error test
        } catch {
            loadError = .init(title: "「我的最爱」\(isDelete ? "删除" : "添加")失败", error: error)
//            isLoadFailed = true
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
