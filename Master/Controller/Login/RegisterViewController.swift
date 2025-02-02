//
//  RegisterViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 1/16/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit
typealias MyType = (number : Int,name: String)


class RegisterViewController: AppViewController {

    @IBOutlet weak var familyTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var stateDropDown: DropDownTextField!
    @IBOutlet weak var cityDropDown: DropDownTextField!
    
    var cities : [City]?
    var provinces : [State]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTF.keyboardType = .asciiCapableNumberPad
        getState()
        stateDropDown.setListener {[weak self] (index, text) in
            let citiesList = self?.cities?.filter{$0.state_code == String(describing: ((self?.stateDropDown.getKeyOfSelected() as? Int) ?? 0) - 1)} ?? []
            self?.cityDropDown.text = ""
            self?.cityDropDown.anchorDropDown(dataSource: citiesList.map {($0.pname ?? "")}, keys: citiesList.map{$0.id ?? 0}, selectedRow: nil, handler: nil)
        }
    }
    @IBAction func loginBtnPressed(_ sender: Any) {
        if stateDropDown.text?.isEmpty == false &&
            cityDropDown.text?.isEmpty == false &&
            familyTF.text?.isEmpty == false &&
            nameTF.text?.isEmpty == false &&
            phoneNumberTF.text?.isEmpty == false &&
            (phoneNumberTF.text?.count ?? 0) == 11 {
                register ()
        }
        else {
            presentIOSAlertWarning(message: "لطفا تمامی فیلد ها رو کامل کنید", completion: {})
        }
    }
    
    func getState () {
        Network<ProvinceResponseModel>.init(url: Constant.Url.states)
        .post { [weak self] (result) in
            result.ifSuccess { (model) in
                self?.cities = model.cities
                self?.provinces = model.states
                if let states = model.states {
                    self?.stateDropDown.anchorDropDown(dataSource: states.map{$0.pname ?? ""}, keys: states.map{$0.id ?? 0}, selectedRow: nil, handler: nil)
                }
            }
        }
    }
    
    func register () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fcmToken = appDelegate.fcmToken
        let network = Network<RegisterResponseModel>.init(url: Constant.Url.register)
        .addParameter(key: "firstName", value: nameTF.text ?? "")
        .addParameter(key: "lastName", value: familyTF.text ?? "")
        .addParameter(key: "mobile", value: phoneNumberTF.text?.toEngNumbers() ?? "")
        .addParameter(key: "state_id", value: stateDropDown.getKeyOfSelected() as? Int)
        .addParameter(key: "city_id", value: cityDropDown.getKeyOfSelected() as? Int)
        .addParameter(key: "firebase_token", value: fcmToken)
        .withPost()
        
        handleRequestByUI(network, success: { [weak self](response : RegisterResponseModel) in
            if let message = response.message {
                if message == "user created" {
                    let vc = VerifyCodeViewController.create()
                    vc.phoneNumber = self?.phoneNumberTF.text?.toEngNumbers()
                    self?.present(vc, animated: false, completion: nil)
                } else {
                    self?.presentIOSAlertWarning(message: "شما قبلا ثبت نام کرده‌اید، لطفا از بخش ورود وارد شوید", completion: {

                    })
                }
            }
        })
        
    }
    
}
