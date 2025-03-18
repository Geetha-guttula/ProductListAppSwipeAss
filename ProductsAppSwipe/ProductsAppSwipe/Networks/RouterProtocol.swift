//
//  RouterProtocol.swift
//  FieldHand
//
//  Created by RamiReddy on 04/12/24.
//

import Foundation
import UIKit
import Alamofire

public protocol RouterProtocol: URLRequestConvertible {
    var method: HTTPMethod { get }
    var baseUrlString: String  { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var parameterEncoding: ParameterEncoding { get }
    var headers: [String: String]? { get }
    var arrayParameters: [String: Any]? { get }
    var deviceInfo: [String: Any]? { get }
}

public extension RouterProtocol {
    
    func asURLRequest() throws -> URLRequest {
 
        guard let url = URL(string: self.baseUrlString) else {
            throw(NetworkError(code: -1000, message: ErrorMessage.invalidUrl))
        }
        let urlStr = (path.contains("http://") || path.contains("https://")) ? URL(string: path)! : url.appendingPathComponent(path)
        guard let urlFinal = URL(string: urlStr.absoluteString.removingPercentEncoding ?? "") else {
            
            throw(NetworkError(code: -1000, message: ErrorMessage.invalidUrl))
        }
  
        var request = URLRequest(url:urlFinal)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.timeoutInterval = 60.0 * 0.5
        
        do {
            if let arrayParameters = arrayParameters {
                let req = try JSONEncoding.default.encode(request as URLRequestConvertible, with: arrayParameters)
                return req
            } else {
                let req = try URLEncoding.default.encode(request as URLRequestConvertible, with: parameters)
                return req
            }
        } catch let error {
            print("error occured \(error)")
        }
        return request
    }
    
    func asURLRequestURL() throws -> URL  {
        guard let url = URL(string: self.baseUrlString) else {
            throw(NetworkError(code: -1000, message: ErrorMessage.invalidUrl))
        }
        let urlStr = (path.contains("http://") || path.contains("https://")) ? URL(string: path)! : url.appendingPathComponent(path)
        guard let urlFinal = URL(string: urlStr.absoluteString.removingPercentEncoding ?? "") else {
            
            throw(NetworkError(code: -1000, message: ErrorMessage.invalidUrl))
        }
        return urlFinal
    }
    func getPostString(params:[String:Any]?) -> String {
        var data = [String]()
        if let parameters = params {
            for(key, value) in parameters {
                data.append(key + "=\(value)")
            }
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    
    var arrayParameters: [Any]? {
        return nil
    }
}
