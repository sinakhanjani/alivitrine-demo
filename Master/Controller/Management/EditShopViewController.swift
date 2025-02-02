//
//  EditShopViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
//import ALCameraViewController


class EditShopViewController: AppViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var tel1TF: UITextField!
    @IBOutlet weak var tel2TF: UITextField!
    @IBOutlet weak var descriptionTF: UITextView!
    @IBOutlet weak var logoImage: CircleImageView!
    @IBOutlet weak var telegramTF: UITextField!
    @IBOutlet weak var whatsappTF: UITextField!

//    ===== Var =====
    let imagePicker = UIImagePickerController()
    var model : BrandModel?
    var logoDidChanged = false
    
//    var minimumSize: CGSize = CGSize(width: 200, height: 200)
//
//    var croppingParameters: CroppingParameters {
//        return CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: minimumSize)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        telegramTF.delegate = self
        whatsappTF.delegate = self
        tel1TF.keyboardType = .asciiCapableNumberPad
        tel2TF.keyboardType = .asciiCapableNumberPad
        self.logoImage.contentMode = .scaleAspectFit
        backBarButtonAttribute(color: nil, name: "")
        bind()
    }
    
    func removeDuplicates(text: String) -> String {
      let words = text.components(separatedBy: " ")
      let filtered = words.filter { $0.first == "@" }
      return Array(Set(filtered)).joined()
    }
    
    @IBAction func textFieldDidChangend(_ sender: UITextField) {
        if sender == telegramTF || sender == whatsappTF {
            if sender.text! == sender.placeholder! {
                sender.text = ""
                return
            }
            let txt = sender.text!.replacingOccurrences(of: sender.placeholder!, with: "")
            sender.text = ""
            sender.text = ("\(sender.placeholder ?? "")"+"\(txt)").trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    
    @IBAction func imageSelectBtnPressed(_ sender: Any) {
//        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
//            imagePicker.delegate = self
//            imagePicker.sourceType = .savedPhotosAlbum;
//            imagePicker.allowsEditing = false
//
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//        self.openGallery()
    }
    
    func bind () {
        addressTF.text = model?.address
        tel1TF.text = "\((model?.tel1 ?? 0))"
        tel2TF.text = model?.tel2
        descriptionTF.text = model?.description
        if let imageStr = model?.image, let url = URL(string: imageStr) {
            logoImage.af_setImage(withURL: url,placeholderImage: #imageLiteral(resourceName: "placeholder.pdf"))
        }
        else {
            logoImage.image = #imageLiteral(resourceName: "placeholder.pdf")
        }
        print(model?.telegram_contact,model?.whatsapp_contact)
        self.whatsappTF.text = model?.whatsapp_contact
        self.telegramTF.text = model?.telegram_contact
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        update()
    }
    func update () {
        if logoDidChanged {
           updateWithImage()
        }
        else {
          updateWithoutImage()
        }
    }
    
    func updateWithImage () {
        showLoading()
        Network<BrandResponseModel>
        .init(url: Constant.Url.editShop)
        .addParameter(key: "address", value: addressTF.text)
        .addParameter(key: "tel1", value: tel1TF.text)
        .addParameter(key: "tel2", value: tel2TF.text)
        .addParameter(key: "telegram_contact", value: telegramTF.text!)
        .addParameter(key: "whatsapp_contact", value: whatsappTF.text!)
        .addParameter(key: "description", value: descriptionTF.text)
            .requestWithFiles(images: ["image":logoImage.image!.jpegData(compressionQuality: 1)],callback: { [weak self] (result) in
            result.ifSuccess { (response) in
                self?.dismissLoading()
                self?.updateModel(image: response.shop?.image)
                self?.presentIOSAlertWarning(message: "اطلاعات با موفقیت تغییر یافت", completion: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        })
    }
    func updateWithoutImage () {
        showLoading()
        Network<BrandResponseModel>
        .init(url: Constant.Url.editShop)
        .addParameter(key: "address", value: addressTF.text)
        .addParameter(key: "tel1", value: tel1TF.text)
        .addParameter(key: "tel2", value: tel2TF.text)
        .addParameter(key: "telegram_contact", value: telegramTF.text!)
        .addParameter(key: "whatsapp_contact", value: whatsappTF.text!)
        .addParameter(key: "description", value: descriptionTF.text)
        .post(callback: { [weak self] (result) in
            self?.dismissLoading()
            result.ifSuccess { (response) in
                self?.updateModel(image: response.shop?.image)
                self?.presentIOSAlertWarning(message: "اطلاعات با موفقیت تغییر یافت", completion: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        })
    }
    func updateModel (image : String?) {
        model?.address = addressTF.text
        model?.tel1 = Int(tel1TF.text ?? "0") ?? 0
        model?.tel2 = tel2TF.text
        model?.description = descriptionTF.text
        model?.image = image ?? model?.image
        self.model?.telegram_contact = self.telegramTF.text
        self.model?.whatsapp_contact = self.whatsappTF.text
    }
}

//extension EditShopViewController {
//    @objc func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//          self.dismiss(animated: true, completion: { () -> Void in
//
//          })
//        logoImage.image = image
//        logoDidChanged = true
//    }
//}

extension EditShopViewController {
//   func openCamera() {
//        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true) { [weak self] image, asset in
////            self?.imageView.image = image
//            self?.dismiss(animated: true, completion: nil)
//        }
//
//        present(cameraViewController, animated: true, completion: nil)
//    }
//
//    func openGallery() {
//        let libraryViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] image, asset in
//            if let image = image {
//                self?.logoImage.image = image
//            }
//            self?.dismiss(animated: true, completion: nil)
//        }
//
//        present(libraryViewController, animated: true, completion: nil)
//    }
}
