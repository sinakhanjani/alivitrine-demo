//
//  CheckBoxView.swift
//  Master
//
//  Created by Mohammad Fallah on 12/3/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

@IBDesignable
class CheckBoxView: UIView {

//    === outlets ===
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet var contentView: UIView!
    
//    === vars ===
    @IBInspectable public var checked : Bool = false {
        didSet {
            uiUpdate()
        }
    }
    @IBInspectable public var text : String = "متن مورد نظر شما جهت تایید کاربر" {
        didSet {
            uiUpdate()
        }
    }
    
    @IBInspectable public var textColor : UIColor = .gray {
        didSet {
            uiUpdate()
        }
    }
    
    
    @IBInspectable public var checkedImage : UIImage? = nil {
        didSet {
            if checkedImage != nil {
                uiUpdate()
            }
        }
    }
    @IBInspectable public var unCheckedImage : UIImage? = nil {
        didSet {
            if unCheckedImage != nil {
                uiUpdate()
            }
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    @objc func tapped () {
        toggle()
    }
    private func commonInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (tapped)))
        let bundle = Bundle.init(for: CheckBoxView.self)
        bundle.loadNibNamed("CheckBoxView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    func toggle () {
        checked = !checked
        uiUpdate()
    }
    private func uiUpdate () {
        let dynamicBundle = Bundle(for: CheckBoxView.self)
        label.text = text
        label.textColor = textColor
        if checked {
            checkButton.setImage(checkedImage ?? UIImage(named: "check",in: dynamicBundle, compatibleWith: nil), for: .normal)
        }
        else {
            checkButton.setImage(unCheckedImage ?? UIImage(named: "uncheck",in: dynamicBundle, compatibleWith: nil), for: .normal)
        }
    }
    
}
