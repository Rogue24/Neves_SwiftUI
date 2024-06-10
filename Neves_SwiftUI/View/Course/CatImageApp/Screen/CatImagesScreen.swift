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
    
    @State private var isLoading: Bool = false
//    @State private var isLoadFailed: Bool = false
    @State private var loadError: CatFriendlyError? = nil
    
    var body: some View {
        VStack {
            HStack {
                Text("阔爱喵喵")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("换一批", action: loadRandomImages)
                    .buttonStyle(.bordered)
                    .font(.headline)
                    .overlay {
                        if isLoading {
                            ProgressView()
                        }
                    }
                    .disabled(isLoading)
                
            }.padding(.horizontal)
            
            // ScrollViewReader：用来滚动ScrollView（ScrollView刷新后如果偏移量没变小就只会保留在原地，不会自动挪到顶部）
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(catImages) { catImage in
                        let isFavourited = apiManager.favorites.contains(where: \.imageID == catImage.id)
                        CatImageView(catImage, isFavourited: isFavourited) {
                            await toggleFavorite(catImage)
                        }
                        .id(catImage.id)
                    }
                }
                // 监听第一个数据的变化
                .onChange(of: catImages.first?.id) { newID in
                    guard let newID else { return }
                    // 当发生变化且有值，就滚动至首个数据（顶部）
                    withAnimation {
                        proxy.scrollTo(newID)
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
        .onAppear {
            // 当该View出现时，没有数据也没有正在加载才自动去加载数据
            guard catImages.isEmpty, !isLoading else { return }
            loadRandomImages()
        }
    }
}

private extension CatImageScreen {
    func loadRandomImages() {
        // 使用`.task {}`的话，当View被替换或移除，顺带的`task`及其子任务立马被取消执行，由于此时网络正在请求中，因此请求则会被取消（失败）
        // 为了让当前View被替换或移除时也能继续加载数据，将这些操作包在一个新的`Task`中去执行（跟View的生命周期解绑，相互独立）：
        Task {
            isLoading = true
            do {
                // for error test
//                if Bool.random() {
//                    throw URLError(.unknown)
//                }
                catImages = try await apiManager.getImages().map(CatImageViewModel.init)
            } catch {
                loadError = .init(title: "「阔爱喵喵」加载失败", error: error)
//                isLoadFailed = true
            }
            isLoading = false
        }
    }
    
    func toggleFavorite(_ cat: CatImageViewModel) async {
        let isDelete = apiManager.favorites.contains(where: \.imageID == cat.id)
        do {
            // for error test
//            if Bool.random() {
//                throw URLError(.unknown)
//            }
            try await apiManager.toggleFavorite(cat)
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
