//
//  LoginResponseModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/17/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//
//  Created By GsonToMapper (MohammadFallah)

import ObjectMapper

struct RegisterResponseModel : Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
//        user <- map["user"]
        result <- map["resualt"]
        message <- map["message"]
    }

//    var user : UserModel?
    var result : String?
    var message : String?
}

struct UserModel : Mappable {

    var first_name : String?
    var last_name : String?
    var mobile : String?
    var code : Float?
    var state_id : String?
    var city_id : String?
    var firebase_token : String?
    var updated_at : String?
    var created_at : String?
    var id : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        first_name <- map ["first_name"]
        last_name <- map ["last_name"]
        mobile <- map ["mobile"]
        code <- map ["code"]
        state_id <- map ["state_id"]
        city_id <- map ["city_id"]
        firebase_token <- map ["firebase_token"]
        updated_at <- map ["updated_at"]
        created_at <- map ["created_at"]
        id <- map ["id"]
    }
}

struct EditProfileResponseModel : Mappable {

    var result : String?
    var message : String?
    var user : ProfileModel?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        result <- map ["result"]
        message <- map ["message"]
        user <- map ["user"]
    }
}
class ProfileModel : Mappable {
    
    var id : Int?
    var first_name : String?
    var last_name : String?
    var mobile : String?
    var profile_photo : String?
    var notification_count : Int?
    var notifications : [NotificationModel]?
    var city : City?
    var state : State?
    var sub_categories : [CategoryChildModel]?
    var main_category : [CategoryChildModel]?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map ["id"]
        first_name <- map ["first_name"]
        last_name <- map ["last_name"]
        mobile <- map ["mobile"]
        profile_photo <- map ["profile_photo"]
        notification_count <- map ["notification_count"]
        notifications <- map ["notifications"]
        city <- map ["city"]
        state <- map ["state"]
        sub_categories <- map ["sub_categories"]
        main_category <- map ["main_category"]
    }
    
    func copyData (from model : ProfileModel) {
        first_name = model.first_name
        last_name = model.last_name
        profile_photo = model.profile_photo
        city = model.city
        state = model.state
        sub_categories = model.sub_categories
        main_category = model.main_category
    }
}
