//
//  Beauty.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/8.
//

import SwiftUI

struct Beauty: Identifiable {
    let id = UUID()
    
    var title: String
    var subtitle: String
    var color: Color
    var image: UIImage
    var alignment: Alignment
    var show: Bool
    var index: Double
    
    func fitSize(forWidth width: CGFloat) -> CGSize {
        [width, width * (image.size.height / image.size.width)]
    }
    
    func fitSize(forHeight height: CGFloat) -> CGSize {
        [height * (image.size.width / image.size.height), height]
    }
}

let beauties = [
    Beauty(
        title: "Beauty for Girl1",
        subtitle: "20 sections",
        color: Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1)),
        image: UIImage.jp.fromBundle(forName: "Girl1", ofType: "jpg")!,
        alignment: .center,
        show: false,
        index: -1
    ),
    Beauty(
        title: "Beauty for Girl2",
        subtitle: "20 sections",
        color: Color(#colorLiteral(red: 0.3150139749, green: 0, blue: 0.8982304931, alpha: 1)),
        image: UIImage.jp.fromBundle(forName: "Girl2", ofType: "jpg")!,
        alignment: .center,
        show: false,
        index: -1
    ),
    Beauty(
        title: "Beauty for Girl3",
        subtitle: "12 sections",
        color: Color(#colorLiteral(red: 0, green: 0.7283110023, blue: 1, alpha: 1)),
        image: UIImage.jp.fromBundle(forName: "Girl3", ofType: "jpg")!,
        alignment: .top,
        show: false,
        index: -1
    ),
    Beauty(
        title: "Beauty for Girl4",
        subtitle: "12 sections",
        color: Color(#colorLiteral(red: 0.9467853904, green: 0.2021691203, blue: 0.3819385171, alpha: 1)),
        image: UIImage.jp.fromBundle(forName: "Girl4", ofType: "jpg")!,
        alignment: .center,
        show: false,
        index: -1
    ),
    Beauty(
        title: "Beauty for Girl5",
        subtitle: "60 sections",
        color: Color(#colorLiteral(red: 0.9721538424, green: 0.2151708901, blue: 0.5066347718, alpha: 1)),
        image: UIImage.jp.fromBundle(forName: "Girl5", ofType: "jpg")!,
        alignment: .top,
        show: false,
        index: -1
    ),
    Beauty(
        title: "Beauty for Girl6",
        subtitle: "12 sections",
        color: Color(#colorLiteral(red: 1, green: 0.3477956653, blue: 0.3974102139, alpha: 1)),
        image: UIImage.jp.fromBundle(forName: "Girl6", ofType: "jpg")!,
        alignment: .top,
        show: false,
        index: -1
    ),
    Beauty(
        title: "Beauty for Girl7",
        subtitle: "12 sections",
        color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
        image: UIImage.jp.fromBundle(forName: "Girl7", ofType: "jpg")!,
        alignment: .center,
        show: false,
        index: -1
    ),
    Beauty(
        title: "Beauty for Girl8",
        subtitle: "20 sections",
        color: Color(#colorLiteral(red: 0.1446507573, green: 0.8378821015, blue: 0.9349924922, alpha: 1)),
        image: UIImage.jp.fromBundle(forName: "Girl8", ofType: "jpg")!,
        alignment: .center,
        show: false,
        index: -1
    )
]
