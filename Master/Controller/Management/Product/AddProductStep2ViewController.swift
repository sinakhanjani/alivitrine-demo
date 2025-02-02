//
//  AddProductStep2ViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 1/24/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class AddProductStep2ViewController: AppViewController {

//    ==== IBOutlet ====
    @IBOutlet weak var size1TF: InsetTextField!
    @IBOutlet weak var size2TF: InsetTextField!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var sizesBox: UIView! //have two child (from-to)
    @IBOutlet weak var sizesCollection: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
//    ==== Vars ====
    var specifications : [SpecificationModel]?
    var productId : Int?
    var boxCount : String?
    var collectionSize : [ShoeSizeModel] = [ShoeSizeModel()]
    var isShoeCategory = true
    var product : ProductResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        size1TF.keyboardType = .asciiCapableNumberPad
        size2TF.keyboardType = .asciiCapableNumberPad
        if product != nil {
            specifications?.forEach({ (model) in
                model.selectedChildAsModel = model.children?.first(where: {$0.selected == 1})
            })
            if let sizes = product?.product?.size?.replacingOccurrences(of: "تا", with: "_").replacingOccurrences(of: " ", with: "").split(separator: "_"), let size1 = sizes.first,let size2 = sizes[optional: 1] {
                size1TF.text = String(size1)
                size2TF.text = String(size2)
            }
            if product?.product_sizes != nil && product?.product_sizes?.count ?? 0 > 0 {
                collectionSize = (product?.product_sizes)!
                collectionView.reloadData()
            }
        }
        config ()
        if !isShoeCategory {
            sizesBox.isHidden = true
            sizesCollection.isHidden = true
        }
        
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
            tf.text = model.selectedChildAsModel?.title
            tf.default = model.selectedChildAsModel?.id
            tf.anchorDropDown(dataSource: (model.children?.map { $0.title } ?? []) as! [String], keys: (model.children?.map {$0.id ?? 0} ?? []), selectedRow: nil, handler: nil)
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
                        
        })
    }
    @IBAction func okBtnPressed(_ sender: Any) {
        finalRequestToAddProduct()
    }
    func finalRequestToAddProduct () {
        var keys = [String]()
        var sizeShoe = [String]()
        var numberShoe = [String]()
        var i = 0
        for view in stack.subviews where view.subviews.count > 0 {
            if let dropDown = view.subviews.first as? DropDownTextField {
                if let key = dropDown.getKeyOfSelectedOrDefault(), let keyInt = key as? Int {
                    keys.append(String(describing: keyInt))
                }
                specifications![i].selectedChild = dropDown.text
                i += 1
            }
        }
        for cell in collectionView.visibleCells {
            if let sizeCell = cell as? SizeShoeCollectionViewCell {
                if Int(sizeCell.sizeTF.text ?? "0") ?? 0 > 0 && Int(sizeCell.countTF.text ?? "0") ?? 0 > 0 {
                sizeShoe.append(sizeCell.sizeTF.text?.toEngNumbers() ?? "0")
                numberShoe.append(sizeCell.countTF.text?.toEngNumbers() ?? "0")
                }
            }
        }
        Network<ResponseModel<EmptyModel>>
        .init(url: product != nil ? Constant.Url.updateProductStep2 : Constant.Url.addProductStep2)
        .addParameter(key: "productId", value: String(describing: productId ?? 0))
        .addParameter(key: "size1", value: size1TF.text?.toEngNumbers())
        .addParameter(key: "size2", value: size2TF.text?.toEngNumbers())
        .addParameter(key: "fildId", value: keys)
        .addParameter(key: "age_size_id", value: "1")
//        .addParameter(key: "size", value: sizeShoe)
        .addParameter(key: "box_count", value: boxCount)
//        .addParameter(key: "number", value: numberShoe)
        .post {[weak self] (result) in
            result.ifSuccess { (response) in
                if response.result == "success" {
                    self?.presentIOSAlertWarning(message: response.message ?? "این محصول بعد از بررسی تیم فنی انتشار مییابد", completion: {
                        NotificationCenter.default.post(name: Constant.Notify.refreshManagment, object: nil)
                        self?.navigationController?.popToRootViewController(animated: true)
                    })
                }
                else {
                    self?.presentIOSAlertWarning(message: response.message ?? "متاسفانه مشکلی پیش آمده است", completion: {})
                }
            }
            result.ifFailed { (err) in
                self?.presentIOSAlertWarning(message: "متاسفانه مشکلی پیش آمده است", completion: {})
            }
        }
    }
}
extension AddProductStep2ViewController : UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + collectionSize.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == collectionSize.count {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sizeCell", for: indexPath) as! SizeShoeCollectionViewCell
        let item = collectionSize[indexPath.item]
        cell.sizeTF.text = item.size
        cell.countTF.text = item.count
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == collectionSize.count {
            collectionSize.append(ShoeSizeModel())
            collectionView.insertItems(at: [IndexPath(item: collectionSize.count-1, section: 0)])
        }
    }
}
