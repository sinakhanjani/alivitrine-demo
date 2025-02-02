//
//  NetworkErrors.swift
//  Master
//
//  Created by Mohammad Fallah on 11/15/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import Foundation
enum NetworkErrors : Error {
    case NotFound
    case Unathorized
    case InternalError
    case BadURL
    case BadRequest
    case TimeOuted
    case BadParameters
}

