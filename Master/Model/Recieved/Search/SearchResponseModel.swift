//
//  SearchResponseModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/20/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//


import ObjectMapper

struct SearchResponseModel : Mappable {

    var shops : [MineralModel]?
    var category : CategoryChildModel?
    var specifications : [SpecificationModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        shops <- map ["shops"]
        category <- map ["category"]
        specifications <- map ["specifications"]
    }
}
