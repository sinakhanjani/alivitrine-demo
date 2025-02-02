//
//  UIFont.swift
//  Alaedin
//
//  Created by Sinakhanjani on 10/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

extension UIFont {
    enum AppFontStyle : String {
        case regular = "IRANSansMobile(FaNum)"
        case bold = "IRANSansMobileFaNum-Bold"
        case light = "IRANSansMobileFaNum-Light"
    }
    
//    enum AppFontStyle : String {
//        case regular = "IRANYekanMobile(FaNum)"
//        case bold = "IRANYekanMobileFaNum-Bold"
//        case light = "IRANYekanMobileFaNum-Light"
//        case medium = "IRANYekanMobileFaNum-Medium"
//    }
    
    static func appFont (_ style : AppFontStyle = .regular , with size:CGFloat?) -> UIFont? {
        return UIFont(name: style.rawValue , size: size ?? 15)
    }
}
