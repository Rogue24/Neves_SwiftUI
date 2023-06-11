//
//  AnimTestView.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/6/11.
//

import SwiftUI

struct AnimTestView: View {
    @State var name: String? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Image("Dilraba")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            if let name {
                Text(name)
                    .font(.largeTitle)
                    .bold()
            }
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    name = name == .none ? "迪丽热巴" : .none
                }
            } label: {
                Text(name == .none ? "这是谁？" : "返回")
                    .font(.title2)
                    .frame(width: 100)
                    .animation(.none, value: name)
                    .transformEffect(.identity) // 要加上变形效果
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
        }
        .padding()
    }
}
