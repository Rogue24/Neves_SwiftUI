//
//  TestUIView.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2022/7/15.
//

import SwiftUI
import UIKit

struct TestUIView: UIViewRepresentable {
    var color: UIColor
    var index: Int
    
    /// 创建视图
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = color
        
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.tag = 200
        label.text = "\(index)"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: view.widthAnchor),
            label.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        
        JPrint("新建了？！")
        return view
    }
    
    /// 刷新视图
    func updateUIView(_ uiView: UIViewType, context: Context) {
        JPrint("更新了？！")
        
        uiView.backgroundColor = color
        
        guard let label = uiView.viewWithTag(200) as? UILabel else { return }
        label.text = "\(index)"
    }
}
