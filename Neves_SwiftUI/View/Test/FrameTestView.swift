//
//  FrameTestView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/9.
//

import SwiftUI

struct FrameTestView: View {
    var body: some View {
        ZStack {
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
//                .frame(minWidth: 0) // 竖屏
//                .frame(minHeight: 0) // 横屏
            
        }
        // 这样设置只会以子视图的大小
//        .frame(width: .infinity, height: .infinity)
        // 这样设置才会延伸至父视图的大小（如果子视图不足父视图的大小的情况下）
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous)) // 如果图片超出父视图区域就看不见这个圆角
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
