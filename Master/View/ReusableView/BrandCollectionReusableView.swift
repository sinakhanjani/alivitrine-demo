//
//  BrandCollectionReusableView.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
protocol BrandCollectionReusableViewDelegate : class {
    func shareBtnDidTap (_ link: String)
    func bookmarkBtnDidTap ()
    func telButtonTapped(_ tel: String)
    func phoneButtonTapped(_ phone: String)
    func telegramButtonTapped(_ phone: String)
    func whatsappButtonTapped(_ phone: String)
    func logoutButtonTapped()
}
class BrandCollectionReusableView: UICollectionReusableView {
    
//    === vars ===
    weak var delegate : BrandCollectionReusableViewDelegate?
    
//    ==== outlet ====
    @IBOutlet weak var logoImage: CircleImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var telephoneNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var locationImageView: UIImageView!
    
    var brand: BrandModel?
    
    func bind (_ brand : BrandModel?) {
//        self.locationImageView.alpha = 0.0
        guard let myBrand = brand else {return}
        
        self.brand = myBrand
        if let imageStr = myBrand.image, let url = URL(string: imageStr) {
            logoImage.af_setImage(withURL: url,placeholderImage: #imageLiteral(resourceName: "placeholder.pdf"))
        }
        else {
            logoImage.image = #imageLiteral(resourceName: "placeholder.pdf")
        }
        nameLabel.text = myBrand.title
        descriptionLabel.text = myBrand.description
        addressLabel.text = myBrand.address
        if let address = myBrand.address, address.count > 0 {
            
        } else {
//            self.locationImageView.alpha = 0.0
        }
        phoneNumberLabel.text = "\((myBrand.tel1 ?? 0))"
        telephoneNumberLabel.text = myBrand.tel2
    }
    @IBAction func shareBtnPressed(_ sender: Any) {
        delegate?.shareBtnDidTap(brand?.share_link ?? "")
    }
    @IBAction func bookmarkBtnPressed(_ sender: Any) {
         delegate?.bookmarkBtnDidTap()
    }
    
    @IBAction func telButtonTapped() {
        delegate?.telButtonTapped(brand?.tel2 ?? "")
    }
    
    @IBAction func mobileButtonTapped() {
        delegate?.phoneButtonTapped("\((brand?.tel1 ?? 0))")
    }
    
    @IBAction func telegramButtonTapped() {
        delegate?.telegramButtonTapped(brand?.telegram_contact ?? "")
    }
    
    @IBAction func whatsappButtonTapped() {
        delegate?.whatsappButtonTapped(brand?.whatsapp_contact ?? "")
    }
    
    @IBAction func logoutButtonTapped() {
        delegate?.logoutButtonTapped()
    }
    
    func switchBookMarkBtn(bookmarked : Int) {
        if bookmarked == 0 {
            bookmarkBtn.setImage(#imageLiteral(resourceName: "ic_bookmark"), for: .normal)
        }
        else {
            bookmarkBtn.setImage(#imageLiteral(resourceName: "ic_bookmark_fill_1"), for: .normal)
        }
    }
    
}
