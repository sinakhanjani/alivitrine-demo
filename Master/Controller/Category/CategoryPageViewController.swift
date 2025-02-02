//
//  CategoryPageViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
protocol CategoryPageViewControllerDelegate {
    func tableViewCategory(didSelectAt indexPath : IndexPath,page : Int,id : Int)
}
class CategoryPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var categories : CategoriesModel?
    var page : Int!
    var delegate : CategoryPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
        tableView.tableFooterView = UIView()
    }
    
}

extension CategoryPageViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.childs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        let category = categories!.childs![indexPath.item]
        cell.titleLabel.text = category.title
//        cell.imageCategory.image = category.icon_image?.textToImage()
        cell.imageCategory.loadImageUsingCache(withUrl: category.icon_image ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableViewCategory(didSelectAt: indexPath,page: page,id: categories!.childs![indexPath.item].id ?? 0)
        
    }
}
