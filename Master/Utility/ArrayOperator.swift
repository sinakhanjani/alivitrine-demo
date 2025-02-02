//
//  ArrayOperator.swift
//  Master
//
//  Created by Mohammad Fallah on 12/3/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import Foundation
extension Collection {
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
}

