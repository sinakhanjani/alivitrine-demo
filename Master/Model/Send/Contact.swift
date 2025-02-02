//
//  Contact.swift
//  Master
//
//  Created by Mohammad Fallah on 1/21/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper
struct ContactModel : Mappable {
    
    var mobile : String?
    var name : String?
    var registerd : Int?
   
    init(mobile : String,name : String) {
        self.mobile = mobile
        self.name = name
    }
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        mobile <- map["mobile"]
        name <- map["name"]
        registerd <- map["registerd"]
    }
}

struct ContactsResponseModel : Mappable {
    
    var contacts : [ContactModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        contacts <- map["contacts"]
    }
}
