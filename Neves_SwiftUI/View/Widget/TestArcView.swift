//
//  TestArcView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2024/7/29.
//

import SwiftUI
import ClockHandRotationKit
import FunnyButton_SwiftUI

struct TestArcView: View {
    @State var gifResult: UIImage.GifResult? = nil
    
    @State var isUseVStack = false
    
    var body: some View {
        ScrollView {
            if let gifResult {
//                let images = gifResult.images
                let images = Array(gifResult.images.prefix(3))
                let width: Double = 240
                let height: Double = 240
                let arcWidth: Double = 30//max(width, height)
                let arcRadius: Double = 50//arcWidth * arcWidth
                let angle = 360.0 / Double(images.count)
//                let angle = 161 + 360.0 / 3.0
                
                AnyLayout.customStack(isUseVStack ? .V() : .Z()) {
                    ForEach(1...images.count, id: \.self) { index in
                        ZStack {
                            Image(uiImage: images[index-1])
                                .resizable()
                                .frame(width: arcWidth, height: arcWidth)
                                .opacity(isUseVStack ? 1 : 0.5)
//                                .mask {
//                                    ArcView(arcStartAngle: angle * Double(index - 1),
//                                            arcEndAngle: angle * Double(index),
//                                            arcRadius: arcRadius)
//                                    .stroke(style: StrokeStyle(lineWidth: arcWidth*1.1, lineCap: .square, lineJoin: .miter))
//                                    .clockHandRotationEffect(period: .custom(3))
//                                    .frame(width: width, height: height)
//                                    .offset(y: arcRadius)
//                                }
                        }
                        .frame(width: width, height: height)
                        .overlay {
                            Color(.randomColor(0.5))
                                .mask {
                                    ArcView(arcStartAngle: angle * Double(index - 1),
                                            arcEndAngle: angle * Double(index),
                                            arcRadius: arcRadius)
                                    .stroke(style: StrokeStyle(lineWidth: arcWidth*1.1, lineCap: .square, lineJoin: .miter))
                                    .clockHandRotationEffect(period: .custom(3))
                                    .frame(width: width, height: height)
                                    .offset(y: arcRadius)
                                }
                        }
                        .overlay {
                            Rectangle()
                                .stroke(lineWidth: 1) // 设置边框的宽度
                                .frame(width: arcWidth, height: arcWidth) // 设置正方形的大小
                                .foregroundColor(isUseVStack ? .red : .clear) // 设置边框的颜色
                        }
                        .background(isUseVStack ? .black : .clear)
                    }
                }
                .frame(maxWidth: width, maxHeight: .infinity)
                .overlay {
                    Rectangle()
                        .stroke(lineWidth: 1) // 设置边框的宽度
                        .frame(width: arcWidth, height: arcWidth) // 设置正方形的大小
                        .foregroundColor(isUseVStack ? .clear : .red) // 设置边框的颜色
                }
                .background(isUseVStack ? .clear : .black)
            } else {
                PlaceholderView(title: "耐心")
            }
        }
        .task {
            gifResult = await UIImage.decodeBundleGIF("1650349583")
        }
        .funnyAction {
            withAnimation(.spring(duration: 1)) {
                self.isUseVStack.toggle()
            }
        }
    }
}

struct ArcView: Shape {
    var arcStartAngle: Double
    var arcEndAngle: Double
    var arcRadius: Double
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: arcRadius,
                    startAngle: .degrees(arcStartAngle),
                    endAngle: .degrees(arcEndAngle),
                    clockwise: false)
        return path
    }
}
