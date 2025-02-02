//
//  AdviceRequestViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class AdviceRequestViewController: AppViewController {

    var whatsappLink = ""
    var telegramLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
        // Do any additional setup after loading the view.
    }
    
    override func fetchData(requestForReloading reloading: Bool) {
        super.fetchData(requestForReloading: reloading)
        let network = Network<SettingModel>.init(url: Constant.Url.setting)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            self?.whatsappLink = response.whatsapp ?? ""
            self?.telegramLink = response.telegram ?? ""
        })
    }
    
    @IBAction func outsideDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func whatsappButtonTapped (_ sender: UIButton) {
        if let url = URL(string: whatsappLink) {
            WebAPI.openURL(url: url)
        }
    }
    
    @IBAction func telegramsButtonTapped (_ sender: UIButton) {
        if let url = URL(string: telegramLink) {
            WebAPI.openURL(url: url)
        }
    }
}
