//
//  BrandModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/19/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//
import ObjectMapper

class BrandModel : Mappable {

    var title : String?
    var user_id : String?
    var description : String?
    var address : String?
    var tel1 : Int?
    var tel2 : String?
    var expired_date : String?
    var name : String?
    var telegram : String?
    var instagram : String?
    var website : String?
    var image : String?
    var views_count : Int?
    var share_link: String?
    var telegram_contact: String?
    var whatsapp_contact: String?
    
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        title <- map ["title"]
        user_id <- map ["user_id"]
        description <- map ["description"]
        address <- map ["address"]
        tel1 <- map ["tel1"]
        tel2 <- map ["tel2"]
        expired_date <- map ["expired_date"]
        name <- map ["name"]
        telegram <- map ["telegram"]
        instagram <- map ["instagram"]
        website <- map ["website"]
        image <- map ["image"]
        views_count <- map ["views_count"]
        share_link <- map ["share_link"]
        telegram_contact <- map ["telegram_contact"]
        whatsapp_contact <- map ["whatsapp_contact"]

    }
}
