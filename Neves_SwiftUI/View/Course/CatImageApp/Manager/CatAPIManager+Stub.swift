//
//  CatAPIManager+Stub.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2024/3/10.
//

import SwiftUI

// MARK: - For Test
extension CatAPIManager.Endpoint {
    var stub: Data {
        let string: String
        
        switch self {
        case .images:
            string = """
            [{"id":"6st","url":"https://cdn2.thecatapi.com/images/6st.jpg","width":1024,"height":684},{"id":"9qi","url":"https://cdn2.thecatapi.com/images/9qi.jpg","width":894,"height":894},{"id":"apd","url":"https://cdn2.thecatapi.com/images/apd.jpg","width":3888,"height":2592},{"id":"bd5","url":"https://cdn2.thecatapi.com/images/bd5.png","width":413,"height":414},{"id":"bd8","url":"https://cdn2.thecatapi.com/images/bd8.png","width":500,"height":333},{"id":"cif","url":"https://cdn2.thecatapi.com/images/cif.jpg","width":500,"height":334},{"id":"d5k","url":"https://cdn2.thecatapi.com/images/d5k.gif","width":480,"height":272},{"id":"MTYzMDM2OQ","url":"https://cdn2.thecatapi.com/images/MTYzMDM2OQ.jpg","width":1936,"height":2592},{"id":"wQz67QCme","url":"https://cdn2.thecatapi.com/images/wQz67QCme.jpg","width":750,"height":937},{"id":"TYQKhQ3mn","url":"https://cdn2.thecatapi.com/images/TYQKhQ3mn.jpg","width":1440,"height":1440}]
            """
            
        case .addToFavorite:
            string = """
            {
                "id":100038507
            }
            """
            
        case let .favorites(page, limit):
            let all = """
            {"id":101329412,"user_id":"tpxmop","image_id":"4sb","sub_id":null,"created_at":"2023-04-18T03:25:53.000Z","image":{"id":"4sb","url":"https://cdn2.thecatapi.com/images/4sb.jpg"}},{"id":101329439,"user_id":"tpxmop","image_id":"aef","sub_id":null,"created_at":"2023-04-18T05:07:47.000Z","image":{"id":"aef","url":"https://cdn2.thecatapi.com/images/aef.jpg"}},{"id":101329440,"user_id":"tpxmop","image_id":"gd","sub_id":null,"created_at":"2023-04-18T05:09:45.000Z","image":{"id":"gd","url":"https://cdn2.thecatapi.com/images/gd.jpg"}},{"id":101329442,"user_id":"tpxmop","image_id":"125","sub_id":null,"created_at":"2023-04-18T05:13:27.000Z","image":{"id":"125","url":"https://cdn2.thecatapi.com/images/125.jpg"}},{"id":232343132,"user_id":"tpxmop","image_id":"4en","sub_id":null,"created_at":"2023-05-24T02:45:08.000Z","image":{"id":"4en","url":"https://cdn2.thecatapi.com/images/4en.jpg"}},{"id":232343133,"user_id":"tpxmop","image_id":"beh","sub_id":null,"created_at":"2023-05-24T02:45:15.000Z","image":{"id":"beh","url":"https://cdn2.thecatapi.com/images/beh.jpg"}},{"id":232343134,"user_id":"tpxmop","image_id":"cqk","sub_id":null,"created_at":"2023-05-24T02:45:18.000Z","image":{"id":"cqk","url":"https://cdn2.thecatapi.com/images/cqk.jpg"}},{"id":232343135,"user_id":"tpxmop","image_id":"9jg","sub_id":null,"created_at":"2023-05-24T02:45:59.000Z","image":{"id":"9jg","url":"https://cdn2.thecatapi.com/images/9jg.jpg"}},{"id":232343136,"user_id":"tpxmop","image_id":"e54","sub_id":null,"created_at":"2023-05-24T02:46:25.000Z","image":{"id":"e54","url":"https://cdn2.thecatapi.com/images/e54.jpg"}},{"id":232343137,"user_id":"tpxmop","image_id":"MTUyNTM3Nw","sub_id":null,"created_at":"2023-05-24T02:46:29.000Z","image":{"id":"MTUyNTM3Nw","url":"https://cdn2.thecatapi.com/images/MTUyNTM3Nw.jpg"}},{"id":232343138,"user_id":"tpxmop","image_id":"UrYSVFQZo","sub_id":null,"created_at":"2023-05-24T02:46:36.000Z","image":{"id":"UrYSVFQZo","url":"https://cdn2.thecatapi.com/images/UrYSVFQZo.jpg"}},{"id":232343139,"user_id":"tpxmop","image_id":"9g5","sub_id":null,"created_at":"2023-05-24T02:46:46.000Z","image":{"id":"9g5","url":"https://cdn2.thecatapi.com/images/9g5.jpg"}},{"id":232343140,"user_id":"tpxmop","image_id":"6mt","sub_id":null,"created_at":"2023-05-24T02:52:38.000Z","image":{"id":"6mt","url":"https://cdn2.thecatapi.com/images/6mt.jpg"}}
            """
            
            // 1.对一整段json字符串根据"}},"拆分每一个数据，获取总数组
            // 注意：根据"}},"拆分出来的每一个字符串元素是不包含这个"}},"的
            let array = all.split(separator: "}},")
            
            // 2.获取目标范围内的数组
            // dropFirst - 获取去掉前x个元素的剩余元素
            // prefix - 获取前x个元素
            let pagination = array
                .dropFirst(page * limit) // 去掉前几页的元素
                .prefix(limit) // 获取当前页的元素
            
            // 3.把拆分出来的字符串数组重新拼接成数组形式的json字符串
            if pagination.isEmpty {
                string = "[]"
                break
            }
            
            // 由于执行了`split(separator: "}},")`导致【除最后一个】的其他元素最后的"}},"被移除，
            // 因此需要需要将其添加回去。
            var str = pagination.joined(separator: "}},")
            if str.count >= 2 {
                let lastTwoChars = str.suffix(2)
                // 如果获取范围内的最后一个元素，并不是【原数组的最后一个元素】，
                // 则需要手动补充最后的"}}"
                if lastTwoChars != "}}" {
                    str += "}}"
                }
            }
            string = "[" + str + "]"
            
        case .removeFromFavorite:
            string = ""
        }
        
        return Data(string.utf8)
    }
}
