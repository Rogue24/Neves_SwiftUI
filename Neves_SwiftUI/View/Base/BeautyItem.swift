//
//  BeautyItem.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/8.
//

import SwiftUI

struct BeautyItem: View {
    var beauty: Beauty
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            Image(uiImage: beauty.image) // SwiftUI始终采用图像的原始尺寸（图片多大就多大）
                .resizable() // 使用这个Modifier可以确保图片大小限制在剩余所有的可用空间内
                .aspectRatio(contentMode: .fill)
                // minWidth 和 maxWidth，minHeight 和 maxHeight
                // 都设置了才能自适应剩余宽/高度，缺一则是以最大高/宽度按图片宽高比换算后的宽/高度
                .frame(minWidth: 0, maxWidth: .infinity,
                       minHeight: 0, maxHeight: .infinity,
                       alignment: beauty.alignment)
                .clipped()
            
            VStack(alignment: .leading, // 这里的alignment值得是里面的子视图的对齐方式，并不是整个VStack
                   spacing: 4.0) {
                Spacer()
                Text(beauty.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                Text(beauty.subtitle)
                    .font(.footnote)
                    .foregroundColor(Color.white)
            }
            .padding(.all)
            // 如果设置【绝对】宽度为无限是无效的，那样宽度是内容宽度（默认宽度是内容宽度）
            // 当设置VStack的width比子视图的最大width还大的话，设置这个alignment才是整个VStack的对齐方式
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minWidth: 0, maxWidth: .infinity,
               minHeight: 0, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

struct BeautyItem_Previews: PreviewProvider {
    static var previews: some View {
        BeautyItem(beauty: beauties[6])
    }
}
