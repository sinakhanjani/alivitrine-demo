//
//  ProductManageViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
//import ALCameraViewController

class ProductManageViewController: AppViewController {

//    ===== Outlet =====
    @IBOutlet weak var attributeTableView: ScrollTableView!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageSlider: ImageSlider!
    @IBOutlet weak var detailLabel: UILabel!
    
//    ==== Var ====
    var id : Int?
    var attributes : [[String:String?]] = []
    var productResponse : ProductResponseModel?
//    
//    var minimumSize: CGSize = CGSize(width: 200, height: 165)
//
//    var croppingParameters: CroppingParameters {
//        return CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: minimumSize)
//    }
//    
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
        title = ""
    }
    
    override func fetchData(requestForReloading reloading: Bool) {
        super.fetchData(requestForReloading: reloading)
        let network = Network<ProductResponseModel>.init(url: Constant.Url.productDetail)
        .addParameter(key: "product_id", value: id)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            self?.productResponse = response
            self?.bind()
        })
    }
    func remove () {
        Network<ResponseModel<EmptyModel>>
        .init(url: Constant.Url.deleteProduct)
        .addParameter(key: "productId", value: id)
        .post {[weak self] (result) in
            result.ifSuccess { (response) in
                if response.result == "success" {
                    self?.presentIOSAlertWarning(message: "حذف این محصول با موفقیت انجام شد", completion: {
                        NotificationCenter.default.post(name: Constant.Notify.refreshManagment, object: nil)
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
                else {
                    self?.presentIOSAlertWarning(message: response.message ?? "متاسفانه خطایی رخ داده است", completion: {})
                }
            }
        }
    }
    func bind () {
        guard let product = productResponse else {return;}
        attributes.append(["نام محصول" : product.product?.title])
        attributes.append(["سایز بندی از" : product.product?.size])
        attributes.append(["تعداد در کارتن" : product.product?.count_in_box])
        attributes.append(contentsOf: product.specifications?.map {[$0.title ?? "" : $0.children?.first?.title ?? ""]} ?? [])
        attributeTableView.reloadData()
        self.viewCountLabel.text = "\(product.product?.views_count ?? 0)"
        priceLabel.text = product.product?.price?.seperateByCama
        imageSlider.images = product.product_images?.map{$0.image}
        title = product.category?.title
        self.detailLabel.text = product.product?.description ?? ""
    }
    @IBAction func removeBtnDidTap(_ sender: Any) {
        presentIOSAlertWarningWithTwoButton(message: "آیا از حذف این محصول اطمینان دارید؟", buttonOneTitle: "بله", buttonTwoTitle: "خیر", handlerButtonOne: {[weak self] in
            self?.remove()
        }) {
        }
    }
    @IBAction func editBtnPressed(_ sender: Any) {
        let vc = AddProductStep1ViewController.create()
        vc.product = productResponse
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension ProductManageViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttributeTableViewCell.className, for: indexPath) as! AttributeTableViewCell
        let atr = attributes[indexPath.item]
        cell.attrKeyLabel.text = atr.keys.first
        cell.attrValueLabel.text = String(describing: (atr.values.first as? String ?? ""))
        return cell
    }
}

extension ProductManageViewController {
//   func openCamera() {
//        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true) { [weak self] image, asset in
////            self?.imageView.image = image
//            self?.dismiss(animated: true, completion: nil)
//        }
//        
//        present(cameraViewController, animated: true, completion: nil)
//    }
//    
//    func openGallery() {
//        let libraryViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] image, asset in
//            if let image = image {
//
//
//            }
//            self?.dismiss(animated: true, completion: nil)
//        }
//        
//        present(libraryViewController, animated: true, completion: nil)
//    }
}
