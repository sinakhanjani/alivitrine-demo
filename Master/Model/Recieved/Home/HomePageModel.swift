//
//  HomePageModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/19/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

struct HomePageModel : Mappable {

    var sliders : [ImageModel]?
    var banners : [ImageModel]?
    var special_brands : [MineralModel]?
    var best_brands : [MineralModel]?
    var new_products : [MineralModel]?
    var special_products : [MineralModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        sliders <- map ["sliders"]
        banners <- map ["banners"]
        special_brands <- map ["special_brands"]
        best_brands <- map ["best_brands"]
        new_products <- map ["new_products"]
        special_products <- map ["special_products"]
    }
}

struct ImageModel : Mappable {

    var image : String?
    var url : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        image <- map ["image"]
        url <- map ["url"]

    }
}

///Mineral Means Minimum Generic that means a model contain all thing and is minimal
struct MineralModel : Mappable {

    var id : Int?
    var title : String?
    var image : String?
    var price : String?
    var added_to_favorites : Float?
    var size : String?
    var views_count: Int?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map ["id"]
        title <- map ["title"]
        image <- map ["image"]
        price <- map ["price"]
        size <- map ["size"]
        views_count <- map ["views_count"]
        added_to_favorites <- map ["added_to_favorites"]
    }
}
