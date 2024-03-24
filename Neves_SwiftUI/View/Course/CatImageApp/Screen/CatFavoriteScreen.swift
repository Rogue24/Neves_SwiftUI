//
//  CatFavoriteScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct CatFavoriteScreen: View {
    @Environment(\.catApiManager) var apiManager: CatAPIManager
    
    @State private var loadError: CatFriendlyError? = nil
    
    var body: some View {
        VStack {
            Text("我的最爱")
                .font(.largeTitle.bold())
            
            ScrollView {
                if apiManager.favorites.isEmpty {
                    Text("双击图片即可新增到最爱哟 😊")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: apiManager.favorites.isEmpty ? 0 : -UIScreen.main.bounds.maxX)
                        .font(.title3)
                        .padding()
                }
                
//                ForEach(Array(favorites.enumerated()), id: \.element.imageID) { index, favoriteItem in
                ForEach(apiManager.favorites, id: \.imageID) { favoriteItem in
                    CatImageView(CatImageViewModel(favoriteItem: favoriteItem), isFavourited: true) {
                        do {
//                            try await favorites.remove(at: index, apiManager: apiManager)
                            try await apiManager.removeFromFavorite(id: favoriteItem.id)
                        } catch {
                            loadError = .init(title: "「我的最爱」删除失败", error: error)
                        }
                    }.transition(.slide)
                }
            }
        }
        .animation(.spring(), value: apiManager.favorites)
        .cat_alert(error: $loadError)
    }
}


struct CatFavoriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        CatFavoriteScreen()
            .environment(\.catApiManager, .preview) // 自定义环境变量
    }
}
