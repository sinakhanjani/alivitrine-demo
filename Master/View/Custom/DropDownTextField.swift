//
//  DropDownTextField.swift
//  Master
//
//  Created by Mohammad Fallah on 11/10/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import Foundation
import DropDown

class DropDownTextField: UITextField {
    
    var isEnabledDropDown = true
    var catDropDown : DropDown!
    var hasNothingChoice = false
    var `default` : Any?
    
    private var dataSource : [String]?
    private var keys : [Any]?
    private(set) var selectedRowIndex : Int?
    override init(frame : CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit () {
        catDropDown = DropDown()
        catDropDown.anchorView = self
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDropDown)))
    }
    
    @objc func showDropDown() {
        if isEnabledDropDown {
            catDropDown.show()
        }
    }
    
    func defualtValue (value : String?) {
        text = value
    }
    
    
    var handler : SelectionClosure?
    func anchorDropDown (dataSource: [String],keys : [Any]? = nil,selectedRow : Int? = nil,handler :  SelectionClosure? = nil) {
        self.keys = keys
        catDropDown.dataSource =  (hasNothingChoice ? ["هیچکدام"]  : []) + dataSource
        catDropDown.reloadAllComponents()
        self.dataSource = dataSource
        if handler != nil {self.handler = handler}
        catDropDown.selectionAction = {[weak self] (index , item) in
            if self?.hasNothingChoice == true && index == 0 {
               self?.text = nil
            }
            else {
                self?.text = item
            }
            self?.selectedRowIndex = index
            self?.handler?(index, self?.hasNothingChoice == true && index == 0 ? "" : item)
            
        }
        if var select = selectedRow {
            select += (hasNothingChoice == true ? 1 : 0)
            catDropDown.selectRow(select)
        }
    }
    
    func setListener (handler : @escaping SelectionClosure) {
        self.handler = handler
    }
    
    func getKeyOfSelected () -> Any? {
        if hasNothingChoice == true && selectedRowIndex == 0 {
            return nil
        }
        else {
            if hasNothingChoice == true {
                return (selectedRowIndex ?? -1) >= 0 ? keys?[selectedRowIndex! - 1] : nil
            }
            else {
                return (selectedRowIndex ?? -1) >= 0 ? keys?[selectedRowIndex ?? 0] : nil
            }
        }
    }
    
    func getKeyOfSelectedOrDefault() -> Any? {
        return getKeyOfSelected() ?? `default`
    }
    
    func getKeyOfSelectedOrValueIfNotSelected() -> Any {
        if (selectedRowIndex ?? -1 >= 0) {
            return getKeyOfSelected() ?? ""
        }
        else {
            return text!
        }
    }
    
    func selectRow (selectedRow : Int?) {
        catDropDown.selectRow(selectedRow ?? 0)
        if (dataSource?.count ?? 0) >= (selectedRow ?? 0) + 1 {
            self.text = dataSource?[selectedRow ?? 0]
        }
    }
}
