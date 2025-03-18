//
//  ProductListViewModel.swift
//  ProductsAppSwipe
//
//  Created by hb on 03/02/25.
//

import Foundation
class ProductListViewModel : ObservableObject {
    @Published var productsListData : [ProductDetails] = []
    func getProductListData() {
        let url = URL(string: "https://app.getswipe.in/api/public/get")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"  // optional
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                print("Error while fetching data:", error)
                return
            }
            guard let data = data else {
                return
            }
            do {
                let productsData = try JSONDecoder().decode([ProductDetails].self, from: data)
                DispatchQueue.main.async {
                    self.productsListData = productsData
                    print(productsData)

                }
            } catch let jsonError {
                print("Failed to decode json", jsonError)
            }
            
        }
        task.resume()
        
    }
}
