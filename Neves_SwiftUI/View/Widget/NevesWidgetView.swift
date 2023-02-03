//
//  NevesWidgetView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/9.
//

import SwiftUI

/**
 * 小组件的跳转：
 *  1. `XXX.widgetURL(...)`：三种类型（小中大）的小组件均可使用该方式进行跳转，会给【整个小组件】添加跳转。
 *  2. `Link`：只有`Medium(中杯)`和`Large(大杯)`类型的小组件可以使用该方式进行跳转，可以给小组件的【局部视图】添加跳转。
 * 参考：https://juejin.cn/post/6903347267433365512
 */

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
                    Color.pink
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                // 点击局部视图跳转
                Link(destination: URL(string: "urlschema://jp_link_01")!) {
                    Text(store.content)
                        .font(.largeTitle)
                }
                
                // 点击局部视图跳转
                Link(destination: URL(string: "urlschema://jp_link_02")!) {
                    Text(cacheEmoji)
                        .font(.largeTitle)
                }
                
                Text(lastCacheTime)
                    .font(.subheadline)
                
                Text(currentCacheTime)
                    .font(.subheadline)
            }
            .baseShadow()
        }
        // 点击整个小组件跳转
        .widgetURL(URL(string: "urlschema://jp_link_00"))
    }
    
    var cacheEmoji: String {
        UserDefaults(suiteName: AppGroups.identifier)?.object(forKey: "widget_emoji") as? String ?? "❌"
    }
    
    var lastCacheTime: String {
        "上次：" + (UserDefaults(suiteName: AppGroups.identifier)?.object(forKey: "widget_lastDateStr") as? String ?? "❌")
    }
    
    var currentCacheTime: String {
        "这次：" + (UserDefaults(suiteName: AppGroups.identifier)?.object(forKey: "widget_currentDateStr") as? String ?? "❌")
    }
}

struct NevesWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NevesWidgetView()
    }
}
