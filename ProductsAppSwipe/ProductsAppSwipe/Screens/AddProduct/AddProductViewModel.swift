//
//  AddProductViewModel.swift
//  ProductsAppSwipe
//
//  Created by hb on 03/02/25.
//

import Foundation
import UIKit
class AddProductViewModel : ObservableObject{
    @Published var addProductResponce : AddProductResponse?
    func uploadProduct(
        productName: String,
        productType: String,
        price: String,
        tax: String,
        images: [UIImage]?
        
    ) {
        let url = URL(string: "https://app.getswipe.in/api/public/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Append Text Fields
        let parameters: [String: String] = [
            "product_name": productName,
            "product_type": productType,
            "price": price,
            "tax": tax
        ]

        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        // Append Image Files (Optional)
        if let images = images {
            for (index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    let fileName = "image\(index).jpg"
                    let mimeType = "image/jpeg"

                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                    body.append(imageData)
                    body.append("\r\n".data(using: .utf8)!)
                }
            }
        }

        // Close the multipart form
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        // Create URLSession task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
//                completion(.failure(error))
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
//                completion(.success(responseString))
                do {
                    let addProductData = try JSONDecoder().decode(AddProductResponse.self, from: data)
                    print(addProductData)
                    self.addProductResponce = addProductData
                } catch let jsonError {
                    print("Failed to decode json", jsonError)
                }
            }
            
           
        }

        task.resume()
    }

}
