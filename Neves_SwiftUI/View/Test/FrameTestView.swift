//
//  FrameTestView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/9.
//
//  关于`VStack/HStack/ZStack`、`Image`的frame设置

import SwiftUI

struct FrameTestView: View {
    var body: some View {
        ZStack(alignment: .top) {
            // SwiftUI默认始终采用图像的原始尺寸（图片多大就多大）
            Image(uiImage: UIImage.jp.fromBundle(forName: "Girl2", ofType: "jpg")!)
                // 使用这个Modifier可以确保图片的【最小边】限制在父视图内
                .resizable()
            
                // 保持图片的宽高比展示
                .aspectRatio(contentMode: .fill)
                // fit 图片`宽`和`高`都不会超出父视图区域
                // fill 铺满整个父视图（设置了resizable后，默认是这个）
                //  - 竖屏：图片`高`不会超出父视图区域，图片`宽`会超出
                //  - 横屏：图片`宽`不会超出父视图区域，图片`高`会超出
            
                // 在.fill模式下，这样设置可以让图片`宽`和`高`都不会超出父视图区域
                // PS：只要这个最小`宽/高`值小于等于父视图的`宽/高`即可
                .frame(minWidth: 0, minHeight: 0) // 竖屏+横屏
//                .frame(minWidth: 0) // 仅处理竖屏
//                .frame(minHeight: 0) // 仅处理横屏
            
            Text("Hello")
                .foregroundColor(.randomColor)
                .padding()
        }
        // 这样设置只会以子视图的大小（按最大的包裹）
//        .frame(width: .infinity, height: .infinity)
        // 这样设置才会延伸至父视图的大小（如果子视图不足父视图的大小的情况下）
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        // 要设置frame再设置背景，否则背景的frame不是最新的frame（也就是CGSize.zero）
        .background(Color.randomColor)
        
        // 如果图片超出父视图区域就看不见这个圆角
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}

struct FrameTestView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            FrameTestView()
                .previewInterfaceOrientation(.portrait)
        } else {
            FrameTestView()
        }
    }
}
