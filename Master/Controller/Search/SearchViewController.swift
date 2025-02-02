//
//  SearchViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textFeild: UITextField!
    var response : FavoriteResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
        collectionView.register(ProductCollectionViewCell.nib, forCellWithReuseIdentifier: ProductCollectionViewCell.nibName)
    }
    
    override func fetchData(requestForReloading reloading: Bool) {
        if !self.textFeild.text!.isEmpty {
            super.fetchData(requestForReloading: reloading)
            let network = Network<FavoriteResponseModel>.init(url: Constant.Url.productSearch)
            .addParameter(key: "search", value: textFeild.text)
            handleRequestByUI(network.withPost(), success: { [weak self] response  in
                self?.response = response
                self?.collectionView.reloadData()
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reloadData()
        return true
    }
}

extension SearchViewController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let shopsCount = response?.shops?.count ?? 0
        let productsCount = response?.products?.count ?? 0
        if shopsCount == 0 && productsCount == 0 {
            self.collectionView.setEmptyMessage("آیتمی یافت نشد.")
        } else {
            self.collectionView.restore()
        }
        if section == 0 {
            return shopsCount
        }
        else {
            return productsCount
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
        var item : MineralModel!
        if indexPath.section == 0 {
            item = response!.shops![indexPath.row]
        }
        else {
            item = response!.products![indexPath.row]
        }
        cell.titleLabel.text = item.title
        if let imageStr = item.image, let url = URL(string: imageStr) {
            cell.productImage.af_setImage(withURL: url,placeholderImage: #imageLiteral(resourceName: "placeholder.pdf"))
        }
        else {
            cell.productImage.image = #imageLiteral(resourceName: "placeholder.pdf")
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if indexPath.section == 0 {
            let brand = response!.shops![indexPath.row]
            let vc = BrandViewController.create()
            vc.id = brand.id
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let product = response!.products![indexPath.row]
            let vc = ProductViewController.create()
            vc.id = product.id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let spaceBetweenCells: CGFloat = 20
        let padding: CGFloat = 42
        let cellDimention = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        let height = 0.7 * cellDimention
        return CGSize.init(width: cellDimention, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchHeaderCollectionReusableView.className, for: indexPath) as! SearchHeaderCollectionReusableView
        header.titleSection.text = indexPath.section == 0 ? "برندها" : "محصولات"
        return header
    }
}



extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.appFont(with: 16)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }

    func restore() {
        self.backgroundView = nil
    }
}
