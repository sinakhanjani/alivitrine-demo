//
//  CategoryViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
import BmoViewPager

class CategoryViewController: BaseViewController {

//    ===== variables =====
    var categories : [CategoriesModel]?
    
//    ===== IBOutlet =====
    @IBOutlet weak var bmoViewPager: BmoViewPager!
    @IBOutlet weak var bmoNav: BmoViewPagerNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
        bmoViewPager.dataSource = self
        bmoNav.viewPager = bmoViewPager
        bmoViewPager.presentedPageIndex = 2
    }
    override func fetchData(requestForReloading reloading: Bool) {
        super.fetchData(requestForReloading: reloading)
        let network = Network<ListResponseModel<CategoriesModel>>.init(url: Constant.Url.categoryList)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            if let categories = response.data {
                self?.categories = categories
                self?.bmoViewPager.reloadData()
            }
        })
    }
}

extension CategoryViewController : BmoViewPagerDataSource,
CategoryPageViewControllerDelegate {
    
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return categories?.count ?? 0
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        let vc = CategoryPageViewController.create()
        vc.categories = categories![page]
        vc.delegate = self
        vc.page = page
        return vc
    }

    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        return categories![page].title
    }
    func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.appFont(with: 14),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1).withAlphaComponent(0.5)
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.appFont(with: 14),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9960784314, green: 0.4156862745, blue: 0, alpha: 1)
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        return CGSize(navigationBar.frame.width / 3, navigationBar.frame.height)
    }
    func tableViewCategory(didSelectAt indexPath: IndexPath, page: Int, id: Int) {
        let vc = SubCategoryViewController.create ()
        vc.id = id
        vc.title = categories![page].title
        navigationController?.pushViewController(vc, animated: true)
    }
}
