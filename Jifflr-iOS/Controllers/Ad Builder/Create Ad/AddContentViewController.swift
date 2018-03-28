//
//  AddContentViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 27/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse
import AVFoundation
import MobileCoreServices

class AddContentViewController: BaseViewController {
    
    @IBOutlet weak var titleTextField: JifflrTextField!
    @IBOutlet weak var messageTextView: JifflrTextView!
    @IBOutlet weak var imageOverlayView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var previewButton: JifflrButton!
    @IBOutlet weak var nextButton: JifflrButton!
    
    var advert: Advert!
    
    let imagePicker = UIImagePickerController()

    class func instantiateFromStoryboard(advert: Advert) -> AddContentViewController {
        let storyboard = UIStoryboard(name: "CreateAd", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddContentViewController") as! AddContentViewController
        vc.advert = advert
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        self.imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
        self.navigationController?.delegate = self
    }
    
    func setupUI() {
        self.setupLocalization()
        self.setupConstraints()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        
        self.nextButton.setBackgroundColor(color: UIColor.mainPink)
        self.previewButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
    }
    
    func setupLocalization() {
        self.title = "addContent.navigation.title".localized()
        self.nextButton.setTitle("createAd.nextButton.title".localized(), for: .normal)
        self.previewButton.setTitle("addContent.previewButton.title".localized(), for: .normal)
        self.titleTextField.placeholder = "addContent.titleTextField.placeholder".localized()
        self.messageTextView.placeholder = "addContent.messageTextView.placeholder".localized()
        self.imageButton.setTitle("addContent.imageButton.title".localized(), for: .normal)
        self.imageButton.setImage(UIImage(named: "AddImageButton"), for: .normal)
    }
    
    @IBAction func addImageButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "addContent.actionSheet.title".localized(), message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "addContent.takePhoto.title".localized(), style: .default) { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "addContent.library.title".localized(), style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(libraryAction)
        
        let dismissAction = UIAlertAction(title: "error.dismiss".localized(), style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func previewButtonPressed(sender: UIButton) {
        guard let template = self.advert.details?.template else { return }

        guard self.validateInput(key: template.key) else {
            self.displayError(error: ErrorMessage.addContent)
            return
        }
        
        let vc = CMSAdvertViewController.instantiateFromStoryboard(advert: self.advert, isPreview: true)
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        guard let template = self.advert.details?.template else { return }
        
        guard self.validateInput(key: template.key) else {
            self.displayError(error: ErrorMessage.addContent)
            return
        }
        
        // TODO: Push to next screen
    }
    
    func validateInput(key: String) -> Bool {
        
        switch key {
        case AdvertTemplateKey.imageVideoPortait:
            return self.validateImage()
        case AdvertTemplateKey.imageVideoLandscape:
            return self.validateImage()
        case AdvertTemplateKey.titleMessageImage:
            return self.validateTextAndImage()
        case AdvertTemplateKey.titleImageMessage:
            return self.validateTextAndImage()
        case AdvertTemplateKey.imageTitleMessage:
            return self.validateTextAndImage()
        default:
            return false
        }
    }
    
    func validateTextAndImage() -> Bool {
        guard let title = self.titleTextField.text, !title.isEmpty, self.titleTextField.textColor == UIColor.mainBlue else { return false }
        guard let message = self.messageTextView.text, !message.isEmpty, self.messageTextView.textColor == UIColor.mainBlue else { return false }
        guard self.advert.details?.image != nil else { return false }
        
        self.advert.details?.title = title
        self.advert.details?.message = message
        
        return true
    }
    
    func validateImage() -> Bool {
        guard self.advert.details?.image != nil else { return false }
        return true
    }
}

extension AddContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage, let data = UIImagePNGRepresentation(image) {
            self.imageOverlayView.contentMode = .scaleAspectFill
            self.imageOverlayView.image = image
            
            self.advert.details?.image = PFFile(data: data)
            
        } else if let videoUrl = info["UIImagePickerControllerMediaURL"] as? URL {
            do {
                let videoData = try Data(contentsOf: videoUrl)
                self.advert.details?.image = PFFile(data: videoData, contentType: "video/mp4")
                
                guard let thumbnail = self.getThumbnailFrom(path: videoUrl) else { return }
                self.imageOverlayView.contentMode = .scaleAspectFill
                self.imageOverlayView.image = thumbnail
            } catch let error {
                print(error)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let _ = viewController as? ChooseTemplateViewController {
            let newDetails = AdvertDetails()
            
            if let name = self.advert.details?.name {
                newDetails.name = name
            }
            
            if let template = self.advert.details?.template {
                newDetails.template = template
            }
            
            self.advert.details = newDetails
        }
    }
}
