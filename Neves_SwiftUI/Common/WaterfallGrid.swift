//
//  WaterfallGrid.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/2/27.
//
//  参考：http://www.demodashi.com/demo/19061.html

import SwiftUI

struct WaterfallGrid<Content: View, T: Identifiable>: View where T: Hashable {
    var columns: Int
    var showsIndicators: Bool
    var verSpacing: CGFloat
    var horSpacing: CGFloat
    var list: [T]
    var content: (T) -> Content
    
    init(columns: Int,
         showsIndicators: Bool = false,
         verSpacing: CGFloat = 0,
         horSpacing: CGFloat = 0,
         list: [T],
         @ViewBuilder content: @escaping (T) -> Content)
    {
        self.columns = columns
        self.showsIndicators = showsIndicators
        self.verSpacing = verSpacing
        self.horSpacing = horSpacing
        self.list = list
        self.content = content
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            HStack(alignment: .top, spacing: horSpacing) {
                ForEach(columnList, id: \.self) { columnData in
                    LazyVStack(spacing: verSpacing) {
                        ForEach(columnData) { object in
                            content(object)
                        }
                    }
                }
            }
        }
    }
}

private extension WaterfallGrid {
    var columnList: [[T]] {
        guard columns >= 1 else { return [] }

        var columnList: [[T]] = Array(repeating: [], count: columns)

        let maxIndex = columns - 1
        var curIndex = 0
        for object in list {
            columnList[curIndex].append(object)
            if curIndex == maxIndex {
                curIndex = 0
            } else {
                curIndex += 1
            }
        }

        return columnList
    }
}
