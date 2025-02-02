//
//  UpdateViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/23/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {
    
    @IBOutlet weak var dontButton: UIButton!
    @IBOutlet weak var forceButton: UIButton!

    var ios: IOS?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
        if let ios = ios {
            if let force = ios.isForce {
                if force {
                    dontButton.isEnabled = false
                    
                } else {
                    dontButton.isEnabled = true
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func dontUpdateButtonTapped (_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateButtonTapped (_ sender: UIButton) {
        if let str = ios?.link {
            if let url = URL(string: str) {
                WebAPI.openURL(url: url)
            }
        }
    }
}
