//
//  NetworkHelper.swift
//  ProductsAppSwipe
//
//  Created by hb on 03/02/25.
//

import Foundation
import Alamofire
struct NetworkError: Error {
   let code: Int?
   let message: String?
}

final class AppConsole {
    class func printLog(_ data: Any, hint: String = "") {
        #if DEBUG
            print(hint)
            print(data)
        #endif
    }
}
struct ErrorMessage {
   static let offline = "Please check your internet connection."
   static let parserError = "Unable to decode data"
   static let invalidUrl = "Invalid URL"
   static let memoryReleased = "SELF released from memory"
   static let commonServerError = "Unable to perform this action, please try again"
   static let loginMessage = "Please login to continue"
   static let notDeliverableMessage = "Hey, sorry to let you know that out of your selection only few items are available in your selected address/pincode. Please update the cart"
}

final class NetworkService {
    private  static var managerStore: [String : Alamofire.Session] = [:]
    private  static var DEFAULT_TIMEOUT: TimeInterval = 120.0
    private  static let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    private init() {}
    static let boundaryConstant = "aRandomBoundary1837440"
    private static let manager: Session = { () -> Session in
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 12000
        configuration.timeoutIntervalForResource = 12000
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
}
struct Network {
    static let reachabilityManager = NetworkReachabilityManager()
    
    static func startMonitorReachability()  {
        reachabilityManager?.startListening(onUpdatePerforming: { (status) in })
    }
    
    static func isConnected() -> Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    static func cancelAllRequests() {
        Alamofire.Session.default.session.getAllTasks { (tasks) in
            tasks.forEach{ $0.cancel() }
        }
    }
}
extension NetworkService {
    class func dataRequestWithModel<T: Decodable>(with inputRequest: RouterProtocol, completion: @escaping(T?, NetworkError?) -> Void) {
        guard Network.isConnected() else {
            completion(nil, NetworkError(code: -1000, message: ErrorMessage.invalidUrl))
            return
        }
        let url =  inputRequest.baseUrlString + inputRequest.path
        guard let urlTemp = URL(string: url) else {
            completion(nil,NetworkError(code: -1000, message: ErrorMessage.invalidUrl))
            return
        }
        AppConsole.printLog(url)
        AppConsole.printLog(inputRequest.method)
        AppConsole.printLog(inputRequest.parameters ?? "")
        let encoding: ParameterEncoding = (inputRequest.method == .get ? URLEncoding.default : JSONEncoding.default)
        let headers = HTTPHeaders.init(inputRequest.headers ?? [:])
        let uploadRequest = AF.request(urlTemp, method: inputRequest.method, parameters: inputRequest.parameters, encoding: encoding, headers: headers)
        AppConsole.printLog(headers)
        uploadRequest.responseData(completionHandler: { (response) in
            AppConsole.printLog("=== API RESPONSE ===")
            switch response.result {
            case .success(let value):
                if let responseDataString = String(data: value, encoding: .utf8) {
                    AppConsole.printLog("Response: \(responseDataString)")
                } else {
                    AppConsole.printLog("Failed to convert response data to string")
                }
                do  {
                    let decoder = JSONDecoder()
                    let decodedValue = try decoder.decode(T.self, from: value)
                    completion(decodedValue, nil)
                } catch {
                    AppConsole.printLog("APP_PARSER_ERROR")
                    completion(nil, NetworkError(code: 0, message: ErrorMessage.parserError))
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .dataCorrupted(let context):
                            AppConsole.printLog("Data Corrupted: \(context.debugDescription)")
                            completion(nil, NetworkError(code: 0, message: "Data Corrupted: \(context.debugDescription)"))
                        case .keyNotFound(_, let context):
                            let keyPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
                            AppConsole.printLog("Key Not Found: \(keyPath), \(context.debugDescription)")
                            completion(nil, NetworkError(code: 0, message:"Key Not Found: \(keyPath), \(context.debugDescription)"))
                        case .typeMismatch(_, let context):
                            let keyPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
                            AppConsole.printLog("Type Mismatch: \(keyPath), \(context.debugDescription)")
                            completion(nil, NetworkError(code: 0, message: "Type Mismatch: \(keyPath), \(context.debugDescription)"))
                        case .valueNotFound(_, let context):
                            let keyPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
                            AppConsole.printLog("Value Not Found: \(keyPath), \(context.debugDescription)")
                            completion(nil, NetworkError(code: 0, message: "Value Not Found: \(keyPath), \(context.debugDescription)"))
                        @unknown default:
                            AppConsole.printLog("Unknown decoding error occurred")
                            completion(nil, NetworkError(code: 0, message: "Unknown decoding error occurred"))
                        }
                    } else {
                        AppConsole.printLog("Unknown error occurred during decoding")
                        completion(nil, NetworkError(code: 0, message: ErrorMessage.parserError))
                    }
                }
            case .failure(let error):
                AppConsole.printLog("FAIL")
                completion(nil, NetworkError(code: 0, message: error.localizedDescription))
            }
        })
    }
}
