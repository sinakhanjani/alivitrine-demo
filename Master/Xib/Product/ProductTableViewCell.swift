//
//  ProductTableViewCell.swift
//  Master
//
//  Created by Mohammad Fallah on 12/3/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell,NibInstantiatable {
    
//    ==== IBOutlet ====
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
//    ==== vars ====
    var delegate : GeneralCellDelegate?
    var indexPath : IndexPath!
    var products : [MineralModel]? {
        didSet {
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        === initCollectionView ===
        collectionView.register(ProductCollectionViewCell.nib, forCellWithReuseIdentifier: ProductCollectionViewCell.className)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func moreBtnDidTap(_ sender: Any) {
        delegate?.moreBtnDidSelect(type: ProductTableViewCell.self,indexPath: indexPath)
    }
}

extension ProductTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
        let product = products![indexPath.item]
        if let imageStr = product.image, let url = URL(string: imageStr) {
            cell.productImage.af_setImage(withURL: url,placeholderImage: #imageLiteral(resourceName: "placeholder.pdf"))
        }
        else {
            cell.productImage.image = #imageLiteral(resourceName: "placeholder.pdf")
        }
        cell.titleLabel.text = product.title
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(148.75, 119)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.itemSelected(type: ProductTableViewCell.self, at: indexPath, data: products![indexPath.item])
    }
}
