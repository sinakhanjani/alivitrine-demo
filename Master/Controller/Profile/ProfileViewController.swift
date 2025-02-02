//
//  ProfileViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/4/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
import CropViewController

class ProfileViewController: AppViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate, NotificationViewControllerDelegate,CropViewControllerDelegate {
    func notifDidChanged() {
        badgeLabel.text = "0"
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[0]
            tabItem.badgeValue = nil
        }
    }

//    ===== IBOuetlet ======
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var invitedFriendCountLabel: UILabel!
    @IBOutlet weak var subActivityLabel: UILabel!
    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var badgeLabel: UILabel!
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    var inviteMessage = ""
    
//    ===== Var =====
    let imagePicker = UIImagePickerController()
    var user : ProfileModel?
    var backFromEditProfile = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        backBarButtonAttribute(color: nil, name: "")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        invitedFriendCountLabel.text = String(describing: UserDefaults.standard.integer(forKey: "MyFriendCount"))
    }
    
    
    @IBAction func inviteBtnPressed(_ sender: Any) {
       shareWithComment(inviteMessage)
    }
    
    @IBAction func notificationBtnDidPressed(_ sender: Any) {
        let vc = NotificationViewController.create()
        vc.delegate = self
        vc.models = user?.notifications
        show(vc, sender: nil)
    }
    
    @IBAction func editAvatarDidTap(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false

            self.present(imagePicker, animated: true, completion: nil)
        }
//        self.openGallery()
    }
    
    override func fetchData(requestForReloading reloading: Bool) {
        super.fetchData(requestForReloading: reloading)
        let network = Network<ProfileModel>.init(url: Constant.Url.getUser)
        handleRequestByUI(network.withPost(), success: { [weak self] response in
            self?.user = response
            self?.bind()
        })
        
        let network2 = Network<SettingModel>.init(url: Constant.Url.setting)
        handleRequestByUI(network2.withPost(), success: { [weak self] res  in
            self?.inviteMessage = res.invite_message ?? ""
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if backFromEditProfile {
            backFromEditProfile = false
            self.fetchData(requestForReloading: true)
            bind()
        }
    }

    func bind () {
        guard let user = user else { return }
        if let imageStr = user.profile_photo, let url = URL(string: imageStr) {
            avatarView.imageView.af_setImage(withURL: url,placeholderImage: #imageLiteral(resourceName: "placeholder.pdf"))
        }
        else {
            avatarView.imageView.image = #imageLiteral(resourceName: "placeholder.pdf")
        }
        nameLabel.text = (user.first_name ?? "") + " " + (user.last_name ?? "")
        phoneNumberLabel.text = user.mobile
        cityLabel.text = user.city?.pname
        provinceLabel.text = user.state?.pname
        activityTitleLabel.text = user.main_category?.first?.title
        subActivityLabel.text = user.sub_categories?.first?.title
        self.badgeLabel.text = "\(user.notification_count ?? 0)"
        if (user.notification_count ?? 0) > 0 {
            if let tabItems = self.tabBarController?.tabBar.items {
                let tabItem = tabItems[0]
                tabItem.badgeValue = "\(user.notification_count ?? 0)"
            }
        }
    }
    
    @IBAction func managementPanelBtnPressed(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "loginAsManager") {
            let panel = ShopManagementViewController.create()
            navigationController?.pushViewController(panel, animated: true)
        }
        else {
            let vc = LoginManagerViewController.create()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        Authentication.auth.logOutAuth()
        //signoutTounwindLoader
//        self.performSegue(withIdentifier: "signoutTounwindLoader", sender: nil)
        self.view.window!.rootViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func supportButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://support.alivitrine.ir") {
            WebAPI.openURL(url: url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditProfileViewController {
            vc.user = user
            backFromEditProfile = true
        }
    }
}

extension ProfileViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
         let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
         cropController.delegate = self
         // -- Uncomment these if you want to test out restoring to a previous crop setting --
         //cropController.angle = 90 // The initial angle in which the image will be rotated
         cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 1000, height: 1000) //The initial frame that the crop controller will have visible.
         // -- Uncomment the following lines of code to test out the aspect ratio features --
         cropController.aspectRatioPreset = .presetOriginal; //Set the initial aspect ratio as a square
         cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be
         cropController.aspectRatioPickerButtonHidden = true
         cropController.doneButtonTitle = "Done"
         cropController.cancelButtonTitle = "Cancel"
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
        self.avatarView.imageView.image = image
        self.showLoading()
        Network<EditProfileResponseModel>
        .init(url: Constant.Url.editProfile)
        .addParameters(params: self.user?.toJSON())
            .requestWithFiles(images: ["profile":image.jpegData(compressionQuality: 0.4)],callback: { [weak self] (result) in
            result.ifSuccess { (response) in
                self?.presentIOSAlertWarning(message: "تصویر پروفایل با موفقیت تغییر کرد", completion: {})
                self?.dismissLoading()
            }
        })
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
