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
            
        case .favorites:
            string = """
            [{
            "id":100038507,
            "image_id":"E8dL1Pqpz",
            "sub_id":null,
            "created_at":"2022-07-10T12:24:39.000Z",
            "image":{
                "id":"E8dL1Pqpz",
                "url":"https://cdn2.thecatapi.com/images/E8dL1Pqpz.jpg"
                }
            }]
            """
            
        case .removeFromFavorite:
            string = ""
        }
        
        return Data(string.utf8)
    }
}
