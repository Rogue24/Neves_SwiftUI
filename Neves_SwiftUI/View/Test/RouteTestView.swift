//
//  RouteTestView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/2/7.
//

import SwiftUI
import FunnyButton_SwiftUI

var routeTag = 0

struct RouteTestView: View {
    @EnvironmentObject var router: NavigationRouter
    
    @State var isPresent = false
    
    @State var tag: Int = -1
    
    var isPpp = false
    
    var body: some View {
        ZStack {
            Color.randomColor.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Button("Push") {
                    router.path.append(.RouteTest)
                }
                Button("Present") {
                    isPresent = true
                }
                Button("Close") {
                    if isPresent {
                        isPresent = false
                    } else {
                        router.path.removeLast()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isPresent) {
            RouteTestView(isPpp: true)
        }
//        .funnyAction {
//            print("router.path: \(router.path)")
//        }
        .onAppear() {
            if tag == -1 {
                tag = routeTag
                routeTag += 1
            }
            print("onAppear --- tag: \(tag), router.path: \(router.path)")
            
            guard isPpp else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if let window = UIApplication.shared.windows.last {
                    let view = UIView(frame: [200, 200, 100, 100])
                    view.backgroundColor = .randomColor
                    window.addSubview(view)
                    print("222 Window: \(window.subviews)")
                }
                
            }
        }
        .onDisappear() {
            print("onDisappear --- tag: \(tag), router.path: \(router.path)")
        }
    }
}

struct RouteTestView_Previews: PreviewProvider {
    static var previews: some View {
        RouteTestView()
    }
}
