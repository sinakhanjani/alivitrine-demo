//
//  AddProductStep1Response.swift
//  Master
//
//  Created by Mohammad Fallah on 1/24/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

//  Created By GsonToMapper (MohammadFallah)

import ObjectMapper

struct AddProductStep1Response : Mappable {

    var result : String?
    var message : String?
    var productId : Int?
    var specifications : [SpecificationModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        result <- map ["result"]
        message <- map ["message"]
        productId <- map ["productId"]
        specifications <- map ["specifications"]
    }
}
