//
//  FavoriteResponseModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/20/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import ObjectMapper

struct FavoriteResponseModel : Mappable {

    var shops : [MineralModel]?
    var products : [MineralModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        products <- map ["products"]
        shops <- map ["shops"]
    }
}
