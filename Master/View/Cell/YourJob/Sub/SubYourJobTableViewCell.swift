//
//  SubYourJobTableViewCell.swift
//  Master
//
//  Created by Mohammad Fallah on 12/3/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class SubYourJobTableViewCell: UITableViewCell,NibInstantiatable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tikImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        tikImage.isHidden = !selected
    }
    
}
