//
//  FunnyPlayView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/18.
//

import SwiftUI
import FunnyButton_SwiftUI

struct FunnyPlayView: View {
    
    @State private var isOne = true
    @State private var number = 1
    
    var body: some View {
        VStack(spacing: 20) {
            Text("- 点击笑脸执行函数 -").font(.largeTitle)
            Text("\(number)")
                .font(.largeTitle)
                .foregroundColor(Color.white)
                .frame(width: 80, height: 80)
                .background(Color.blue)
                .cornerRadius(16)
            Button("随机 Number") { isOne = true }
            Button("1~3 Number") { isOne = false }
        }
        .funnyActions() {
            if isOne {
                return [FunnyAction() {
                    number = Int.random(in: 1...100)
                }]
            }
            return [
                FunnyAction(name: "1") { number = 1 },
                FunnyAction(name: "2") { number = 2 },
                FunnyAction(name: "3") { number = 3 },
            ]
        }
    }
}

struct FunnyPlayView_Previews: PreviewProvider {
    static var previews: some View {
        FunnyPlayView()
    }
}
