//
//  ImageSlider.swift
//  Master
//
//  Created by Mohammad Fallah on 11/11/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import Foundation
import UIKit

protocol ViewPagerClickDelegate {
    func didSelectImage (at index: Int)
}

@IBDesignable
class ImageSlider: ViewPager, ViewPagerDataSource {

    var clickDelegate : ViewPagerClickDelegate?
    @IBInspectable
    var placeholder : UIImage? {
        didSet{
            reloadData()
        }
    }
    
    var urls: [String]?
    
    required  public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    var images : [String?]? {
        didSet {
            reloadData()
        }
    }
    
    override func setupView() {
        super.setupView()
        dataSource = self
        pageControl.hidesForSinglePage = true
    }
    
    
    func numberOfItems(viewPager: ViewPager) -> Int {
        return images?.count ?? 0 > 0 ? (images?.count ?? 0) : placeholder != nil ? 1 : 0
    }
    
    func viewAtIndex(viewPager: ViewPager, index: Int, view: UIView?) -> UIView {
        var imageView = view
        imageView = UIImageView(frame: viewPager.frame)
        imageView?.contentMode = .scaleAspectFill
        imageView?.clipsToBounds = true
        imageView?.layer.masksToBounds = true
        imageView?.contentMode = .scaleAspectFit
        if images?.count ?? 0 > 0 {
            (imageView as! UIImageView).image = #imageLiteral(resourceName: "placeholder")
            if let img = images?[index] , let url = URL(string: (img)) {
                (imageView as! UIImageView).af_setImage(withURL: url,placeholderImage :#imageLiteral(resourceName: "placeholder"))
            }
            else {(imageView as! UIImageView).image = #imageLiteral(resourceName: "placeholder")}
            (imageView as! UIImageView).backgroundColor = UIColor.white
            
        }
        else {
            (imageView as! UIImageView).image = placeholder
        }
        return imageView!
    }
    
    func didSelectedItem(index: Int) {
        if let urls = self.urls {
            if let url = URL(string: urls[index]) {
                WebAPI.openURL(url: url)
            }
        }
        clickDelegate?.didSelectImage(at: index)
    }

}
