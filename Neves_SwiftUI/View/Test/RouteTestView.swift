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
    var isFromPresent = false
    
    @EnvironmentObject var router: NavigationRouter
    @Environment(\.presentationMode) var presentationMode
    
    @State var isPresent = false
    @State var tag: Int = -1
    
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
                    if isFromPresent {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        router.path.removeLast()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isPresent) {
            RouteTestView(isFromPresent: true)
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
