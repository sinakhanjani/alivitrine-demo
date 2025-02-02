//
//  BrandTableViewCell.swift
//  Master
//
//  Created by Mohammad Fallah on 12/3/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class BrandTableViewCell: UITableViewCell,NibInstantiatable {

//    ==== IBOutlet ====
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
//    ==== vars ====
    var delegate : GeneralCellDelegate?
    var indexPath : IndexPath!
    var brands : [MineralModel]? {
        didSet {
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(BrandCollectionViewCell.nib, forCellWithReuseIdentifier: BrandCollectionViewCell.className)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func moreBtnDidTap(_ sender: Any) {
        delegate?.moreBtnDidSelect(type: BrandTableViewCell.self, indexPath: indexPath)
    }
}

extension BrandTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brands?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.className, for: indexPath) as! BrandCollectionViewCell
        if let imageStr = brands![indexPath.item].image, let url = URL(string: imageStr) {
            cell.imageButton.af_setImage(withURL: url,placeholderImage: #imageLiteral(resourceName: "placeholder.pdf"))
        }
        else {
            cell.imageButton.image = #imageLiteral(resourceName: "placeholder.pdf")
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(67, 67)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.itemSelected(type: BrandTableViewCell.self, at: indexPath, data: brands![indexPath.item])
    }
}
