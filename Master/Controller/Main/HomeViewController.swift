//
//  HomeViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/3/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

enum BlockType {
    case Slider,Product,Brand, Banner
}
class HomeViewController: BaseViewController {

//    === IBOutlet ====
    @IBOutlet weak var tableView: UITableView!
    
//    === vars ===
    var homeResponse : HomePageModel?
    var blocks : [BlockType] = [.Slider,.Brand,.Product,.Brand,.Banner,.Product]
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(HomeViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        _ = Network<HomePageModel>.init(url: Constant.Url.home).post { (result) in
            result.ifSuccess { [weak self] (response) in
                self?.homeResponse = response
                self?.tableView.reloadData()
                refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
        print("token : \(Authentication.auth.token)")
        backBarButtonAttribute(color: nil, name: "")
        tableView.tableFooterView = UIView()
        registerCells()
//        tableView.delegate = self
//        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    

    
    func registerCells () {
        tableView.register(ProductTableViewCell.nib, forCellReuseIdentifier: ProductTableViewCell.className)
        tableView.register(SliderTableViewCell.nib, forCellReuseIdentifier: SliderTableViewCell.className)
        tableView.register(BrandTableViewCell.nib, forCellReuseIdentifier: BrandTableViewCell.className)
    }
    
    override func fetchData(requestForReloading reloading: Bool) {
        super.fetchData(requestForReloading: reloading)
        let network = Network<HomePageModel>.init(url: Constant.Url.home)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            self?.homeResponse = response
            self?.tableView.delegate = self
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
        })
    }
    
    // Method
    func updateUI() {
        _ = Network<SettingModel>
            .init(url: Constant.Url.setting).post { (res) in
                res.ifSuccess { (model) in
                    if let current = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        if let serverVer = Double(model.updateChecker?.ios?.version ?? "") {
                            let versionCompare = current.compare("\(serverVer)", options: .numeric)
                            if versionCompare == .orderedSame {
                                print("same version")
                            } else if versionCompare == .orderedAscending {
                                // will execute the code here
                                print("ask user to update")
                                let vc = UpdateViewController.create()
                                vc.ios = model.updateChecker?.ios
                                self.present(vc, animated: true, completion: nil)
                            } else if versionCompare == .orderedDescending {
                                // execute if current > appStore
                                print("don't expect happen...")
                            }
                        }
                    }
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                }
        }
    }
}

extension HomeViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        switch blocks[indexPath.item] {
        case .Slider:
            cell = tableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.className, for: indexPath)
            (cell as? SliderTableViewCell)?.delegate = self
            (cell as? SliderTableViewCell)?.slider = homeResponse?.sliders
        case .Brand:
            cell = tableView.dequeueReusableCell(withIdentifier: BrandTableViewCell.className, for: indexPath)
            (cell as? BrandTableViewCell)?.delegate = self
            (cell as? BrandTableViewCell)?.indexPath = indexPath
            (cell as? BrandTableViewCell)?.titleLabel.text = indexPath.item == 1 ? "برندهای ویژه" : "برندهای برگزیده"
            (cell as? BrandTableViewCell)?.brands = indexPath.item == 1 ? homeResponse?.special_brands : homeResponse?.best_brands
        case .Product:
            cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.className, for: indexPath)
            (cell as? ProductTableViewCell)?.delegate = self
            (cell as? ProductTableViewCell)?.indexPath = indexPath
            (cell as? ProductTableViewCell)?.titleLabel.text = indexPath.item == 2 ? "جدیدترین محصولات" : "محصولات ویژه"
            (cell as? ProductTableViewCell)?.products = indexPath.item == 2 ? homeResponse?.new_products : homeResponse?.special_products
        case .Banner:
            cell = tableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.className, for: indexPath)
            (cell as? SliderTableViewCell)?.delegate = self
            (cell as? SliderTableViewCell)?.slider = homeResponse?.banners
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch blocks[indexPath.item] {
        case .Slider:
            return UIScreen.main.bounds.width / 2.53
        case .Banner:
            return UIScreen.main.bounds.width / 2.53
        case .Brand:
            return 114
        case .Product:
            return 180
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let block = self.blocks[indexPath.item]
        if block == .Banner {
            if let items = self.homeResponse?.banners {
                if let cell = self.tableView.cellForRow(at: indexPath) as? SliderTableViewCell {
                    
                }
            }
        }
        if block == .Slider {
            
        }
    }
}

extension HomeViewController : GeneralCellDelegate {
    func moreBtnDidSelect(type: UITableViewCell.Type,indexPath : IndexPath) {
        if type is BrandTableViewCell.Type || type is ProductTableViewCell.Type {
            let vc = ListViewController.create()
            vc.type = ListViewController.ListViewControllerType.getType(byIndex: indexPath.item)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func itemSelected(type: UITableViewCell.Type, at index: IndexPath, data: Any) {
        
        if type is SliderTableViewCell.Type {

        }
        else if type is BrandTableViewCell.Type {
            guard let brand = data as? MineralModel else {
                return
            }
            let vc = BrandViewController.create()
            vc.id = brand.id
            navigationController?.pushViewController(vc, animated: true)
        }
        else if type is ProductTableViewCell.Type {
            guard let product = data as? MineralModel else {
                return
            }
            let vc = ProductViewController.create()
            vc.id = product.id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
