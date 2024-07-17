//
//  SwingAnimationView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2024/7/17.
//

import SwiftUI

struct SwingAnimationView: View {
    @State private var viewPosition1: CGPoint = .zero
    @State private var viewPosition2: CGPoint = .zero
    
    var body: some View {
        VStack {
            Circle()
                .fill(.cyan)
                .frame(width: 60, height: 60)
//                .background(GeometryReader { geometry in
//                    Color.clear
//                        .preference(key: ViewPositionKey.self, value: geometry.frame(in: .global).origin)
//                })
                .coordinateSpace(name: "Circle1")
                .overlay {
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: ViewPositionKey.self, value: proxy.frame(in: .named("Circle1")).origin)
                    }
                }
                .swingAnimation(duration: 2, direction: .horizontal, distance: 100)
                .onPreferenceChange(ViewPositionKey.self) { value in
                    self.viewPosition1 = value
                }
            Text("x: \(viewPosition1.x), y: \(viewPosition1.y)")
            
            Divider()
            
            Circle()
                .fill(.red)
                .frame(width: 56, height: 56)
//                .overlay {
//                    GeometryReader { proxy in
//                        Text("\(proxy.frame(in: .global))")
//                            .frame(width: 100, height: 100)
//                            .background(.red.opacity(0.5))
//                    }
//                }
                .coordinateSpace(name: "Circle2")
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: ViewPositionKey.self, value: proxy.frame(in: .named("Circle2")).origin)
                    }
                )
                .swingAnimation(duration: 4, direction: .horizontal, distance: 280)
                .swingAnimation(duration: 1, direction: .vertical, distance: 100)
                .onPreferenceChange(ViewPositionKey.self) { value in
                    self.viewPosition2 = value
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 156, alignment: .top)
            Text("x: \(viewPosition2.x), y: \(viewPosition2.y)")
        }
        .padding()
    }
}

struct ViewPositionKey: PreferenceKey {
    typealias Value = CGPoint
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}


