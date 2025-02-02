//
//  SpecificationModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/19/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//
import ObjectMapper

class SpecificationModel : Mappable {

    var id : Int?
    var title : String?
    var children : [SpecificationChildModel]?
    var selectedChild : String? //this property is my own
    var selectedChildAsModel : SpecificationChildModel? //property is my own

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map ["id"]
        title <- map ["title"]
        children <- map ["children"]
    }
}

class SpecificationChildModel : Mappable {

    var id : Int?
    var title : String?
    var name : String?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    var _lft : String?
    var _rgt : String?
    var parent_id : String?
    var selected : Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map ["id"]
        title <- map ["title"]
        name <- map ["name"]
        created_at <- map ["created_at"]
        updated_at <- map ["updated_at"]
        deleted_at <- map ["deleted_at"]
        _lft <- map ["_lft"]
        _rgt <- map ["_rgt"]
        parent_id <- map ["parent_id"]
        selected <- map ["selected"]
    }
}
