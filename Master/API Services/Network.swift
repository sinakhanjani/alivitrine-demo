//
//  Network.swift
//  Master
//
//  Created by Mohammad Fallah on 11/15/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper

enum NetworkResponse<T> {
    case success (T)
    case error(Error)
}
extension NetworkResponse {
    func ifSuccess (handler : (T) -> Void) {
        switch self {
        case .success(let data):
            handler(data)
        default:
            break
        }
    }
    func ifFailed (handler : (Error) -> Void) {
        switch self {
        case .error(let error):
            handler(error)
        default:
            break
        }
    }
}
class Network<V : Mappable> : Disposable {
    typealias NetworkResult = (NetworkResponse<V>) -> Void
    let url : URL?
    var params : Parameters?
    var urlRequest : DataRequest?
    var ignoreAuth = false
    var method : HTTPMethod?
    
    func withPost () -> Network {
        method = .post
        return self
    }
    func withGet () -> Network {
        method = .post
        return self
    }
    func withPatch ()-> Network {
        method = .post
        return self
    }
    func withDelete () -> Network {
        method = .post
        return self
    }
    func post (callback :  @escaping NetworkResult) -> Disposable {
        return request(method: .post,callback: callback)
    }
    func patch (callback :  @escaping NetworkResult) -> Disposable {
        return request(method: .patch,callback: callback)
    }
    func delete (callback :  @escaping NetworkResult) -> Disposable {
        return request(method: .delete,callback: callback)
    }
    func get (callback :  @escaping NetworkResult) -> Disposable {
        return request(method: .get,callback: callback)
    }
    func addParameter (key:String,value:Any?) -> Network {
        if (params == nil) { params = Parameters() }
        params?[key] = value
        return self
    }
    func addParameters (params : Parameters?)-> Network {
        if params != nil {
            self.params = params
        }
        return self
    }
    func appendParameters (params : Parameters?) -> Network {
        if let params = params {
            for i in params {
                self.params?[i.key] = i.value
            }
        }
        return self
    }
    func addAllParameters(_ params : [String:Any]) -> Network  {
        self.params = params
        return self
    }
    
    func fire (callback :  @escaping NetworkResult) -> Disposable {
        return request(method: method ?? .get,callback: callback)
    }
    
    private func request (method : HTTPMethod = .get,callback : @escaping  NetworkResult) -> Disposable {
        if var url = self.url {
            var header : HTTPHeaders = HTTPHeaders()
            
            header["Accept"] = "application/json"
            if let t = Authentication.auth.token , !self.ignoreAuth {
                header["Authorization"] =  "Bearer " + String(t)
            }
            if method == .get && params != nil {
                url = url.withQuries(params!) ?? url
                self.params = nil
            }
            print("========REQUEST=======")
            print("url : \(url)")
            print("params: \(String(describing: params))")
            let rq = AF.request(url, method: method, parameters: self.params, encoding: JSONEncoding.default, headers: header)
                .validate().response { result in
                    print("======RESULT======")
                    print("\(result)")
                    if result.error?.localizedDescription.contains("The Internet connection appears to be offline.") ?? false ||
                        result.error?.localizedDescription.contains("The request timed out.") ?? false {
                        callback(.error(NetworkErrors.TimeOuted))
                   }
                    if result.data == nil {
                        return
                    }
                    let encryptedResult = String(data: result.data!, encoding: .utf8) ?? "encryptedResult is nil"
                    print("\(encryptedResult)")
                    if (result.response?.statusCode == 200) {
                        if let final = Mapper<V>().map(JSONString: encryptedResult) {
                            callback(.success(final))
                            return
                        }
                    }
                    else if (result.response?.statusCode == 403) {
                        callback(.error(NetworkErrors.Unathorized))
                    }
                    else if (result.response?.statusCode == 401) {
                        callback(.error(NetworkErrors.Unathorized))
                    }
                    else if (result.response?.statusCode == 500) {
                        callback(.error(NetworkErrors.InternalError))
                    }
                    else if (result.response?.statusCode == 400) {
                        callback(.error(NetworkErrors.BadParameters))
                    }
                    callback(.error(NetworkErrors.InternalError))
            }
            self.urlRequest = rq
        }
        return self
    }
    
    override func dispose() {
        urlRequest?.cancel()
    }
    
    init(url : String,ignoreAuth : Bool = false) {
        self.url = URL(string: url)
        self.ignoreAuth = ignoreAuth
    }
    
    init(url : URL,ignoreAuth : Bool = false) {
        self.url = url
        self.ignoreAuth = ignoreAuth
    }
    
    func  requestWithFiles(images : [String:Data?]? = nil,allFileNamed name : String? = nil,callback : @escaping  NetworkResult){
        guard let url = url else {return}
        var headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        if let t = Authentication.auth.token {
            headers["Authorization"] =  "Bearer " + String(t)
        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in self.params ?? [:] {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if images != nil {
            for (imageData) in images! {
                if let data = imageData.value {
                    let uuid = UUID().uuidString
                    multipartFormData.append(data, withName: name ?? imageData.key, fileName: "\(uuid).jpg", mimeType: "image/jpg")
                }
            }
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers, interceptor: nil, fileManager: FileManager.init()).responseData {(result) in
                if result.error?.localizedDescription.contains("The Internet connection appears to be offline.") ?? false ||
                    result.error?.localizedDescription.contains("The request timed out.") ?? false || result.error?.localizedDescription.contains("The network connection was lost.") ?? false {
                    callback(.error(NetworkErrors.TimeOuted))
                }
             if result.data == nil {
                 return
             }
            let encryptedResult = String(data: result.data!, encoding: .utf8) ?? "encryptedResult is nil"
            if (result.response?.statusCode == 200) {
                if let final = Mapper<V>().map(JSONString: encryptedResult) {
                    callback(.success(final))
                }
            }
            else if (result.response?.statusCode == 403) {
                callback(.error(NetworkErrors.Unathorized))
            }
            else if (result.response?.statusCode == 401) {
                callback(.error(NetworkErrors.Unathorized))
            }
            else if (result.response?.statusCode == 500) {
                callback(.error(NetworkErrors.InternalError))
            }
            else if (result.response?.statusCode == 400) {
                callback(.error(NetworkErrors.BadParameters))
            }

        }
           
    }
}
