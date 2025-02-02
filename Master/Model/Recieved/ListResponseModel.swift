//
//  ListResponseModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/18/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

struct ListResponseModel<T : Mappable> : Mappable {
    
    var result : String?
    var message : String?
    var data : [T]?
    
    init?(map: Map) {
    
    }
    
    mutating func mapping(map: Map) {
        result <- map["resualt"]
        message <- map["message"]
        data <- map[(T.self as? ObjectModelName)?.objName ?? T.getObjectedName()]
    }
}
