//
//  ShoeModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/19/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import ObjectMapper

struct ShoeModel : Mappable {

    var id : Int?
    var title : String?
    var image : String?
    var price : String?
    var size : String?
    var count_in_box : String?
    var description : String?
    var share_link: String?
    var views_count: Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map ["id"]
        title <- map ["title"]
        image <- map ["image"]
        price <- map ["price"]
        size <- map ["size"]
        count_in_box <- map ["count_in_box"]
        description <- map ["description"]
        share_link <- map ["share_link"]
        views_count <- map ["views_count"]
    }
}
