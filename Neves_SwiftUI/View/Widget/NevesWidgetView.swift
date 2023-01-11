//
//  NevesWidgetView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/9.
//

import SwiftUI

struct NevesWidgetView: View {
    @StateObject var store = NevesWidgetStore()
    
    var body: some View {
        ZStack {
            Group {
                if let image = store.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.black
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text(store.content)
                .font(.largeTitle)
                .baseShadow()
        }
    }
}

struct NevesWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NevesWidgetView()
    }
}
