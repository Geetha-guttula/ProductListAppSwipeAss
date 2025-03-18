//
//  ProductListModel.swift
//  ProductsAppSwipe
//
//  Created by hb on 03/02/25.
//

import Foundation


struct ProductDetails: Codable  , Hashable{
    var id : String = UUID().uuidString
    let image: String?
    let price: Double?
    let productName: String?
    let productType: String?
    let tax: Double?

    enum CodingKeys: String, CodingKey {
        case image
        case price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
}
