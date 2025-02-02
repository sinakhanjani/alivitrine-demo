//
//  CategoryRegisterModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/18/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//
import ObjectMapper

// MARK: - Empty
struct SendCategory: Mappable {
    var mainCategoryID, subCategoryID: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        subCategoryID <- map ["sub_category_id"]
        mainCategoryID <- map ["main_category_id"]
    }
}


struct CategoriesModel : Mappable {

    var id : Int?
    var title : String?
    var childs : [CategoryChildModel]?
    var icon_image : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map ["id"]
        title <- map ["title"]
        childs <- map ["childs"]
        icon_image <- map ["icon_image"]
        if childs == nil {
            childs <- map["children"]
        }
    }
}

struct CategoryChildModel : Mappable {

    var id : Int?
    var title : String?
    var active : Bool?
    var parent_id : String?
    var in_menu : Bool?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    var icon_name : String?
    var icon_image : String?
    var title_seo : String?
    var description_seo : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map ["id"]
        title <- map ["title"]
        active <- map ["active"]
        parent_id <- map ["parent_id"]
        in_menu <- map ["in_menu"]
        created_at <- map ["created_at"]
        updated_at <- map ["updated_at"]
        deleted_at <- map ["deleted_at"]
        icon_name <- map ["icon_name"]
        icon_image <- map ["icon_image"]
        title_seo <- map ["title_seo"]
        description_seo <- map ["description_seo"]
    }
}
