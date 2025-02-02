//
//  FilterViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func applyFilter (specifications : [Int])
}
class FilterViewController: UIViewController {

//    ==== Outlet =====
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
//    ===== vars =====
    var specifications : [SpecificationModel]?
    var delegate : FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
        config()
    }
    
    func config () {
        specifications?.forEach({ model in
            let label = UILabel()
            label.text = model.title
            label.font = UIFont.appFont(with: 13)
            label.textAlignment = .right
            stack.addArrangedSubview(label)
            let box = UIView()
            box.backgroundColor = UIColor(hex: "#F3F3F3")
            box.translatesAutoresizingMaskIntoConstraints = false
            box.heightAnchor.constraint(equalToConstant: 40).isActive = true
            let tf = DropDownTextField()
            tf.hasNothingChoice = true
            tf.translatesAutoresizingMaskIntoConstraints = false
            box.addSubview(tf)
            tf.borderStyle = .none
            tf.placeholder = "انتخاب کنید"
            tf.font = UIFont.appFont(with: 15)
            tf.textAlignment = .center
            tf.text = model.selectedChild
            tf.anchorDropDown(dataSource: (model.children?.map {$0.title} ?? []) as! [String], keys: (model.children?.map {$0.id ?? 0} ?? []), selectedRow: nil, handler: nil)
            NSLayoutConstraint.activate([
                tf.topAnchor.constraint(equalTo: box.topAnchor, constant: 0),
                tf.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: 0),
                tf.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 0),
                tf.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: 0)
            ])
            box.sizeToFit()
            box.layoutIfNeeded()
            stack.addArrangedSubview(box)
            stack.sizeToFit()
            stack.layoutIfNeeded()
            scrollViewHeight.constant += 63.67
                        
        })
    }
    
    @IBAction func tapOutside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func applyBtnPressed(_ sender: Any) {
        var keys = [Int]()
        var i = 0
        for view in stack.subviews where view.subviews.count > 0 {
            if let dropDown = view.subviews.first as? DropDownTextField {
                if let key = dropDown.getKeyOfSelected(), let keyInt = key as? Int {
                    keys.append(keyInt)
                }
                specifications![i].selectedChild = dropDown.text
                i += 1
            }
        }
        delegate?.applyFilter(specifications: keys)
        self.dismiss(animated: true, completion: nil)
    }
    
}
