//
//  ProductViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class ProductViewController: AppViewController {

//    ===== Outlet =====
    @IBOutlet weak var attributeTableView: ScrollTableView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var logoImage: CircleImageView!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageSlider: ImageSlider!
    @IBOutlet weak var favBtn: UIBarButtonItem!
    @IBOutlet weak var detailLabel: UILabel!

//    ==== Var ====
    var id : Int?
    var attributes : [[String:String?]] = [[:]]
    var productResponse : ProductResponseModel?
    
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

    func bind () {
        guard let product = productResponse else {return;}
        shopNameLabel.text = product.shop?.title
        if let imageStr = product.shop?.image, let url = URL(string: imageStr) {
            logoImage.af_setImage(withURL: url,placeholderImage: #imageLiteral(resourceName: "placeholder.pdf"))
        }
        else {
            logoImage.image = #imageLiteral(resourceName: "placeholder.pdf")
        }
        attributes.append(["نام محصول" : product.product?.title])
        attributes.append(["سایز بندی از" : product.product?.size])
        attributes.append(["تعداد در کارتن" : product.product?.count_in_box])
        attributes.append(contentsOf: product.specifications?.map {[$0.title ?? "" : $0.children?.first?.title ?? ""]} ?? [])
        attributeTableView.reloadData()
        self.viewCountLabel.text = "\((productResponse?.product?.views_count ?? 0))"
        if (product.product?.price ?? "") != "" {
            priceLabel.text = (product.product?.price ?? "") + " " + "تومان"
        }
        imageSlider.images = product.product_images?.map {$0.image}
        title = product.category?.title
        detailLabel.text = product.product?.description ?? ""
        switchFavBtn(bookmarked: productResponse?.added_to_favorites ?? 0)
    }
    
    @IBAction func favBtnPressed(_ sender: Any) {
        favoriteProduct()
    }
    
    @IBAction func brandButtonTapped(_ sender: Any) {
        let vc = BrandViewController.create()
        vc.id = productResponse?.shop?.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func favoriteProduct () {
        showLoading()
        let network = Network<ResponseModel<EmptyModel>>.init(url: Constant.Url.productAddToFavorite)
        .addParameter(key: "product_id", value: id)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            if response.result == "success" {
                let fav = self?.productResponse?.added_to_favorites ?? 0
                self?.productResponse?.added_to_favorites = fav == 0 ? 1 : 0
                self?.switchFavBtn(bookmarked: self?.productResponse?.added_to_favorites ?? 0)
            }
        })
    }
    func switchFavBtn(bookmarked : Int) {
        if bookmarked == 0 {
            favBtn.image = #imageLiteral(resourceName: "ic_bookmark.pdf")
        }
        else {
            favBtn.image = #imageLiteral(resourceName: "ic_bookmark_fill_1")
        }
    }
    
    @IBAction func shareButtonTapped() {
        shareWithComment(self.productResponse?.product?.share_link ?? "")
    }
}
extension ProductViewController : UITableViewDelegate,UITableViewDataSource {
    
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
