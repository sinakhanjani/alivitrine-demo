//
//  Constant.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class Constant {
    
    struct Notify {
        static let dismissIndicatorViewControllerNotify = Notification.Name("dismissIndicatorViewController")
        static let LanguageChangedNotify = Notification.Name("englishLanguageChangedNotify")
        static let dropNotify = Notification.Name("dropNotify")
        static let bankNotify = Notification.Name("bankNotify")
        static let tryForData = Notification.Name("tryForData")
        static let refreshManagment = Notification.Name("tryForData")
    }
    
    struct Url {
        static let baseURL = "https://www.alivitrine.ir/api/"
//        ==== Register ====
        static let register = baseURL + "register/buyer"
        static let registerConfirm = baseURL + "register/buyer/confirm"
        static let registerCategories = baseURL + "register/categories"
        static let sendCode = baseURL + "register/buyer/send-code"
        static let changeState = baseURL + "register/change-state"
        static let states = baseURL + "register/city-and-state"
        
//        ==== Categories ====
        static let categoryList = baseURL + "product/categories"
        static let productOfCategoryList = baseURL + "product/category-list"
        static let productSearchFilter = baseURL + "product/search-filter"
        
//        ===== Product ======
        static let productDetail = baseURL + "product/detail"
        static let shopList = baseURL + "product/shops"
        static let shopDetail = baseURL + "product/shop-details"
        static let myShopDetail = baseURL + "panel/products-and-shop"
        static let productSearch = baseURL + "product/search"
        static let shoeCategory = baseURL + "product/shoe-categories"
        static let productAddToFavorite = baseURL + "product/add-to-favorites"
        
//        ====== Profile =====
        static let login = "https://www.alivitrine.ir/oauth/token"
        static let editProfile = baseURL + "panel/edit-profile"
        static let editShop = baseURL + "panel/edit-shop"
        static let updateProductStep1 = baseURL + "panel/update-product-step-one"
        static let updateProductStep2 = baseURL + "panel/update-product-step-two"
        static let addToSavedProduct = baseURL + "product/add-to-saveds"
        static let addToSavedShop = baseURL + "shop/add-to-saveds"
        static let shopAddToFavorite = baseURL + "shop/add-to-favorites"
        static let myProductList = baseURL + "panel/product-list"
        static let addProductStep1 = baseURL + "panel/create-product-step-one"
        static let addProductStep2 = baseURL + "panel/create-product-step-two"
        static let deleteProduct = baseURL + "panel/delete-product"
        static let contactList = baseURL + "contact-list"
        static let favouriteList = baseURL + "favorites-list"
        static let getUser = baseURL + "get-user"
        static let login_vendor = baseURL + "login/shop"
        
//        ====== Home =======
        static let home = baseURL + "first-page"
        
//        ===== Other =====
        static let specialProduct = baseURL + "special-products"
        static let specialBrands = baseURL + "special-brands"
        static let bestBrands = baseURL + "best-brands"
        static let newProduct = baseURL + "new-products"
        static let setCategoryRegister = baseURL + "register/buyer/add-categories"
        static let setting = baseURL + "setting"
        static let changePassword = baseURL + "change-password"
        static let read = baseURL + "read-notification"

        // ====== Send Code =====
        static let loginCode = baseURL + "login/customer"
        static let verifyCode = baseURL + "login/customer/confirm"

    }
    
    struct Fonts {
        static let fontOne = "IRANSans"
        static let fontTwo = "IRANSansMobileFaNum-Bold"
        static let fontThree = "WeblogmaYekan"
        static let casablancaRegular = "Mj_Casablanca"
    }
    
    struct Google {
        static let api = "GOOGLE MAP API KEY"
    }
    
    struct Color {
        static let green = #colorLiteral(red: 0, green: 0.7251975536, blue: 0.6760455966, alpha: 1)
        static let dark = #colorLiteral(red: 0.4823101163, green: 0.4823812246, blue: 0.4822877049, alpha: 1)
    }
    
    enum Alert {
        case none, failed, success, json
    }
    
    enum Language {
        case fa, en
    }

}
