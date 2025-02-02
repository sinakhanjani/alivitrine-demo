//
//  ShopManagementViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class ShopManagementViewController: AppViewController {

//    ==== IBOutlet ====
    @IBOutlet weak var nothingFoundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var countLabel: UILabel!

//    === vars ====
    var COUNT = 0 {didSet {nothingFoundView.isHidden = COUNT > 0}}
    var brandResponseModel : BrandResponseModel?
    var goToEdit = false

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
        collectionView.register(ProductCollectionViewCell.nib, forCellWithReuseIdentifier: ProductCollectionViewCell.nibName)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: Constant.Notify.refreshManagment, object: nil)
    }
    
    @objc func refreshView() {
        _ = Network<BrandResponseModel>.init(url: Constant.Url.myShopDetail).post(callback: { (result) in
            result.ifSuccess { [weak self] (response) in
                self?.brandResponseModel = response
                self?.COUNT = response.products?.count ?? 0
                self?.countLabel.text = "\((response.shop?.views_count ?? 0))"
                self?.collectionView.reloadData()
            }
        })
    }
    
    @IBAction func addProductButtonTapped(_ sender: Any) {
        let vc = AddProductStep1ViewController.create()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func fetchData(requestForReloading reloading: Bool) {
        super.fetchData(requestForReloading: reloading)
        let network = Network<BrandResponseModel>.init(url: Constant.Url.myShopDetail)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            self?.brandResponseModel = response
            self?.COUNT = response.products?.count ?? 0
            self?.countLabel.text = "\((response.shop?.views_count ?? 0))"
            self?.collectionView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if goToEdit {
            collectionView.reloadData()
            goToEdit = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            goToEdit = true
            (segue.destination as? EditShopViewController)?.model = brandResponseModel?.shop
        }
    }
    
    @IBAction func changePasswordButtontapped() {
        let vc = VendorChangePasswordViewController.create()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension ShopManagementViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return COUNT > 0 ? (COUNT + 1) : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == COUNT {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "addNewCell", for: indexPath)
        }
        let product = brandResponseModel!.products![indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.nibName, for: indexPath) as! ProductCollectionViewCell
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
        let height = cellDimention * 0.8
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
        header.bind(brandResponseModel?.shop)
        header.delegate = self
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == COUNT {
            navigationController?.pushViewController(AddProductStep1ViewController.create(), animated: true) 
        }
        else {
            let vc = ProductManageViewController.create()
            vc.id = brandResponseModel!.products![indexPath.item].id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ShopManagementViewController: BrandCollectionReusableViewDelegate {
    func shareBtnDidTap(_ link: String) {
        
    }
    
    func bookmarkBtnDidTap() {
        
    }
    
    func telButtonTapped(_ tel: String) {
        
    }
    
    func phoneButtonTapped(_ phone: String) {
        
    }
    
    func telegramButtonTapped(_ phone: String) {
        
    }
    
    func whatsappButtonTapped(_ phone: String) {
        
    }
    
    func logoutButtonTapped() {
        UserDefaults.standard.set(false, forKey: "loginAsManager")
        self.navigationController?.popToRootViewController(animated: true)
    }
}


