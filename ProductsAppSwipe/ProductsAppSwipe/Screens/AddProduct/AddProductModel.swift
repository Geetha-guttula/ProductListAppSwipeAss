//
//  AddProductModel.swift
//  ProductsAppSwipe
//
//  Created by hb on 03/02/25.
//

import Foundation

struct AddProductResponse: Codable {
    let message: String
    let productDetails: ProductDetails
    let productID: Int
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case message
        case productDetails = "product_details"
        case productID = "product_id"
        case success
    }
}


