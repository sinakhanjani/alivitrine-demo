//
//  FavouriteViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
import TTSegmentedControl
import BmoViewPager

class FavouriteViewController: AppViewController {

//    ==== IBOutlet ====
    @IBOutlet weak var segmentControl: TTSegmentedControl!
    @IBOutlet weak var bmoViewPager: BmoViewPager!
    
    var models : FavoriteResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
        configTab ()
        bmoViewPager.dataSource = self
        bmoViewPager.scrollable = false
    }
    
    func configTab () {
        segmentControl.itemTitles = ["محصولات","برندها"]
        segmentControl.defaultTextFont = UIFont.appFont(with: 14)!
        segmentControl.selectedTextFont = UIFont.appFont(with: 14)!
        segmentControl.didSelectItemWith = { [weak self] (index, title) -> () in
            self?.bmoViewPager.presentedPageIndex = index
        }
        segmentControl.reloadInputViews()
    }
    override func fetchData(requestForReloading reloading: Bool) {
        super.fetchData(requestForReloading: reloading)
        let network = Network<FavoriteResponseModel>.init(url: Constant.Url.favouriteList)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            self?.models = response
            self?.bmoViewPager.reloadData()
        })
    }

    @IBAction func filterBtnPressed(_ sender: Any) {
        present(FilterViewController.create(), animated: true, completion: nil)
    }
}

extension FavouriteViewController : BmoViewPagerDataSource {
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 2
    }
    
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        let vc = ListViewController.create()
        vc.type = .None(segmentControl.currentIndex == 0 ? .Product : .Brand)
        vc.models = segmentControl.currentIndex == 0 ? models?.products : models?.shops
        return vc
    }
    
    
}
