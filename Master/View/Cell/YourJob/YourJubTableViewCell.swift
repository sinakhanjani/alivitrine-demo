//
//  YourJubTableViewCell.swift
//  Master
//
//  Created by Mohammad Fallah on 12/3/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
protocol YourJubTableViewCellDlegate : class {
    func selectedCategory (withId id : Int,select : Bool,indexPath: IndexPath)
}
class YourJubTableViewCell: UITableViewCell {

//    ==== IBOutlet =====
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var title: UILabel!
    var childs : [CategoryChildModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegate : YourJubTableViewCellDlegate?
    var selectedChilds : [Int]! //this will be pointer (at runtime)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(SubYourJobTableViewCell.nib, forCellReuseIdentifier: "SubYourJobTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
extension YourJubTableViewCell : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubYourJobTableViewCell", for: indexPath) as! SubYourJobTableViewCell
        let item = childs![indexPath.item]
        cell.titleLabel.text = item.title
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCategory(withId: childs![indexPath.item].id ?? 0,select: true, indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        delegate?.selectedCategory(withId: childs![indexPath.item].id ?? 0,select: false, indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = childs![indexPath.item]
        if (selectedChilds.contains(item.id ?? -1)) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        
    }
}
