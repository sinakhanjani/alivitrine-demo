//
//  TokenResponse.swift
//  Master
//
//  Created by Mohammad Fallah on 1/18/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//
//  Created By GsonToMapper (MohammadFallah)

import ObjectMapper

struct TokenResponse : Mappable {

    var token_type : String?
    var expires_in : Int?
    var access_token : String?
    var refresh_token : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        token_type <- map ["token_type"]
        expires_in <- map ["expires_in"]
        access_token <- map ["access_token"]
        refresh_token <- map ["refresh_token"]
    }
}
