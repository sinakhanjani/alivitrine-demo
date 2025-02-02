//
//  SliderTableViewCell.swift
//  Master
//
//  Created by Mohammad Fallah on 12/3/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class SliderTableViewCell: UITableViewCell,NibInstantiatable {

//    === IBOutlet ====
    @IBOutlet weak var imageSlier: ImageSlider!
    
//    ==== vars ====
    var delegate : GeneralCellDelegate?
    var slider : [ImageModel]? {
        didSet {
            makeFakeData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //
    }

    func makeFakeData () {
        imageSlier.images = slider?.map {$0.image ?? ""}
        imageSlier.urls = slider?.map {$0.url ?? "https://www.alivitrine.ir"}
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
