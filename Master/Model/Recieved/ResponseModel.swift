//
//  ResponseModel.swift
//  Master
//
//  Created by Mohammad Fallah on 11/15/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

protocol ObjectModelName {
     var objName : String {get}
}
struct ResponseModel<T : Mappable> : Mappable {
    
    var result : String?
    var message : String?
    var data : T?
    
    init?(map: Map) {
    
    }
    
    mutating func mapping(map: Map) {
        result <- map["resualt"]
        if result == nil {
            result <- map["result"]
        }
        message <- map["message"]
        data <- map[(T.self as? ObjectModelName)?.objName ?? T.getObjectedName()]
    }
}
extension Mappable {
    static func getObjectedName () -> String {
        let name = String(describing: self)
        let newName = name.prefix(1).lowercased() + name.dropFirst()
        return newName.replacingOccurrences(of: "Model", with: "")
    }
}
