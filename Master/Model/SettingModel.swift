//
//  SettingModel.swift
//  Master
//
//  Created by Sina khanjani on 2/30/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//



import ObjectMapper

struct SettingModel : Mappable {

    var telegram : String?
    var whatsapp : String?
    var invite_message : String?
    var updateChecker: UpdateChecker?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        telegram <- map ["telegram"]
        whatsapp <- map ["whatsapp"]
        invite_message <- map ["invite_message"]
        updateChecker <- map ["update-checker"]
    }
}

struct UpdateChecker : Mappable  {
    var ios: IOS?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        ios <- map ["ios"]

    }
}

struct IOS: Mappable {
    var version: String?
    var isForce: Bool?
    var link: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        version <- map ["version"]
        isForce <- map ["isForce"]
        link <- map ["link"]
    }
}
