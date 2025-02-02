//
//  NotificationModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/25/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import ObjectMapper

struct NotificationModel : Mappable {

    var id : Int?
    var title : String?
    var body : String?
    var image : String?
    var created_at : AtedAt?
    var updated_at : AtedAt?
    var openUrl:String?
    var product_id:String?
    var shop_id:String?


    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map ["id"]
        title <- map ["title"]
        body <- map ["body"]
        image <- map ["image"]
        created_at <- map ["created_at"]
        updated_at <- map ["updated_at"]
        openUrl <- map ["openUrl"]
        shop_id <- map ["shop_id"]
        product_id <- map ["product_id"]
    }
}


// MARK: - AtedAt
struct AtedAt: Mappable {
    var date: String?
    var timezoneType: Int?
    var timezone: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        timezone <- map ["timezone"]
        date <- map ["date"]
        timezoneType <- map ["timezoneType"]
    }
}
