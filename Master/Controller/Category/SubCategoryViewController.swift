//
//  SubCategoryViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
import TTSegmentedControl
import BmoViewPager

class SubCategoryViewController: AppViewController {

//    ==== IBOutlet ====
    @IBOutlet weak var segmentControl: TTSegmentedControl!
    @IBOutlet weak var bmoViewPager: BmoViewPager!
    @IBOutlet weak var filterBarBtn: UIBarButtonItem!
    
    var id : Int?
    var response : SearchResponseModel?
    var productFilterSpecifications: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
        configTab ()
        bmoViewPager.dataSource = self
        bmoViewPager.delegate = self
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

    @IBAction func filterBtnPressed(_ sender: Any) {
        let filter = FilterViewController.create()
        if (response?.specifications?.count ?? 0) > 0 {
            filter.specifications = response?.specifications
            filter.delegate = self
            present(filter, animated: true, completion: nil)
        }
        else {
            presentIOSAlertWarning(message: "فیلتری برای این دسته بندی یافت نشد", completion: {})
        }
    }
    override func fetchData(requestForReloading reloading: Bool) {
        super.fetchData(requestForReloading: reloading)
        let network = Network<SearchResponseModel>.init(url: Constant.Url.productOfCategoryList)
        .addParameter(key: "category_id", value: id)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            self?.response = response
//            self?.bmoViewPager.reloadData()
        })
    }
}

extension SubCategoryViewController : BmoViewPagerDataSource,BmoViewPagerDelegate,FilterViewControllerDelegate {
    
    func applyFilter(specifications: [Int]) {
        self.productFilterSpecifications = specifications
        bmoViewPager.reloadData()
    }
    
    func bmoViewPagerDelegate(_ viewPager: BmoViewPager, pageChanged page: Int) {
        if page == 0 {
            self.filterBarBtn.isEnabled = true
            self.filterBarBtn.tintColor = UIColor.black
        }
        else {
            self.filterBarBtn.isEnabled = false
            self.filterBarBtn.tintColor = UIColor.clear
        }
    }
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 2
    }
    
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        let vc = ListViewController.create()
        if segmentControl.currentIndex == 0 {
            //Product
            vc.type = .Other_Product((title: "",url: Constant.Url.productSearchFilter))
            vc.extraParameters = ["category_id":id ?? "","brands":[String](),"specification":productFilterSpecifications]
        }
        else {
            //Brand
            vc.type = .Other_Brand((title: "",url: Constant.Url.productOfCategoryList))
            vc.extraParameters = ["category_id":id ?? ""]
        }
        return vc
    }
    
    
}
