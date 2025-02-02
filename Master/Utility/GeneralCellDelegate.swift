//
//  GeneralCellDelegate.swift
//  Master
//
//  Created by Mohammad Fallah on 12/3/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import Foundation

protocol GeneralCellDelegate {
    func moreBtnDidSelect(type : UITableViewCell.Type,indexPath : IndexPath)
    func itemSelected (type : UITableViewCell.Type, at index: IndexPath,data: Any)
}
