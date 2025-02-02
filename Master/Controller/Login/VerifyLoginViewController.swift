//
//  VerifyLoginViewController.swift
//  Master
//
//  Created by Sina khanjani on 2/30/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class VerifyLoginViewController: AppViewController {

    @IBOutlet weak var codeTextField: UITextField!
    
    var mobile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.keyboardType = .asciiCapableNumberPad
    }

    @IBAction func agreeButtonTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fcmToken = appDelegate.fcmToken
        showLoading()
        let network = Network<TokenResponse>.init(url: Constant.Url.verifyCode)
        .addParameter(key: "mobile", value: mobile)
        .addParameter(key: "confirmCode", value: codeTextField.text!)
        .addParameter(key: "firebase_token", value: fcmToken)
        .withPost()
        handleRequestByUI(network,success: {[weak self](result) in
            if let token = result.access_token {
                Authentication.auth.authenticationUser(token: token, isLoggedIn: true)
                self?.performSegue(withIdentifier: "gotToLoader_", sender: nil)
            }
            else {
                self?.presentIOSAlertWarning(message: "متاسفانه مشکلی پیش آمده است", completion: {})
            }
        })
    }
}
