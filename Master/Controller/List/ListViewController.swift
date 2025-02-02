//
//  ListViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/3/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
import Alamofire

typealias GenericTypeList = (title:String,url:String)
class ListViewController: AppViewController {

    enum ListViewControllerType {
        case SpecialProduct,SpecialBrand,NewProduct,BestBrand
        case Other_Product(GenericTypeList)
        case Other_Brand(GenericTypeList)
        case None(ListViewControllerType.MainType)
        var title : String {
            switch self{
            case .SpecialBrand:
                return "همه برندها"
            case .SpecialProduct:
                return "محصولات ویژه"
            case .NewProduct:
                return "محصولات جدید"
            case .BestBrand:
                return "همه برندها"
            case .Other_Brand(let a), .Other_Product(let a):
                return a.title
            case .None(_):
                return ""
            }
        }
        enum MainType {
            case Product,Brand
        }
        var type : MainType {
            switch self {
            case .SpecialBrand:
                return .Brand
            case .SpecialProduct:
                return .Product
            case .NewProduct:
                return .Product
            case .BestBrand:
                return .Brand
            case .Other_Product(_):
                return .Product
            case .Other_Brand(_):
                return .Brand
            case .None(let a):
                return a
            }
        }
        var url : String {
            switch self{
            case .SpecialBrand:
                return Constant.Url.specialBrands
            case .SpecialProduct:
                return Constant.Url.specialProduct
            case .NewProduct:
                return Constant.Url.newProduct
            case .BestBrand:
                return Constant.Url.bestBrands
            case .Other_Product(let a), .Other_Brand(let a):
                return a.url
            case .None:
                return ""
            }
        }
        static func getType(byIndex index : Int) -> ListViewControllerType {
            switch index {
            case 1:
            return .SpecialBrand
            case 2:
            return .NewProduct
            case 3:
            return .BestBrand
            case 5:
            return .SpecialProduct
            default:
            return .SpecialProduct
            }
        }
    }
    
//    ==== Outlet ====
    @IBOutlet weak var collectionView: UICollectionView!
    
//    ==== vars ====
    var type : ListViewControllerType = .NewProduct
    var models : [MineralModel]?
    var extraParameters : Parameters?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
        collectionView.register(ProductCollectionViewCell.nib, forCellWithReuseIdentifier: ProductCollectionViewCell.nibName)
        collectionView.dataSource = self
        collectionView.delegate = self
        title = type.title
    }
    
    override func fetchData(requestForReloading reloading: Bool) {
        if case ListViewControllerType.None (_) = type {return}
        super.fetchData(requestForReloading: reloading)
        let network = Network<MoreModel>.init(url: type.url)
        .addParameters(params: extraParameters)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            self?.models = response.data
            self?.collectionView.reloadData()
        })
    }

}
extension ListViewController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
        let model = models![indexPath.item]
        cell.titleLabel.text = model.title
        if let imageStr = model.image, let url = URL(string: imageStr) {
            cell.productImage.af_setImage(withURL: url,placeholderImage: #imageLiteral(resourceName: "placeholder.pdf"))
        }
        else {
            cell.productImage.image = #imageLiteral(resourceName: "placeholder.pdf")
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models![indexPath.item]
        if type.type == .Brand {
            let vc = BrandViewController.create()
            vc.id = model.id
            navigationController?.pushViewController(vc, animated: true)
        }
        else if type.type == .Product {
            let vc = ProductViewController.create()
            vc.id = model.id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let spaceBetweenCells: CGFloat = 20
        let padding: CGFloat = 42
        let cellDimention = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        let height = type.type == .Product ? 0.7 * cellDimention : 0.8 * cellDimention
        return CGSize.init(width: cellDimention, height: height)

    }
}


