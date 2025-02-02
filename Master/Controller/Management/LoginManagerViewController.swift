//
//  LoginManagerViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 1/23/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class LoginManagerViewController: AppViewController {

//    ===== Outlet =====
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.keyboardType = .asciiCapableNumberPad
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        getToken()
    }
    func getToken () {
        showLoading()
        let network = Network<TokenResponse>.init(url: Constant.Url.login_vendor)
            .addParameter(key: "username", value: usernameTF.text)
            .addParameter(key: "password", value: passwordTF.text)
//        .addParameter(key: "grant_type", value: "password")
//        .addParameter(key: "client_secret", value: "r3IOwaBkJW4hPqKBoa2ifNqvL38idNidnHPaTvgs")
//        .addParameter(key: "client_id", value: "2")
//        .addParameter(key: "scope", value: "")
        .withPost()
        handleRequestByUI(network,success: {[weak self](result) in
            if let token = result.access_token {
                Authentication.auth.authenticationUser(token: token, isLoggedIn: true)
                UserDefaults.standard.set(true, forKey: "loginAsManager")
                let vc = ShopManagementViewController.create()
                guard let navigationController = self?.navigationController else { return }
                var navigationArray = navigationController.viewControllers
                navigationArray[navigationArray.count - 1] = vc
                self?.navigationController?.viewControllers = navigationArray
            }
            else {
                self?.presentIOSAlertWarning(message: "متاسفانه مشکلی پیش آمده است", completion: {})
            }
        })
    }
}
