//
//  AnimationValueView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2022/10/26.
//

import SwiftUI

struct AnimationValueView: View {
    @State var flag = false
    
    var body: some View {
         VStack(spacing: 50) {
             HStack(spacing: 30) {
                 Text("Rotation")
                     .rotationEffect(Angle(degrees: self.flag ? 360 : 0))
                     // 自定义`animation`替换原本的动画
                     .animation(
                        .easeIn(duration: 4.0).delay(2.0),
                        value: 1 // 当`value`发生变化时，才会应用该动画
                        // 这里是个固定值因此不会应用该动画
                     )

                 Text("Rotation\nModified")
                     .rotationEffect(Angle(degrees: self.flag ? 360 : 0))
                     // 自定义`animation`替换原本的动画
                     .animation(
                        .easeIn(duration: 4.0).delay(2.0),
                        value: self.flag // 当`value`发生变化时，才会应用该动画
                     )
                     // 也可以使用`transaction`替换原本的动画
//                     .transaction { view in
//                         view.animation =
//                             view.animation?.delay(2.0).speed(2)
//                     }
                 
                 Text("Animation\nReplaced")
                     .rotationEffect(Angle(degrees: self.flag ? 360 : 0))
                     // 自定义`animation`替换原本的动画
//                     .animation(
//                        .interactiveSpring(
//                            response: 0.60,
//                            dampingFraction: 0.20,
//                            blendDuration: 0.25),
//                        value: self.flag // 当`value`发生变化时，才会应用该动画
//                     )
                     // 也可以使用`transaction`替换原本的动画
                     .transaction { view in
                         view.animation = .interactiveSpring(
                             response: 0.60,
                             dampingFraction: 0.20,
                             blendDuration: 0.25)
                     }
             }

             Button("Animate") {
                 withAnimation(.easeIn(duration: 2.0)) {
                     self.flag.toggle()
                 }
             }
         }
     }
}

struct AnimationValueView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationValueView()
            .previewDevice("iPhone 11")
    }
}
