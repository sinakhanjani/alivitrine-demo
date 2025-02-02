//
//  FridendTableViewCell.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol FriendTableViewCellDelegate {
    func shareButtonTapped(cell: FriendTableViewCell)
}

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icHuman: UIImageView!
    @IBOutlet weak var background: UIView!
    
    var delegate:FriendTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        delegate?.shareButtonTapped(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configUI (invited : Bool) {
        if invited {
            background.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
            icHuman.tintColor = #colorLiteral(red: 0.9960784314, green: 0.4156862745, blue: 0, alpha: 1)
            statusLabel.textColor = #colorLiteral(red: 0.9960784314, green: 0.4156862745, blue: 0, alpha: 1)
            logo.image = #imageLiteral(resourceName: "logo.pdf")
            statusLabel.text = "علی ویترینی"
        }
        else {
            background.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
            icHuman.tintColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
            statusLabel.textColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
            logo.image = #imageLiteral(resourceName: "logo_disable")
            statusLabel.text = "دعوت به علی ویترین"
        }
    }
}
