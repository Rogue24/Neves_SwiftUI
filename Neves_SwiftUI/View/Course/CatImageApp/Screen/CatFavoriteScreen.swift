//
//  CatFavoriteScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

enum CatFavoriteLoadingState: Equatable {
    case notStarted
    case loading
    case success
    case fail
}

struct CatFavoriteScreen: View {
//    @Environment(\.catApiManager) var apiManager: CatAPIManager
    @EnvironmentObject private var apiManager: CatAPIManager
    // ⚠️`EnvironmentObject`的注意点：如果「上层或直至根层」都没有传递该值过来会直接【Crash】！！！
    
    @State private var loadingState: CatFavoriteLoadingState = .notStarted
    @State private var loadError: CatFriendlyError? = nil
    
    var body: some View {
        VStack {
            Text("我的最爱")
                .font(.largeTitle.bold())
            
            ScrollView {
                if apiManager.favorites.isEmpty && loadingState == .success  {
                    favoriteFeatureHintText
                }
                
                favoriteList
                
                Group {
                    if loadingState == .fail {
                       retryButton
                    } 
                    else if loadingState == .loading {
                        ProgressView()
                            .controlSize(.large)
                    }
                }.frame(minHeight: 100)
            }
        }
        .animation(.spring(), value: apiManager.favorites)
        .cat_alert(error: $loadError)
        .task {
            guard loadingState == .notStarted else { return }
            await loadFavorites()
        }
    }
}

private extension CatFavoriteScreen {
    func loadFavorites() async {
        loadingState = .loading
        do {
            try await apiManager.getFavorites()
//            throw URLError(.cancelled) // for error test
            loadingState = .success
        } catch {
            loadingState = .fail
        }
    }
}

// MARK: Subviews
private extension CatFavoriteScreen {
    var favoriteFeatureHintText: some View {
        Text("双击图片即可新增到最爱哟 😊")
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(x: apiManager.favorites.isEmpty ? 0 : -UIScreen.main.bounds.maxX)
            .font(.title3)
            .padding()
    }
    
    var favoriteList: some View {
        ForEach(apiManager.favorites, id: \.imageID) { favoriteItem in
            CatImageView(.init(favoriteItem: favoriteItem), isFavourited: true) {
                do {
                    try await apiManager.removeFromFavorite(id: favoriteItem.id)
                } catch {
                    loadError = .init(title: "无法从「我的最爱」中移除，请确认网络状态后再重试。", error: error)
                }
            }.transition(.slide)
        }
    }
    
    var retryButton: some View  {
        HStack {
            Text("「我的最爱」加载失败\n请确认网络状态后再重试。")
            Button("继续") {
                Task {
                    await loadFavorites()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
        }
    }
}

struct CatFavoriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        CatFavoriteScreen()
//            .environment(\.catApiManager, .preview) // 使用自定义的环境变量
            .environmentObject(CatAPIManager.preview) // 改用environmentObject：能跟随属性的变化去更新视图
    }
}
