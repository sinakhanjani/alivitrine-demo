//
//  BrandViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class BrandViewController: AppViewController {

//    ==== IBOutlet ====
    @IBOutlet weak var collectionView: UICollectionView!
    
//    ==== vars ====
    var brandResponseModel : BrandResponseModel?
    var id : Int?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(HomeViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        _ = Network<BrandResponseModel>.init(url: Constant.Url.shopDetail).addParameter(key: "shop_id", value: id).post { (result) in
            result.ifSuccess { [weak self] (response) in
                if response.result == "success" {
                    self?.brandResponseModel = response
                    self?.collectionView.reloadData()
                    refreshControl.endRefreshing()
                }
                else {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.addSubview(self.refreshControl)
        backBarButtonAttribute(color: nil, name: "")
        collectionView.register(ProductWithSizeCollectionViewCell.nib, forCellWithReuseIdentifier: ProductWithSizeCollectionViewCell.nibName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func fetchData(requestForReloading reloading: Bool) {
        super.fetchData(requestForReloading: reloading)
        let network = Network<BrandResponseModel>.init(url: Constant.Url.shopDetail)
        .addParameter(key: "shop_id", value: id)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            if response.result == "success" {
                self?.brandResponseModel = response
                self?.collectionView.reloadData()
            }
            else {
                self?.navigationController?.popViewController(animated: true)
            }
        })
    }

    
}
extension BrandViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandResponseModel?.products?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductWithSizeCollectionViewCell.nibName, for: indexPath) as! ProductWithSizeCollectionViewCell
        let product = brandResponseModel!.products![indexPath.item]
        
        cell.sizeLabel.text = product.size
        cell.titleLabel.text = product.title
        if let imageStr = product.image, let url = URL(string: imageStr) {
            cell.productImage.af_setImage(withURL: url,placeholderImage: #imageLiteral(resourceName: "placeholder.pdf"))
        }
        else {
            cell.productImage.image = #imageLiteral(resourceName: "placeholder.pdf")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let spaceBetweenCells: CGFloat = 20
        let padding: CGFloat = 44
        let cellDimention = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        let height = cellDimention * 0.75
        return CGSize.init(width: cellDimention, height: height)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        // Get the view for the first header
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        // Use this view to calculate the optimal size based on the collection view's width
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BrandCollectionReusableView", for: indexPath) as! BrandCollectionReusableView
        header.delegate = self
        header.switchBookMarkBtn(bookmarked: brandResponseModel?.added_to_favorites ?? 0)
        header.bind(brandResponseModel?.shop)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = brandResponseModel!.products![indexPath.item]
        let vc = ProductViewController.create()
        vc.id = product.id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BrandViewController : BrandCollectionReusableViewDelegate {
    func logoutButtonTapped() {
        
    }
    
    func shareBtnDidTap(_ link: String) {
        self.shareWithComment(link)
    }
    
    func telButtonTapped(_ tel: String) {
        tel.makeACall()
    }
    
    func phoneButtonTapped(_ phone: String) {
        phone.makeACall()
    }
    
    func telegramButtonTapped(_ phone: String) {
        if let url = URL.init(string: phone) {
            WebAPI.openURL(url: url)
        } else {
            self.presentIOSAlertWarning(message: "لینکی برای ارتباط قرار داده نشده", completion: {})
        }
    }
    
    func whatsappButtonTapped(_ phone: String) {
        if let url = URL.init(string: phone) {
            WebAPI.openURL(url: url)
        } else {
            self.presentIOSAlertWarning(message: "لینکی برای ارتباط قرار داده نشده", completion: {})
        }
    }
    
    func bookmarkBtnDidTap() {
        addShopToFavorite()
    }
    
    func addShopToFavorite () {
        showLoading()
        let network = Network<ResponseModel<EmptyModel>>.init(url: Constant.Url.shopAddToFavorite)
       .addParameter(key: "shop_id", value: id)
       handleRequestByUI(network.withPost(), success: { [weak self] response  in
           if response.result == "success" {
            let fav = self?.brandResponseModel?.added_to_favorites
            self?.brandResponseModel?.added_to_favorites = fav == 1 ? 0 : 1
            (self?.collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? BrandCollectionReusableView)?.switchBookMarkBtn(bookmarked: self?.brandResponseModel?.added_to_favorites ?? 0)
           }
       })
    }
    
}
