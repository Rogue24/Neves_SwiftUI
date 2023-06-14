//
//  PlaceholderView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/2/7.
//

import SwiftUI

struct PlaceholderView: View {
    let title: String
    var body: some View {
        VStack {
            Text("敬请期待！")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(.randomColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.randomColor)
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle(title)
    }
}
