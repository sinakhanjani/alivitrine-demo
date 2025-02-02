//
//  VerifyCodeViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 1/18/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit
import ObjectMapper

class VerifyCodeViewController: AppViewController {

//    ===== Outlet =====
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    //    ==================
    
//    ===== Variable =====
    var phoneNumber : String?
    var forwardToMain = false
    var timer : Timer?
    var count = 120
//    ====================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchResendButton(enable: false)
        codeTF.keyboardType = .asciiCapableNumberPad
    }
   
    @IBAction func resendBtnPressed(_ sender: Any) {
    }
    @objc func updateTimer() {
        count -= 1
        if(count > 0) {
            countDownLabel.text = "(\(count))"
        }
        else  {
            countDownLabel.text = ""
            switchResendButton(enable: true)
        }
    }
    func switchResendButton (enable : Bool) {
        if !enable {
            count = 120
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            timer?.fire()
        }
        else {
            countDownLabel.text = ""
            timer?.invalidate()
        }
        resendBtn.setTitleColor(enable ? UIColor(named: "SecondaryColor") : UIColor(hex: "#B2B2B2"), for: .normal)
        resendBtn.isEnabled = enable
    }
    @IBAction func confirmBtnPressed(_ sender: Any) {
        verify()
    }
    
    func verify () {
        showLoading()
        let network = Network<VerifyRegisterModel>.init(url: Constant.Url.registerConfirm)
        .addParameter(key: "mobile", value: phoneNumber)
        .addParameter(key: "confirmCode", value: codeTF.text)
        .withPost()
        handleRequestByUI(network,success: { [weak self] (result : VerifyRegisterModel) in
            if result.access_token != nil {
                Authentication.auth.authenticationUser(token: result.access_token ?? "", isLoggedIn: true)
                let vc = YourJobViewController.create()
                vc.userId = result.user_id
                self?.present(vc, animated: true, completion: nil)
            }
            else {
                self?.presentIOSAlertWarning(message: "متاسفانه مشکلی پیش آمده است", completion: {})
            }
        })
    }
    
//    func getToken () {
//        showLoading()
//        let network = Network<TokenResponse>.init(url: Constant.Url.login)
//        .addParameter(key: "username", value: phoneNumber)
//        .addParameter(key: "password", value: phoneNumber)
//        .addParameter(key: "grant_type", value: "password")
//        .addParameter(key: "client_secret", value: "r3IOwaBkJW4hPqKBoa2ifNqvL38idNidnHPaTvgs")
//        .addParameter(key: "client_id", value: "2")
//        .addParameter(key: "scope", value: "")
//        .withPost()
//        handleRequestByUI(network,success: {[weak self](result) in
//            if let token = result.access_token {
//                Authentication.auth.authenticationUser(token: token, isLoggedIn: true)
//                if self?.forwardToMain == true {
//                    self?.performSegue(withIdentifier: "backToLoader", sender: nil)
//                }
//                else {
//                    self?.present(YourJobViewController.create(), animated: true, completion: nil)
//                }
//            }
//            else {
//                self?.presentIOSAlertWarning(message: "متاسفانه مشکلی پیش آمده است", completion: {})
//            }
//        })
//    }
    
    func sendAgainSMSCode () {
        showLoading()
        let network = Network<ResponseModel<EmptyModel>>.init(url: Constant.Url.sendCode)
        .addParameter(key: "mobile", value: phoneNumber)
        .withPost()
        handleRequestByUI(network,success: {[weak self](result) in
            if  result.result == "success" {
                self?.switchResendButton(enable: false)
            }
        })
    }
}



struct VerifyRegisterModel : Mappable {
    
    init?(map: Map) {
       //
    }
    
    mutating func mapping(map: Map) {
//        user <- map["user"]
        access_token <- map["access_token"]
        user_id <- map["message"]
    }

//    var user : UserModel?
    var access_token : String?
    var user_id : Int?
}
