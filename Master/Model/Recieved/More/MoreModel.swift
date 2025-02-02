//
//  MoreModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/19/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper
struct MoreModel : Mappable {
    
    var data : [MineralModel]?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        data <- map["special_products"]
        if data == nil {
            data <- map["best_brands"]
        }
        if data == nil {
            data <- map["special_brands"]
        }
        if data == nil {
            data <- map["new_products"]
        }
        if data == nil {
            data <- map["shops"]
        }
        if data == nil {
            data <- map["products"]
        }
    }
}
