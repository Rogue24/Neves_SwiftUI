//
//  SFSymbol.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/7/30.
//

import SwiftUI

enum SFSymbol: String {
    case minus
    case moon
    case pencil
    case plus
    case sunMax = "sun.max"
    case forkKnife = "fork.knife"
    case chevronUp = "chevron.up"
    case chevronDown = "chevron.down"
    case photoArtframe = "photo.artframe"
    case plusCircleFill = "plus.circle.fill"
    case infoCircleFill = "info.circle.fill"
    case xmarkCircleFill = "xmark.circle.fill"
    case personCropCircle = "person.crop.circle"
    case checkmarkCircleFill = "checkmark.circle.fill"
}

extension SFSymbol: View {
    var body: Image {
        Image(systemName: rawValue)
    }
    
    /// 自定义`resizable`方法，为了直接能通过枚举值就能调用`Image`的方法
    /// 不自定义的话，外部想直接通过枚举值来调用`resizable`就得先获取`body`才能获取`Image`的相关方法
    /// 由于`resizable`最常用，所以先自定义这个方法，其他`Image`的方法后续用到时再补充。
    func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode = .stretch) -> Image {
        self.body.resizable(capInsets: capInsets, resizingMode: resizingMode)
    }
}

extension Label where Title == Text, Icon == Image {
    init(_ text: String, sfs: SFSymbol) {
        self.init(text, systemImage: sfs.rawValue)
    }
}
