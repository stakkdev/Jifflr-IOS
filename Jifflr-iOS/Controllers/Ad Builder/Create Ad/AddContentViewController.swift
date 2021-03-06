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
    var content:[(question: Question, answers: [Answer])] = []
    
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
        self.setupData()
        
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
    
    func setupData() {
        self.fetchQuestionsAndAnswers()
        
        if let title = self.advert.details?.title {
            self.titleTextField.text = title
        }
        
        if let message = self.advert.details?.message {
            self.messageTextView.text = message
            self.messageTextView.textColor = UIColor.mainBlue
        }
        
        if let url = MediaManager.shared.get(id: self.advert.details?.objectId, fileExtension: "jpg") {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    self.imageOverlayView.image = image
                }
            } catch {
                
            }
            return
        }
        
        if let url = MediaManager.shared.get(id: self.advert.details?.objectId, fileExtension: "mp4") {
            guard let thumbnail = self.getThumbnailFrom(path: url) else {
                return
            }
            
            self.imageOverlayView.contentMode = .scaleAspectFill
            self.imageOverlayView.image = thumbnail
        }
    }
    
    func fetchQuestionsAndAnswers() {
        var content:[(question: Question, answers: [Answer])] = []
        for question in self.advert.questions {
            content.append((question: question, answers: question.answers))
        }
        self.content = content
    }
    
    @IBAction func addImageButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "addContent.actionSheet.title".localized(), message: nil, preferredStyle: .actionSheet)
        
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
        
        let campaign = Campaign()
        campaign.advert = self.advert
        let vc = CMSAdvertViewController.instantiateFromStoryboard(campaign: campaign, mode: AdViewMode.preview)
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
        
        let vc = AddQuestionsViewController.instantiateFromStoryboard(advert: self.advert, questionNumber: 1, content: self.content)
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage, let data = UIImageJPEGRepresentation(image, 1.0) {
            guard MediaManager.shared.save(data: data, id: self.advert.details?.objectId, fileExtension: "jpg") else {
                self.dismiss(animated: true) {
                    self.displayError(error: ErrorMessage.mediaSaveFailed)
                }
                
                return
            }
            
            let normalizedImage = self.fixOrientation(img: image)
            self.imageOverlayView.contentMode = .scaleAspectFill
            self.imageOverlayView.image = normalizedImage
            
            let randomName = UUID().uuidString
            if let file = try? PFFileObject(name: "\(randomName).jpg", data: data, contentType: "image/jpg") {
                self.advert.details?.image = file
            } else {
                self.advert.details?.image = PFFileObject(data: data, contentType: "image/jpg")
            }
        } else if let videoUrl = info["UIImagePickerControllerMediaURL"] as? URL {
            let asset = AVAsset(url: videoUrl)
            
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            guard durationTime <= 30.0 else {
                self.dismiss(animated: true) {
                    self.displayError(error: ErrorMessage.videoTooLong)
                }
                
                return
            }
            
            let preset = AVAssetExportPresetHighestQuality
            let outFileType = AVFileType.mp4
            
            guard let export = AVAssetExportSession(asset: asset, presetName: preset) else { return }
            export.outputFileType = outFileType
            export.shouldOptimizeForNetworkUse = true
            let newUrl = FileManager.default.temporaryDirectory.appendingPathComponent("temp.mp4")
            
            do {
                if FileManager.default.fileExists(atPath: newUrl.path) {
                    try FileManager.default.removeItem(at: newUrl)
                }
            } catch let error {
                print(error)
            }
            
            export.outputURL = newUrl
            
            export.exportAsynchronously { () -> Void in
                do {
                    let videoData = try Data(contentsOf: newUrl)
                    
                    let randomName = UUID().uuidString
                    if let file = try? PFFileObject(name: "\(randomName).mp4", data: videoData, contentType: "video/mp4") {
                        self.advert.details?.image = file
                    } else {
                        self.advert.details?.image = PFFileObject(data: videoData, contentType: "video/mp4")
                    }
                    
                    guard MediaManager.shared.save(data: videoData, id: self.advert.details?.objectId, fileExtension: "mp4") else {
                        self.displayError(error: ErrorMessage.mediaSaveFailed)
                        return
                    }
                    
                    guard let thumbnail = self.getThumbnailFrom(path: videoUrl) else {
                        self.displayError(error: ErrorMessage.mediaSaveFailed)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.imageOverlayView.contentMode = .scaleAspectFill
                        self.imageOverlayView.image = thumbnail
                    }
                } catch let error {
                    print(error)
                }
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
    
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}
