//
//  VendorChangePasswordViewController.swift
//  Master
//
//  Created by Sina khanjani on 2/30/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class VendorChangePasswordViewController: AppViewController {

    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.oldPasswordTF.keyboardType = .asciiCapableNumberPad
        self.newPasswordTF.keyboardType = .asciiCapableNumberPad
    }

    @IBAction func buttonTapped() {
        guard  newPasswordTF.text!.count > 0 && oldPasswordTF.text!.count > 0 else {
            self.presentIOSAlertWarning(message: "لطفا پسورد جدید را وارد کنید") {
//                /
            }
            return
        }
        let network = Network<ResponseModel<EmptyModel>>.init(url: Constant.Url.changePassword)
        .addParameter(key: "new_password", value: newPasswordTF.text!)
        .addParameter(key: "re_password", value: newPasswordTF.text!)
        .withPost()
        handleRequestByUI(network,success: {[weak self](result) in
            if result.result == "success" {
                self?.presentIOSAlertWarning(message: result.message ?? "", completion: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        })
    }

}
