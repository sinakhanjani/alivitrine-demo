//
//  TwoActionViewController.swift
//  Master
//
//  Created by Sinakhanjani on 4/22/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class TwoActionViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    private var subtitle: String?
    private var detail: String?
    private var completionHandlerButtonOne: (() -> Void)?
    private var completionHandlerButtonTwo: (() -> Void)?

    override func viewWillAppear(_ animated: Bool) {
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTouchXibByPresentViewController(bgView: view)
        if let subtitle = subtitle, let detail = detail {
            self.subtitleLabel.text = subtitle
            self.detailLabel.text = detail
        }
    }
    
    @IBAction func buttonOneTapped(_ sender: RoundedButton) {
        dismiss(animated: false) { () -> Void in
            self.completionHandlerButtonOne?()
        }
    }
    
    @IBAction func buttonTwoTapped(_ sender: RoundedButton) {
        dismiss(animated: false) { () -> Void in
            self.completionHandlerButtonTwo?()
        }
    }
    
    static func create(viewController: UIViewController, title: String?, subtitle: String?, completionHandlerButtonOne: (() -> Void)?, completionHandlerButtonTwo: (() -> Void)?) {
        let vc = TwoActionViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.subtitle = title
        vc.detail = subtitle
        vc.completionHandlerButtonOne = completionHandlerButtonOne
        vc.completionHandlerButtonTwo = completionHandlerButtonTwo
        viewController.view.endEditing(true)
        viewController.present(vc, animated: true, completion: nil)
    }
    

}
