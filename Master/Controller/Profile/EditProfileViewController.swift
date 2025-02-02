//
//  EditProfileViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class EditProfileViewController: AppViewController {

//    ==== Outlet ====
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityDropDown: DropDownTextField!
    @IBOutlet weak var provinceDropDown: DropDownTextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var familyTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
//    ==== vars ====
    var selectedIndexPath : IndexPath?
    var categories : [CategoriesModel]?
    var user : ProfileModel?
    var selectedCategories : [Int] = []
    var cities : [City]?
    var provinces : [State]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: nil, name: "")
        guard let user = user else {
          presentIOSAlertWarning(message: "مشخصات پروفایل شما هنوز دریافت نشده است", completion: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
          })
            return;
        }
        bind(user: user)
        getState()
        provinceDropDown.setListener {[weak self] (index, text) in
            let citiesList = self?.cities?.filter{$0.state_code == String(describing: ((self?.provinceDropDown.getKeyOfSelected() as? Int) ?? 0) - 1)} ?? []
            self?.cityDropDown.text = ""
            self?.cityDropDown.anchorDropDown(dataSource: citiesList.map {($0.pname ?? "")}, keys: citiesList.map{$0.id ?? 0}, selectedRow: nil, handler: nil)
        }
    }
    
    @IBAction func saveBtnDidTap(_ sender: Any) {
        Network<EditProfileResponseModel>
            .init(url: Constant.Url.editProfile)
            .addParameter(key: "first_name", value: nameTF.text)
            .addParameter(key: "last_name", value: familyTF.text)
            .addParameter(key: "mobile", value: phoneNumberTF.text)
            .addParameter(key: "state_id", value: ((provinceDropDown.getKeyOfSelected() as? Int) ?? user?.state?.id ?? 0))
            .addParameter(key: "city_id", value: ((cityDropDown.getKeyOfSelected() as? Int) ?? user?.city?.id ?? 0))
            .addParameter(key: "categories", value: self.convertToSendCategory(subIds: selectedCategories, categories: categories))
//            .addParameter(key: "categories", value: selectedCategories.map(String.init).joined(separator: ","))
        .post {[weak self] (result) in
            result.ifSuccess { (response) in
                if response.result == "success",let new = response.user {
                    self?.user?.copyData(from: new)
                    self?.presentIOSAlertWarning(message: "تغییرات با موفقیت ثبت شد", completion: {
                        [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    })
                    
                }
                else {
                    self?.presentIOSAlertWarning(message: "متاسفانه مشکلی پیش آمده است", completion: {})
                }
            }
        }
    }
    func getState () {
        Network<ProvinceResponseModel>.init(url: Constant.Url.states)
        .post { [weak self] (result) in
            result.ifSuccess { (model) in
                self?.cities = model.cities
                self?.provinces = model.states
                if let states = model.states {
                    self?.provinceDropDown.anchorDropDown(dataSource: states.map{$0.pname ?? ""}, keys: states.map{$0.id ?? 0}, selectedRow: nil, handler: nil)
                    let citiesList = self?.cities?.filter{$0.state_code == (self?.user?.state?.code) ?? "" } ?? []
                    self?.cityDropDown.anchorDropDown(dataSource: citiesList.map {($0.pname ?? "")}, keys: citiesList.map{$0.id ?? 0}, selectedRow: nil, handler: nil)
                }
            }
        }
    }
    func bind (user : ProfileModel) {
        nameTF.text = user.first_name
        familyTF.text = user.last_name
        phoneNumberTF.text = user.mobile
        phoneNumberTF.isUserInteractionEnabled = false
        provinceDropDown.text = user.state?.pname
        cityDropDown.text = user.city?.pname
        selectedCategories = user.sub_categories?.compactMap {$0.id} ?? []
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
extension EditProfileViewController : UITableViewDelegate,UITableViewDataSource,YourJubTableViewCellDlegate {
    
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
        tableView.beginUpdates()
        (tableView.cellForRow(at: indexPath) as? YourJubTableViewCell)?.arrowImage.image = selectedIndexPath?.item != indexPath.item ?  #imageLiteral(resourceName: "arrow_buttom") : #imageLiteral(resourceName: "arrow_up")
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

