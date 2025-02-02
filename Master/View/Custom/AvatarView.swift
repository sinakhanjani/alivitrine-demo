//
//  AvatarView.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

@IBDesignable
class AvatarView: UIView {
    var imageView : UIImageView!
    @IBInspectable public var image : UIImage? {
        didSet {
            commonInit()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit ()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit ()
    }

    func commonInit () {
        backgroundColor = .clear
        let myView = UIView()
        myView.translatesAutoresizingMaskIntoConstraints = true
        myView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        myView.backgroundColor = .clear
        addSubview(myView)
        myView.frame = self.bounds
        
        let circle1 = UIView()
        circle1.frame = myView.bounds
        circle1.layer.cornerRadius = myView.frame.height / 2
        circle1.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.2117647059, blue: 0.5725490196, alpha: 0.1)
        myView.addSubview(circle1)
        
        let circle2 = UIView()
        var padding : CGFloat = CGFloat(11.6)
        circle2.frame = CGRect(padding, padding, circle1.frame.height - (2 * padding), circle1.frame.width - (2 * padding))
        circle2.layer.cornerRadius = circle2.frame.height / 2
        circle2.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        circle2.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.4156862745, blue: 0, alpha: 0.1)
        circle1.addSubview(circle2)
        
        padding = CGFloat(13.3)
        imageView = UIImageView(frame: CGRect(padding, padding, circle2.frame.height - (2 * padding), circle2.frame.height - (2 * padding)))
        imageView.image = image
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        circle2.addSubview(imageView)
    }
}
