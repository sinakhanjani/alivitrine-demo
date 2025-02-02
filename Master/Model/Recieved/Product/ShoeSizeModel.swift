//
//  ShoeSizeModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/26/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//
import ObjectMapper

struct ShoeSizeModel : Mappable {

    var id : Int?
    var product_id : String?
    var size : String?
    var count : String?
    var age_size_id : String?

    init?(map: Map) {

    }
    
    init() {
        
    }

    mutating func mapping(map: Map) {
        product_id <- map ["product_id"]
        size <- map ["size"]
        count <- map ["count"]
        age_size_id <- map ["age_size_id"]
    }
}
