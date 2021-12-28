//
//  GeometryReaderTestView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/20.
//

import SwiftUI

struct GeometryReaderTestView: View {
    
    @State var translation = CGSize.zero
    
    var body: some View {
        VStack {
            GeometryReaderView()
                .offset(x: translation.width, y: translation.height)
                .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            translation = value.translation
                        }
                        .onEnded { _ in
                            translation = .zero
                        }
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}

struct GeometryReaderTestView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReaderTestView()
    }
}

struct GeometryReaderView: View {
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading) {
                Text("safeAreaInsets t: \(String(format: "%.1lf", reader.safeAreaInsets.top)), l: \(String(format: "%.1lf", reader.safeAreaInsets.leading)), b: \(String(format: "%.1lf", reader.safeAreaInsets.bottom)), r: \(String(format: "%.1lf", reader.safeAreaInsets.trailing))")
                    .foregroundColor(.red)
                Text("local frame: x: \(String(format: "%.1lf", reader.frame(in: .local).origin.x)), y: \(String(format: "%.1lf", reader.frame(in: .local).origin.y)), w: \(String(format: "%.1lf", reader.frame(in: .local).size.width)), h: \(String(format: "%.1lf", reader.frame(in: .local).size.height))")
                    .foregroundColor(.green)
                Text("global frame: x: \(String(format: "%.1lf", reader.frame(in: .global).origin.x)), y: \(String(format: "%.1lf", reader.frame(in: .global).origin.y)), w: \(String(format: "%.1lf", reader.frame(in: .global).size.width)), h: \(String(format: "%.1lf", reader.frame(in: .global).size.height))")
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: 350, maxHeight: 150)
        .background(Color.black)
    }
}
