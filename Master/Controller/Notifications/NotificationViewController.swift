//
//  NotificationViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol NotificationViewControllerDelegate {
    func notifDidChanged()
}

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var models : [NotificationModel]?
    var delegate:NotificationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        models = models?.reversed()
        backBarButtonAttribute(color: nil, name: "")
        read()
    }

    func read() {
        Network<ResponseModel<EmptyModel>>.init(url: Constant.Url.read).post { (response) in
            response.ifSuccess { _ in
            }
        }
        delegate?.notifDidChanged()
    }
    
}

extension NotificationViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let notif = models![indexPath.item]
        cell.titleLabel1.text = notif.body
        cell.titleLabel2.text = notif.title
        cell.titleLabel3.text = notif.updated_at?.date
        if notif.image == nil {
            cell.imageView1.isHidden = true
        }
        else {
            if let imageStr = notif.image, let url = URL(string: imageStr) {
                cell.imageView1.af_setImage(withURL: url,placeholderImage: #imageLiteral(resourceName: "placeholder.pdf"))
            }
            else {
                cell.imageView1.image = #imageLiteral(resourceName: "placeholder.pdf")
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: models![indexPath.item].openUrl ?? "") {
            WebAPI.openURL(url: url)
        }
    }
}
