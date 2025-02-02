//
//  LoginViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 1/20/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class LoginViewController: AppViewController {

    @IBOutlet weak var phoneNumberTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTF.keyboardType = .asciiCapableNumberPad
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        getToken ()
    }
    
    func getToken () {
        showLoading()
        let network = Network<ListResponseModel<EmptyModel>>.init(url: Constant.Url.loginCode)
        .addParameter(key: "mobile", value: phoneNumberTF.text?.toEngNumbers())
        .withPost()
        handleRequestByUI(network,success: {[weak self](result) in
            // go to veriftLoginVC
            if result.result == "success" {
                let vc = VerifyLoginViewController.create()
                vc.mobile = self?.phoneNumberTF.text ?? ""
                self?.present(vc, animated: true, completion: nil)
            } else {
                let msg = result.message ?? ""
                self?.presentIOSAlertWarning(message: "شما قبلا ثبت نام نکرده اید، لطفا از بخش ثبت نام وارد شوید.", completion: {
                    //
                })
            }

        })
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
