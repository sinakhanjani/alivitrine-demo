//
//  YourJobViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/3/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
import JWTDecode

class YourJobViewController: AppViewController {

//    ==== IBOutlet ====
    @IBOutlet weak var checkBox: CheckBoxView!
    @IBOutlet weak var tableView: UITableView!
    
//    ==== vars ====
    var selectedIndexPath : IndexPath?
    var categories : [CategoriesModel]?
    var selectedCategories : [Int] = []
    var userId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
    }
    
    @IBAction func startBtnDidPress(_ sender: Any) {
//        if checkBox.checked {
//        }
//        else {
//            presentIOSAlertWarning(message: "لطفا برای ادامه دادن با قوانین و مقررات موافقت نمایید", completion: {})
//        }

        addCategoryToMyProfile()

    }
    
    func addCategoryToMyProfile () {
        guard let token = Authentication.auth.token else {
            return
        }
        if selectedCategories.count == 0 {
            presentIOSAlertWarning(message: "لطفا یک دسته بندی را انتخاب کنید", completion: {})
            return
        }
        showLoading()
        Network<ResponseModel<EmptyModel>>
        .init(url: Constant.Url.setCategoryRegister)
        .addParameter(key: "user_id", value: String(userId ?? 858))
//        .addParameter(key: "categories", value: selectedCategories)
            .addParameter(key: "categories", value: self.convertToSendCategory(subIds: selectedCategories, categories: categories))
        .post {[weak self] (result) in
            print(result)
            result.ifSuccess { (response) in
                self?.performSegue(withIdentifier: "unwindToLoader", sender: nil)
            }
        }
    }
    
    private func userIdFromToken(token: String) -> String? {
        guard let jwt = try? decode(jwt: token) else { return nil}
        if let subject = jwt.claim(name: "sub").string {
            return subject
        }
        return nil
    }
    
    @IBAction func treatsBtnDidPressed(_ sender: Any) {
        if let url = URL(string: "https://www.alivitrine.ir/fa/rules") {
            WebAPI.openURL(url: url)
        }
    }

    override func fetchData(requestForReloading reloading: Bool) {
        super.fetchData(requestForReloading: reloading)
        let network = Network<ListResponseModel<CategoriesModel>>.init(url: Constant.Url.registerCategories)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            if let categories = response.data {
                self?.categories = categories
                self?.tableView.reloadData()
            }
        })
    }
    
    
}
extension YourJobViewController : UITableViewDelegate,UITableViewDataSource,YourJubTableViewCellDlegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! YourJubTableViewCell
        let item = categories![indexPath.item % categories!.count]
        cell.title.text = item.title
        cell.selectedChilds = selectedCategories
        cell.childs = item.childs
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPath == indexPath {
            selectedIndexPath = nil
        }
        else {
            selectedIndexPath = indexPath
        }
        (tableView.cellForRow(at: indexPath) as? YourJubTableViewCell)?.arrowImage.image = selectedIndexPath?.item != indexPath.item ?  #imageLiteral(resourceName: "arrow_buttom") : #imageLiteral(resourceName: "arrow_up")
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(indexPath != selectedIndexPath ? 50 : 60 + ((categories![indexPath.item % categories!.count].childs?.count ?? 0) * 45))
    }
    func selectedCategory(withId id: Int,select : Bool, indexPath: IndexPath) {
        if !select {
            selectedCategories.removeAll(where: {$0 == id})
        }
        else {
            selectedCategories.append(id)
        }
    }
    
    func convertToSendCategory(subIds: [Int], categories: [CategoriesModel]?) -> [[String:String]] {
        guard let categories = categories else {
            return []
        }
        var sendCategorys: [[String:String]] = []
        categories.forEach { (category) in
            if let childs = category.childs {
                for child in childs {
                    if subIds.contains(child.id!) {
                        let sendCategory = ["main_category_id":"\(category.id!)","sub_category_id":"\(child.id!)"]
                        sendCategorys.append(sendCategory)
                    }
                }
            }
        }

        return sendCategorys
    }
}
