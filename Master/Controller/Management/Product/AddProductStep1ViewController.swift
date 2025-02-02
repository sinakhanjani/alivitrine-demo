//
//  AddProductStep1ViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 1/23/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import PhotosUI
import CropViewController

class AddProductStep1ViewController: AppViewController,CropViewControllerDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

//    ====== IBOutlet ========
    @IBOutlet weak var categoryDropDown: DropDownTextField!
    @IBOutlet weak var subCategoryDropDown: DropDownTextField!
    @IBOutlet weak var productTitleTF: InsetTextField!
    @IBOutlet weak var countInBox: InsetTextField!
    @IBOutlet weak var priceLabel: InsetTextField!
    @IBOutlet weak var descriptionTF: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIdicator: UIActivityIndicatorView!
    
//    ===== vars =======
    let imagePicker = UIImagePickerController()
    var images : [UIImage] = []
    var categories : [CategoriesModel]?
    var product : ProductResponseModel?
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countInBox.keyboardType = .asciiCapableNumberPad
        if product != nil {
            bindToUpdate()
        }
    }
    
    func bindToUpdate () {
        productTitleTF.text = product?.product?.title
        countInBox.text = product?.product?.count_in_box
        priceLabel.text = product?.product?.price
        descriptionTF.text = product?.product?.description
        subCategoryDropDown.text = product?.category?.title
        subCategoryDropDown.default = product?.category?.id
        activityIdicator.isHidden = false
        addImagesToArray()
    }
    
    func bindCategoryParentInUpdateMode () {
        if product == nil {return}
        let categoryName = categories?.first(where: {$0.id == Int(product?.category?.parent_id ?? "0")})
        categoryDropDown.text = categoryName?.title
        categoryDropDown.default = categoryName?.id
    }
    
    override func fetchData(requestForReloading reloading: Bool) {
        super.fetchData(requestForReloading: reloading)
        let network = Network<ListResponseModel<CategoriesModel>>.init(url: Constant.Url.categoryList)
        handleRequestByUI(network.withPost(), success: { [weak self] response  in
            if let categories = response.data {
                self?.categories = categories
                self?.bindCategoryParentInUpdateMode()
                self?.configureCategoryDropDown()
            }
        })
    }
    
    func configureCategoryDropDown () {
        guard let cats = categories else {return}
        categoryDropDown.anchorDropDown(dataSource: cats.map {$0.title ?? ""}, keys: cats.map{$0.id ?? 0}, selectedRow: nil, handler: nil)
        categoryDropDown.setListener { [weak self] (index, text) in
            self?.subCategoryDropDown.text = ""
            self?.subCategoryDropDown.anchorDropDown(dataSource: self?.categories?[index].childs?.map{$0.title ?? ""} ?? [], keys: self?.categories?[index].childs?.map{$0.id ?? 0} ?? [], selectedRow: nil, handler: nil)
        }
    }
    
    @IBAction func continuBtnPressed(_ sender: Any) {
        guard self.productTitleTF.text!.count > 0 && self.countInBox.text!.count > 0  else {
            self.presentIOSAlertWarning(message: "انتخاب دسته بندی، زیردسته، نام محصول و تعداد در کارتن الزامی میباشد.", completion: {})
            return
        }
        guard let _ = subCategoryDropDown.getKeyOfSelectedOrDefault() as? Int else {
            self.presentIOSAlertWarning(message: "انتخاب دسته بندی، زیردسته، نام محصول و تعداد در کارتن الزامی میباشد.", completion: {})
            return
        }
        let files = Dictionary(uniqueKeysWithValues: images.enumerated().map { ("file\($0)", $1.jpegData(compressionQuality: 1)) })

        guard !files.isEmpty else {
            self.presentIOSAlertWarning(message: "انتخاب تصویر محصول الزامی میباشد", completion: {})
            return
        }
        sendData()
    }
    
    func sendData () {
        let files = Dictionary(uniqueKeysWithValues: images.enumerated().map { ("file\($0)", $1.jpegData(compressionQuality: 1)) })
        showLoading()
        var network = Network<AddProductStep1Response>
        .init(url: product != nil ? Constant.Url.updateProductStep1 : Constant.Url.addProductStep1)
        .addParameter(key: "title", value: productTitleTF.text)
        .addParameter(key: "category_id", value: subCategoryDropDown.getKeyOfSelectedOrDefault() as? Int)
        .addParameter(key: "box_count", value: countInBox.text?.toEngNumbers())
        .addParameter(key: "description", value: descriptionTF.text)
        .addParameter(key: "price", value: priceLabel.text?.toEngNumbers())
        if product != nil {
//            network.addParameter(key: "category_id", value: subCategoryDropDown.getKeyOfSelectedOrDefault() as? Int)
        }
        if product != nil {
            network = network.addParameter(key: "product_id", value: String(product?.product?.id ?? 0))
        }
//        print(Authentication.auth.token)
        print(priceLabel.text?.toEngNumbers(),product?.product?.id,countInBox.text?.toEngNumbers(),subCategoryDropDown.getKeyOfSelectedOrDefault(),Constant.Url.updateProductStep1)
        network.requestWithFiles(images: files,allFileNamed: "files[]", callback: {[weak self] (result) in
            print(result)
            self?.dismissLoading()
            result.ifSuccess { (response) in
                print(response)
                if response.result == "success" {
                    let vc =  AddProductStep2ViewController.create()
                    vc.productId = response.productId
                    vc.boxCount = self?.countInBox.text?.toEngNumbers()
                    vc.specifications = response.specifications
                    vc.isShoeCategory = (self?.categoryDropDown.getKeyOfSelectedOrDefault() as? Int) == 24
                    vc.title = self?.productTitleTF.text
                    vc.product = self?.product
                    guard let navigationController = self?.navigationController else { return }
                    var navigationArray = navigationController.viewControllers
                    navigationArray[navigationArray.count - 1] = vc
                    self?.navigationController?.viewControllers = navigationArray
                }
            }
        })
    }
    func addImagesToArray() {
        DispatchQueue.global(qos: .userInitiated).async {
            let downloadGroup = DispatchGroup()
            self.product?.product_images?.compactMap({$0.image}).forEach({ link in
                downloadGroup.enter()
                let url = URL(string: link)
                if let data = try? Data(contentsOf: url!) {
                    self.images.append(UIImage(data: data)!)
                }
                downloadGroup.leave()
            })
            downloadGroup.notify(queue: .main) {
                self.activityIdicator.isHidden = true
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
            }
            if downloadGroup.wait(timeout: .now()+14.00) == .timedOut {
             
            }
        }
    }
}
extension AddProductStep1ViewController : UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath)
            
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! CollectionViewCell
        cell.imageView1.image = images[indexPath.item - 1]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            openGallery()
        }
        else {
            presentIOSAlertWarningWithTwoButton(message: "آیا قصد حذف این عکس را دارید", buttonOneTitle: "بله", buttonTwoTitle: "خیر", handlerButtonOne: {[weak self] in
                self?.images.remove(at: indexPath.item - 1)
                self?.collectionView.deleteItems(at: [indexPath])
            }) {
                
            }
        }
    }
}

extension AddProductStep1ViewController {
    func openGallery () {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false

            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension AddProductStep1ViewController {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
             let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
             cropController.delegate = self
             // -- Uncomment these if you want to test out restoring to a previous crop setting --
             //cropController.angle = 90 // The initial angle in which the image will be rotated
            cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 1000, height: 800) //The initial frame that the crop controller will have visible.
             // -- Uncomment the following lines of code to test out the aspect ratio features --
             cropController.aspectRatioPreset = .presetOriginal; //Set the initial aspect ratio as a square
             cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be
             cropController.aspectRatioPickerButtonHidden = true
            cropController.rotateButtonsHidden = true
            cropController.rotateClockwiseButtonHidden = true
            cropController.toolbar.resetButtonHidden = true
            cropController.aspectRatioPickerButtonHidden = true
            //        cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
            cropController.resetAspectRatioEnabled = true // When tapping 'reset', the aspect ratio will NOT be reset back to default
             cropController.doneButtonTitle = "Done"
             cropController.cancelButtonTitle = "Cancel"
            cropController.toolbar.clampButtonHidden = true
             self.image = image
            //If profile picture, push onto the same navigation stack
             if croppingStyle == .circular {
                 if picker.sourceType == .camera {
                     picker.dismiss(animated: true, completion: {
                         self.present(cropController, animated: true, completion: nil)
                     })
                 } else {
                     picker.pushViewController(cropController, animated: true)
                 }
             }
             else { //otherwise dismiss, and then present from the main controller
                 picker.dismiss(animated: true, completion: {
                     self.present(cropController, animated: true, completion: nil)
                 })
             }
         }

        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            self.croppedRect = cropRect
            self.croppedAngle = angle
            updateImageViewWithImage(image, fromCropViewController: cropViewController)
        }
        
        public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
            self.images.append(image)
            self.collectionView.insertItems(at: [IndexPath(item: self.images.count, section: 0)])
            cropViewController.dismiss(animated: true, completion: nil)
        }
}
