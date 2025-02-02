//
//  FriendsListViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
import Contacts
import WebKit

class FriendsListViewController: BaseViewController,FriendTableViewCellDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    //    ===== Vars ======
    var objects : [CNContact]?
    let formatter = CNContactFormatter()
    var allowContacts = [String]()
    var aliVitrinContacts : [ContactModel]?
    var inviteMessage = ""

//    ===== Outlet ======
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://www.alivitrine.ir/fa/support") {
            webView.loadRequest(URLRequest(url: url))
        }
        backBarButtonAttribute(color: nil, name: "")
//        getContacts()
    }
    
    override func fetchData(requestForReloading reloading: Bool) {
        super.fetchData(requestForReloading: reloading)
        let network = Network<SettingModel>.init(url: Constant.Url.setting)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            self?.inviteMessage = response.invite_message ?? ""
        })
    }
    
    func shareButtonTapped(cell: FriendTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let contact = aliVitrinContacts![indexPath.row]
            //
            self.shareWithComment(inviteMessage)
        }
    }
    
//    =======================
//    GET CONTACTS FROM IPHONE
//    ========================
    func getContacts() {
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: Error?) -> Void in
                if authorized {
                    self.retrieveContactsWithStore(store: store)
                }
                })
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.retrieveContactsWithStore(store: store)
        }
    }
    func retrieveContactsWithStore(store: CNContactStore) {
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey] as [Any]
        var allContainers: [CNContainer] = []
        do {
            allContainers = try store.containers(matching: nil)
        } catch {
            
        }
        var contacts: [CNContact] = []
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
        
            do {
                let containerResults = try store.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                contacts.append(contentsOf: containerResults)
            } catch {
                
            }
        }
        self.objects = contacts
        DispatchQueue.main.async(execute: { () -> Void in
            self.getAliVitrinContacts()
        })
    }
    
//    =========
//    SEND DATA
//    ==========
    func getAliVitrinContacts () {
        if objects == nil {
            presentIOSAlertWarning(message: "متاسفانه مشکلی در دریافت لیست مخاطبین پیش آمده است", completion: {})
            return
        }
        guard let contacts = organizeContact() else {
            return
        }
        sendContact(contacts: contacts)
    }
    
    func organizeContact () -> [ContactModel]? {
        var alls = [ContactModel]()
        if let objects = objects {
            for model in objects {
                if !model.phoneNumbers.isEmpty {
                    let phone = model.phoneNumbers[0].value.stringValue.replacingOccurrences(of: " ", with: "").toEngNumbers()
                    let n = ContactModel(mobile: phone.replacingOccurrences(of: "+98", with: "0"),name: formatter.string(from: model) ?? "")
                    alls.append(n)
                }
            }
            return alls
        }
        return nil
//        objects?.compactMap({ (model) -> ContactModel?  in
//            let phone = model.phoneNumbers[0].value.stringValue.replacingOccurrences(of: " ", with: "").toEngNumbers()
//            print(phone)
//            return ContactModel(mobile: phone.replacingOccurrences(of: "+98", with: "0"),name: formatter.string(from: model) ?? "")
//        })
    }
    
    func sendContact (contacts : [ContactModel]) {
        _ = Network<ContactsResponseModel>
        .init(url: Constant.Url.contactList)
        .addParameter(key: "contactList", value: contacts.toJSON())
        .post {[weak self] (result) in
            result.ifSuccess { (response) in
                self?.aliVitrinContacts = response.contacts?.sorted(by: {$0.registerd ?? 0 > $1.registerd ?? 0})
                UserDefaults.standard.set(response.contacts?.filter({$0.registerd == 1}).count ?? 0, forKey: "MyFriendCount")
                
                self?.tableView.reloadData()
            }
        }
    }
}

extension FriendsListViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aliVitrinContacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.className, for: indexPath) as! FriendTableViewCell
        cell.delegate = self
        let contact = aliVitrinContacts![indexPath.row]
        cell.nameLabel.text = contact.name
        cell.configUI(invited: contact.registerd ?? 0 == 1)

        return cell
    }
}
