//
//  CatAPIManager+Response.swift
//  Neves_SwiftUI
//
//  Created by aa on 2024/3/24.
//

import SwiftUI

extension CatAPIManager {
    struct ImageResponse: Decodable {
        let id: String
        let url: URL
        let width: CGFloat
        let height: CGFloat
    }
    
    struct FavoriteCreationResponse: Decodable {
        let id: Int
    }
}
