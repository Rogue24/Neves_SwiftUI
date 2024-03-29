//
//  AnimExperience_iOS15_View.swift
//  Neves_SwiftUI
//
//  Created by aa on 2022/10/26.
//

import SwiftUI

struct AnimExperience_iOS15_View: View {
    @State var isAnimated = false
    
    var body: some View {
        VStack {
            // 给自己添加动画，则不会受到父视图的动画影响
            Text("Hello!")
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(Color.blue)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.top, isAnimated ? 100 : 0)
                .animation(
                    Animation.easeIn(duration: 3),
                    value: isAnimated
                )
            
            Text("World!")
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(Color.yellow)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.top, 20)
                .animation(
                    Animation.easeOut(duration: 3),
                    value: isAnimated
                )
                // 上面已经添加了动画，后续添加的动画不会再影响到上面的
                .animation(
                    Animation.easeIn(duration: 3),
                    value: isAnimated
                )
            
            // 不添加动画，默认会受到父视图的动画影响
            Text("Hi!")
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(Color.orange)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.top, 20)
            
            // 不想受到父视图的动画影响得自己添加一个空动画
            Text("yo!")
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(Color.primary)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.top, 20)
                .animation(nil, value: isAnimated)
            
            VStack(spacing: 10) {
                Text("Look!")
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .background(Color.pink)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(isAnimated ? .leading : .trailing, 200)
                    .animation(.linear, value: isAnimated)
                
                Text("what!")
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .background(Color.secondary)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(isAnimated ? .trailing : .leading, 200)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            .animation(.spring(), value: isAnimated)
            
            Spacer()
            
            Button(action: {
                isAnimated.toggle()
            }) {
                Text("Tap me")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(width: 100, height: 50)
                    .background(Color.green)
                    .cornerRadius(20)
                    .shadow(radius: 20)
            }
        }
        .frame(maxHeight: .infinity)
        .background(.randomColor)
        .padding()
        .animation(
            .spring(response: 0.5,
                    dampingFraction: 0.6,
                    blendDuration: 0),
            value: isAnimated
        )
        .onAppear() {
            isAnimated.toggle()
        }
    }
}

struct AnimExperience_iOS15_View_Previews: PreviewProvider {
    static var previews: some View {
        AnimExperience_iOS15_View()
    }
}

