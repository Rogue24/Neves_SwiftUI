//
//  CatFavoriteScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct CatFavoriteScreen: View {
    @Binding var favorites: [CatImageViewModel]
    
    var body: some View {
        VStack {
            Text("我的最爱")
                .font(.largeTitle.bold())
            
            ScrollView {
                if favorites.isEmpty {
                    Text("双击图片即可新增到最爱哟 😊")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: favorites.isEmpty ? 0 : -UIScreen.main.bounds.maxX)
                        .font(.title3)
                        .padding()
                }
                
                ForEach(Array(favorites.enumerated()), id: \.element.id) { index, catImage in
                    CatImageView(catImage, isFavourited: true) {
                        // TODO:  send update to the server
                        favorites.remove(at: index)
                    }.transition(.slide)
                }
            }
        }.animation(.spring(), value: favorites)
    }
}


struct CatFavoriteScreen_Previews: PreviewProvider, View {
    @State private var favorites: [CatImageViewModel] = .stub
    var body: some View {
        CatFavoriteScreen(favorites: $favorites)
    }
    
    static var previews: some View {
        Self()
    }
}
