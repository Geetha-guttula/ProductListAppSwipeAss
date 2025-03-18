//
//  AddProductView.swift
//  ProductsAppSwipe
//
//  Created by hb on 01/02/25.
//

import SwiftUI

struct AddProductView: View {
    @State var productNname: AppInputModel = .init(type: .name)
    @State var price: AppInputModel = .init(type: .prics)
    @State var taxRate: AppInputModel = .init(type: .tax)
    @State private var showproductNameValidation : Bool = false
    @State private var priceValidation = false
    @State private var taxRateValidation = false
    @FocusState private var focusedField: InputType?
    @State var productType : DepartmentModel = DepartmentModel(departmentId: 1 , departmentTitle: "Product" )
    @StateObject var addProductViewModel : AddProductViewModel = AddProductViewModel()

    var body: some View {
        ScrollView {
            VStack (alignment: .leading , spacing: 20){
                Text("Add Product")
                    .font(.system(size: 25 , weight: .bold))
                   
                VStack(alignment: .leading) {
                    Text("Select Type")
                        .foregroundStyle(.black)
                    HStack {
    //                    Text(department.departmentTitle ?? "")
    //                        .foregroundStyle(.black)
    //                    Spacer()
                        DropDown(selectedOption: $productType)
                    }
                    .padding(.horizontal)
                    .frame(height: 44)
                    .overlay( RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 1) )
                }
     
                AppNameInput(imputType: $productNname ) {
                    
                }
                AppNameInput(imputType: $price) {
                    
                }
                AppNameInput(imputType: $taxRate) {
                    
                }
              
                    AppPrimaryButton(title: "Submit") {
                        addProducts()
                    }
               
                
                Spacer()
            }
            .padding()
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)

        }
        .onReceive(addProductViewModel.$addProductResponce) { data in
            if let responce = data {
//                productsList = responce
                print(responce)
            }
        }
    }
    
    func addProducts() {
        addProductViewModel.uploadProduct(
            productName: productNname.input,
            productType: productType.departmentTitle ?? "",
            price: price.input,
            tax: taxRate.input,
              images: nil // No images
          )
    }
}

#Preview {
    AddProductView()
}

enum InputType {
    case name
    case prics
    case tax
    
    var title : String {
        switch self {
        case .name : return "Product Name"
        case .prics : return "Price"
        case .tax : return "Tax"
        }
    }
    var placeHolder : String {
        switch self {
        case .name : return "Enter Product Name"
        case .prics : return "Enter Price"
        case .tax : return "Enter Tax"
        }
    }
    var keyBordType : UIKeyboardType {
        switch self {
        case .name : return .namePhonePad
        case .prics : return .decimalPad
        case .tax : return .decimalPad
        }
    }
    var isRequired : Bool {
        return true
    }
}

struct AppInputModel: Identifiable {
    var id: String = UUID().uuidString
    var input: String = ""
    var errorMessage: String = ""
    var type: InputType
   
   
}


//    MARK: App Primary Button


struct AppPrimaryButton: View {
    var title: String
    var showLoader: Bool = false
    var action: (() -> ())?
    @State private var isPressed = false
    
    var body: some View {
      
        Button {
            if let action {
                action()
            }
        } label: {
            ZStack {
                Text(title)
                    .foregroundStyle(showLoader ? .clear : .black)
                    . font(. system(size: 16 , weight: .bold))
                    .padding(.vertical, 13)
//                    .frame(minWidth : 350, minHeight : 45)
                    .frame(maxWidth: .infinity,maxHeight: 45)
                    
                if showLoader {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.25)
                }
            }
        }
        .background(isPressed ? .gray.opacity(0.3) : .gray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .animation(.easeInOut, value: isPressed)
        .disabled(showLoader)
    }
}

//    MARK: Validation Modifier



struct AppNameInput: View {
    @Binding var imputType : AppInputModel
//    @FocusState var fldFocusState: InputType?
    var isDisabled: Bool = false
    var isBoarderLine:Bool = true
    var onSubmit: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 3) {
                Text(imputType.type.title)
//                    .font(.appSemiBoldFont(size: 16))
                    .foregroundColor(.black)
            }
            ZStack {
                if isBoarderLine {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.black, lineWidth: 1)
                }
                HStack {
                    TextField(imputType.type.placeHolder, text: $imputType.input)
                        .keyboardType(imputType.type.keyBordType)
                        .textInputAutocapitalization(.sentences)
                        .padding(.vertical, 12)
                        .frame(height: 44)
                        .padding(.horizontal,isBoarderLine ? 10 : 0)
//                        .background(.)
//                        .font(.appSemiBoldFont(size: 16))
                        .cornerRadius(8)
//                        .onChange(of: name.input) { newValue in
//                            name.input = newValue.prefix(100).description
//                        }
                        .onSubmit { onSubmit() }
//                        .submitLabel(name.type.submitLabel)
                        .disabled(isDisabled)
//                        .focused($fldFocusState, equals: name.type)
                }
            }
            .frame(height: 44)
            .overlay(isBoarderLine ? RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 1) : nil)
//            if !name.errorMessage.isEmpty {
//                Text(name.errorMessage)
//                    .font(.appMediumFont(size: 14))
//                    .foregroundColor(.red)
//            }
        }
//        .padding(.horizontal)
//        .onChange(of: fldFocusState) { focusstate in
            
//            if focusstate == name.type {
//                name.errorMessage = ""
//            }
//        }
    }
}
struct DepartmentModel : Identifiable  , Hashable{
    var id : Int {
        return departmentId ?? 0
    }
    var departmentId : Int?
    var departmentTitle : String?
}

struct DropDown: View {
    @State var data : [ DepartmentModel] = []
    @Binding var selectedOption : DepartmentModel
    var body: some View {
        VStack {
            HStack {
                Menu {
                    ForEach(data) { option in
                        Button(action: {
                            selectedOption = option
                        }) {
                            HStack {
                                
                                Text(option.departmentTitle ?? "")
                                if selectedOption == option {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                                
                            }
                        }
                    }
                } label: {
                    Button() {
                    }  label: {
                        HStack {
                            Text(selectedOption.departmentTitle ?? "")
                                .foregroundStyle(.black)
                            Spacer()
//
                            Image(systemName: "chevron.down" )
                                .tint(Color.gray)
                                .padding()
                        }
                    }
                }
            }
        }
        .onAppear() {
            data = [DepartmentModel(departmentId: 1 , departmentTitle: "Serice" ), DepartmentModel(departmentId: 2 , departmentTitle: "Product" ) ]
            
        }
    }
}
