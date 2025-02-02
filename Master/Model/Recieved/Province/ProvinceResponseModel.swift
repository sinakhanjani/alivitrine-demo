//
//  ProvinceResponseModel.swift
//  Master
//
//  Created by Mohammad Fallah on 1/16/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

struct ProvinceResponseModel : Mappable {
    var states : [State]?
    var cities : [City]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        states <- map["states"]
        cities <- map["cities"]
    }

}

struct City : Mappable {
    var id : Int?
    var code : String?
    var state_code : String?
    var center_flag : String?
    var pname : String?
    var ename : String?
    var status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        code <- map["code"]
        state_code <- map["state_code"]
        center_flag <- map["center_flag"]
        pname <- map["pname"]
        ename <- map["ename"]
        status <- map["status"]
    }

}

struct State : Mappable {
    var id : Int?
    var code : String?
    var pname : String?
    var ename : String?
    var status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        code <- map["code"]
        pname <- map["pname"]
        ename <- map["ename"]
        status <- map["status"]
    }

}
