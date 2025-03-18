//
//  ProductListView.swift
//  ProductsAppSwipe
//
//  Created by hb on 01/02/25.
//

import SwiftUI


struct ProductListView: View {
//    var groceryDealsItems:[GroceryDealsItems]
    @StateObject var viewModel : ProductListViewModel = ProductListViewModel()
    @State var productsList : [ProductDetails] = []
      let columns  = [
        GridItem(.flexible() , spacing: 10),
        GridItem(.flexible() , spacing: 10 ),
      ]   // Three fixed-height rows
      var image:String?
      var quantity:String?
      var name:String?
      var amount:String?
      var description:String?
    init(
        
    ) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.init(red: 89 / 255, green: 13 / 255, blue: 228 / 255, alpha: 1)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    @State private var navigateToList: Bool = false
    @State var searchText : String = ""

      var body: some View {
          NavigationStack {
              
              
              VStack {
//                  HStack {
//                      Text("Products List")
//                          .font(.system(size: 22 , weight: .bold))
//                      Spacer()
//                      Image(systemName: "plus.circle.fill" )
//                          .resizable()
//                          .frame(width : 30 , height: 30)
//                          .padding()
//                          .onTapGesture {
//                              navigateToList = true
//                          }
//                      
//                  }
                  ZStack(alignment: .bottomTrailing) {
                      VStack(spacing: 20 ){
                          SearchView(searchText: $searchText )
//                              .padding(.horizontal, 10)
                              .onChange(of: searchText) { searchText in
                                  
                              }
                      ScrollView {
                         
                              LazyVGrid(columns: columns, spacing: 15) {
                                  ForEach( productsList , id: \.self) { item in
                                      ProductsItemView(item: item )
                                  }
                              }
                          }
                         
                          //                       .padding()
                      }
                      HStack {
                             
                              Spacer()
                              Image(systemName: "plus.circle.fill" )
                                  .resizable()
                                  .frame(width : 40 , height: 40)
                                  .padding()
                                  .onTapGesture {
                                      navigateToList = true
                                  }
        
                          }
                  }
              }
              .padding()
              NavigationLink(
                  destination: AddProductView(),
                  isActive: $navigateToList
              ) {
                  EmptyView()
              }
              .navigationTitle("Product List")
              .navigationBarTitleDisplayMode(.inline)
//              .ignoresSafeArea()
//              .navigationBarBackButtonHidden()
//              .navigationTitle("Add Employee")
//              .navigationBarTitleDisplayMode(.inline)
          }
         
//          .padding()
          
          .onAppear() {
//              let viewmodel = AddProductViewModel()
//              viewmodel.uploadProduct(
//                  productName: "iPhone 15",
//                  productType: "Electronics",
//                  price: "79999",
//                  tax: "18",
//                  images: nil // No images
//              ) { result in
//                  switch result {
//                  case .success(let response):
//                      print("Response: \(response)")
//                  case .failure(let error):
//                      print("Error: \(error.localizedDescription)")
//                  }
//              }
              
//              let viewModel = ProductListViewModel()
//              viewModel.getProductListData()
              
              viewModel.getProductListData()
          }
          .onReceive(viewModel.$productsListData) { data in
              if data.count > 0 {
                  productsList = data
              }

          }
      }
  }

#Preview {
    ProductListView()
}



struct ProductsItemView : View {
    var item : ProductDetails
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
//                Image( item.image ??  "oranges")
////                Image("oranges")
////
//                    .resizable()
//                    .scaledToFit()
//                    .aspectRatio(contentMode: .fit)
                VStack {
                    if let url = URL(string: item.image?.count ?? 0 > 0 ? item.image ?? "" :  "https://vx-erp-product-images.s3.ap-south-1.amazonaws.com/9_1738611901_0_image.jpg") {
                        AsyncImage(url: url) { phase in
                                   switch phase {
                                   case .empty:
                                       ProgressView() // Shows loading spinner
                                   case .success(let image):
                                       image
    //                                       .resizable()
    ////                                       .scaledToFit()  Fit inside the view
    //                                       .aspectRatio(contentMode: .fill)
    ////                                       .frame(width: 100, height: 100)
    //                                       .cornerRadius(10)
                                           .resizable()
                                           .padding()
                                           .scaledToFit()
                                           .frame(maxWidth: .infinity, maxHeight: .infinity)
                                           .clipped()
                                           .cornerRadius(10)
                                   case .failure:
                                       Image(systemName: "photo") // Fallback image
                                           .resizable()
                                           .padding()
                                           .scaledToFit()
    //                                       .frame(width: 100, height: 100)
                                           .foregroundColor(.gray)
                                   @unknown default:
                                       EmptyView()
                                   }
                               }
                    }
                }

                    
                

                VStack(spacing: 5) {
                    Button {
                        
                    } label: {
                        Text( item.productType ??  "Product")
                            .tint(.white)
                            .font(.system(size: 13 , weight: .bold))
                            .padding()
                            .frame(height: 20)
                        //                                           .padding()
                            .background(.green, in: .buttonBorder)
                        
                        
                    }
                    Text(item.productName ??  "Fresh Oranges")
                        .tint(.black)
                        .font(.system(size: 20 , weight: .medium))
                    Text( "$\(item.price ?? 0.0)")
                        .tint(.black)
                        .font(.system(size: 20 , weight: .bold))
                    HStack {
                        Button{
                            //                                                     CoreData.shared.addData(item)
                            //                                                     cartSavedItems.cartlistData.append(item)
                        } label: {
                            //                                                     Image(systemName: "dollarsign.circle")
                            Text("Tax : \(item.tax ?? 0.0)")
                                .font(.system(size: 14 , weight: .bold))
                        }
                        
                        
                    }
                    //                                             .foregroundStyle(.green)
                }
                .padding(.all , 5)
                
                Spacer()
                
            }
            Button {
                
            } label: {
                Image(systemName: "heart")
                    .foregroundColor(.black)
            }
            .padding(.top , 10 )
            .padding()
        }
        
//        .frame(width: (UIScreen.main.bounds.width / 2  - 30 ), height: 250)
//                                  .frame( height: 250)
        //                                     .background(Color.white)
        //                                     .cornerRadius(10)
        .background(
          RoundedRectangle(cornerRadius: 8)
              .fill(Color.white)
              .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        )
        .overlay(
          RoundedRectangle(cornerRadius: 8)
              .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )

    }
}

struct SearchView: View {
    @Binding var searchText: String
    @FocusState  var focusState: Bool
    var body: some View {
        VStack(spacing: 10) {
            HStack( spacing: 0) {
                TextField("Serach", text: $searchText)
//                    .font(.appRegularFont(size: 16))
//                    .padding(.vertical)
                    .background(.white)
                    .cornerRadius(8)
                    .padding()
//                    .padding(.top, 4)
//                    .padding(.leading, 10)
                    .focused($focusState)
                Image(systemName: "magnifyingglass")
                    .padding()
            }
            .padding()
            .frame(height: 40)
//            .padding(.all , 4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke((.black), lineWidth: 1)
            )
           
            
        }
//        .padding(.bottom)
    }
}
