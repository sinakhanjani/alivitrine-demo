//
//  AppViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/27/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
import JGProgressHUD
/// AppViewController created for Online Apps that have Api
/// every class that fetch data from api should use it to handle errors in UI and can reload data when necessary
class AppViewController: NoBackTitleViewController {

    open var shouldReloadDataWhenNecessary : Bool {
        return true
    }
    open var showLoadingWhenReloading : Bool {
        return true
    }
    open var showLoadingWhenFetching : Bool {
        return true
    }
    
    private lazy var hud : JGProgressHUD = {
        let ihud = JGProgressHUD(style: .light)
        return ihud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self // iOS13
        fetchData(requestForReloading: false)
        if shouldReloadDataWhenNecessary {
            addFetchingObserver()
        }
    }
    
    func addFetchingObserver (){
        NotificationCenter.default.addObserver(self, selector: #selector(tryForData), name: Constant.Notify.tryForData, object: nil)
    }
    
    @objc private func tryForData () {
        if shouldReloadDataWhenNecessary {
            if showLoadingWhenReloading && showLoadingWhenFetching { showLoading()}
            reloadData()
        }
    }
    
    /// if you want to reload page when necessary (e.g. internet connection was lost) you can override reloadData Function
    /// by default: reloadData Function called fetchData, if you don't want to call fetch data you should override and don't put super.reloadData() in body of this
    func reloadData () {
        fetchData(requestForReloading : true)
    }
    /// this function called in viewDidLoad and you can use handleRequestByUI functuion on this to handle Errors in UI
    /// if you override reloadData function and not let to call super.reloadData() in it's body, this func never been called with requestForReloading: true value
    @objc func fetchData (requestForReloading reloading : Bool) {
        let isMethodXOverridden = self.method(for: #selector(fetchData)) != AppViewController.instanceMethod(for: #selector(fetchData))
        
        if !isMethodXOverridden {
            //called from appViewController Class (this method does not implemenet in subClass)
        }
        else {
            if showLoadingWhenFetching && (!reloading) { showLoading() }
        }
    }
    
    let disposeBag = DisposeBag()
    ///when you want to handle errors By UI (means Show Alert to user or any Action you think), pass the network request to this function
    func handleRequestByUI<T> (_ network : Network<T>,success: @escaping (T) -> Void,error : ((Error)->Void)? = nil) {
        network.fire { [weak self] (result) in
            result.ifSuccess { final in
                if self?.showLoadingWhenFetching == true || self?.showLoadingWhenReloading == true {
                    self?.dismissLoading()
                }
                success(final)
            }
            result.ifFailed { (resError) in
                if self?.showLoadingWhenFetching == true  || self?.showLoadingWhenReloading == true {
                    self?.dismissLoading()
                }
                self?.handleConnectionErrors(error: resError)
                error?(resError)
            }
        }.disposed(by: disposeBag)
    }
    
    private func handleConnectionErrors (error : Error) {
        switch error {
        case NetworkErrors.NotFound:
            break;
        case NetworkErrors.Unathorized:
            break;
        case NetworkErrors.InternalError:
            break;

        case NetworkErrors.BadURL:
            break;
        case NetworkErrors.BadRequest:
            break;
        case NetworkErrors.TimeOuted:
//              you should call "NotificationCenter.default.post(name: .tryForData, object: nil)" to refresh all view controllers
            break;
        default:
            break
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func customizeNavigationAndTabView() {
        let customNavView = UIView.init(frame: CGRect.init(0, 0, 120, 50))
        customNavView.backgroundColor = .clear
        let label = UILabel.init(frame: CGRect.init(0, 0, 120, 50))
        label.font = UIFont.init(name: Constant.Fonts.casablancaRegular, size: 20)!
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = ""
        customNavView.addSubview(label)
        navigationItem.titleView = customNavView
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.appFont(with:16),NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        // add yellow Line To NavigationController
        guard let _ = self.navigationController else { return }
        let yellowView = UIView(frame: CGRect(x: 0, y: navigationController!.navigationBar.bounds.height, width: UIScreen.main.bounds.width, height: 0.5))
        yellowView.backgroundColor = #colorLiteral(red: 0.7625358701, green: 0.5855332017, blue: 0.1807247698, alpha: 1)
        navigationController?.navigationBar.addSubview(yellowView)
        // add Line to TabBarController
        let tabBarLine = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5))
        tabBarLine.backgroundColor = #colorLiteral(red: 0.7625358701, green: 0.5855332017, blue: 0.1807247698, alpha: 1)
        tabBarController?.tabBar.addSubview(tabBarLine)
        //
    }
    
    func showLoading() {
        hud.show(in: self.view)
    }
    
    func dismissLoading () {
        hud.dismiss()
    }
}

// iOS13
extension AppViewController: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

class BaseViewController : AppViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let navView = UINib(nibName: "CustomNavView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
        navigationItem.titleView = navView
        navView.frame = navigationController?.navigationBar.frame ?? CGRect.zero
    }
}

class NoBackTitleViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: UIColor.appBackButtonColor, name: "")
    }
}
