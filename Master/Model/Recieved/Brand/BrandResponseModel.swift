//
//  BrandResponseModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/19/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//
import ObjectMapper

class BrandResponseModel : Mappable {

    var result : String?
    var shop : BrandModel?
    var products : [MineralModel]?
    var banners : [ImageModel]?
    var added_to_favorites : Int?
   

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        result <- map ["result"]
        shop <- map ["shop"]
        products <- map ["products"]
        banners <- map ["banners"]
        added_to_favorites <- map ["added_to_favorites"]
    }
}
