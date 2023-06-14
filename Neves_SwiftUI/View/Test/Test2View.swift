//
//  Test2View.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/6.
//

import SwiftUI

struct Test2View: View {
    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text("123")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.randomColor)
                            .background(.randomColor)
                        Text("dssss")
                            .foregroundColor(.randomColor(0.7))
                    }

                    Spacer(minLength: 0) // 默认都会有一些间距的，当内容很长不想有间距就得手动设置为0

                    Image(systemName: "person.crop.circle") // 这种好像有一定间距？

                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 36, height: 36)
                        .foregroundColor(.white)
                        .background(.randomColor)
                        .clipShape(Circle())
                }
                .padding(30)
                .padding(.top, 30)
                .frame(maxWidth: .infinity,
                       maxHeight: 460)
                .background(.randomColor)
            }
        }
    }
}

struct Test2View_Previews: PreviewProvider {
    static var previews: some View {
        Test2View()
    }
}
