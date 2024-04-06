//
//  CatImagesScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct CatImageScreen: View {
//    @Environment(\.catApiManager) var apiManager: CatAPIManager
    @EnvironmentObject private var apiManager: CatAPIManager
    // ⚠️`EnvironmentObject`的注意点：如果「上层或直至根层」都没有传递该值过来会直接【Crash】！！！
    
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
                    let isFavourited = apiManager.favorites.contains(where: \.imageID == catImage.id)
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
        .cat_alert(error: $loadError)
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
        let isDelete = apiManager.favorites.contains(where: \.imageID == cat.id)
        do {
            try await apiManager.toggleFavorite(cat)
//            throw URLError(.cancelled) // for error test
        } catch {
            loadError = .init(title: "「我的最爱」\(isDelete ? "删除" : "添加")失败", error: error)
//            isLoadFailed = true
        }
    }
}

struct CatImageScreen_Previews: PreviewProvider {
    static var previews: some View {
        CatImageScreen()
//            .environment(\.catApiManager, .preview) // 使用自定义的环境变量
            .environmentObject(CatAPIManager.preview) // 改用environmentObject：能跟随属性的变化去更新视图
    }
}
