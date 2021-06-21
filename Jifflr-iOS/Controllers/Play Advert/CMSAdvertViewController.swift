//
//  CMSAdvertViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import AVFoundation
import Player

class CMSAdvertViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleBackgroundView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var trianglesImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    
    var timer: Timer?
    var player: Player?

    var campaign: Campaign!
    var mode = 1
    var content:[(question: Question, answers: [Answer])] = []

    class func instantiateFromStoryboard(campaign: Campaign, mode: Int) -> CMSAdvertViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let advertViewController = storyboard.instantiateViewController(withIdentifier: "CMSAdvertViewController") as! CMSAdvertViewController
        advertViewController.campaign = campaign
        advertViewController.mode = mode
        
        if campaign.advert.details?.template?.key == AdvertTemplateKey.imageVideoLandscape {
            OrientationManager.shared.lock(orientation: .landscape, andRotateTo: .landscapeLeft)
        } else {
            OrientationManager.shared.lock(orientation: .portrait, andRotateTo: .portrait)
        }
        
        return advertViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupData()
    }

    func setupUI() {
        self.setupLocalization()
        self.setupConstraints()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.spinner.startAnimating()
        
        let dismissBarButton = UIBarButtonItem(image: UIImage(named: "NavigationDismiss"), style: .plain, target: self, action: #selector(self.dismissButtonPressed))
        self.navigationItem.leftBarButtonItem = dismissBarButton
        
        if self.mode == AdViewMode.normal {
            let flagBarButton = UIBarButtonItem(image: UIImage(named: "FlagAdButton"), style: .plain, target: self, action: #selector(self.flagButtonPressed(sender:)))
            self.navigationItem.rightBarButtonItem = flagBarButton
        }
        
        if self.mode == AdViewMode.preview {
            self.timeLabel.isHidden = true
            self.timeView.isHidden = true
        } else {
            self.timeLabel.isHidden = false
            self.timeView.isHidden = false
        }
    }
    
    func setupData() {
        self.titleLabel.text = self.campaign.advert.details?.title
        self.messageTextView.text = self.campaign.advert.details?.message
        
        if self.mode != AdViewMode.preview {
            self.fetchData()
        }
        
        self.spinner.stopAnimating()
        
        if let url = MediaManager.shared.get(id: self.campaign.advert.details?.objectId, fileExtension: "jpg") {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    let normalizedImage = self.fixOrientation(img: image)
                    self.imageView.image = normalizedImage
                    
                    if self.mode != AdViewMode.preview {
                        self.startTimer()
                    }
                }
            } catch {
                self.handleLoadError()
            }
            
            return
        }
        
        if let url = MediaManager.shared.get(id: self.campaign.advert.details?.objectId, fileExtension: "mp4") {
            self.player = Player()
            self.player?.playerDelegate = self
            self.player?.playbackDelegate = self
            self.player?.playbackLoops = false
            self.player?.autoplay = false
            self.player?.fillMode = PlayerFillMode.resizeAspectFit.avFoundationType
            self.player?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.addChildViewController(self.player!)
            self.view.addSubview(self.player!.view)
            self.player!.didMove(toParentViewController: self)
            
            self.player?.url = url
            self.player?.playFromBeginning()
            self.timeView.isHidden = true
        } else {
            self.handleLoadError()
        }
    }

    func setupLocalization() {
        if self.mode == AdViewMode.preview {
            self.title = "adPreview.navigation.title".localized()
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
    
    func fetchData() {
        var content:[(question: Question, answers: [Answer])] = []
        for question in self.campaign.advert.questions {
            content.append((question: question, answers: question.answers))
        }
        self.content = content
    }
    
    func startTimer() {
        DispatchQueue.main.async {
            var count = 30
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                count -= 1
                self.timeLabel.text = "\(count)"
                
                if count == 0 {
                    self.timer?.invalidate()
                    self.showFeedback()
                }
            })
        }
    }

    func showFeedback() {
        guard let question = self.content.first?.question else { return }

        OrientationManager.shared.lock(orientation: .portrait, andRotateTo: .portrait)
        
        var controller: UIViewController!
        
        switch question.type.type {
        case AdvertQuestionType.Binary:
            controller = BinaryFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: [], mode: self.mode)
        case AdvertQuestionType.DatePicker:
            controller = DateTimeFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: [], isTime: false, mode: self.mode)
        case AdvertQuestionType.MultipleChoice, AdvertQuestionType.Month, AdvertQuestionType.DayOfWeek:
            controller = MultiSelectFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: [], mode: self.mode)
        case AdvertQuestionType.NumberPicker:
            controller = NumberPickerFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: [], mode: self.mode)
        case AdvertQuestionType.Rating:
            controller = ScaleFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: [], mode: self.mode)
        case AdvertQuestionType.TimePicker:
            controller = DateTimeFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: [], isTime: true, mode: self.mode)
        case AdvertQuestionType.URLLinks:
            controller = URLFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: [], mode: self.mode)
        default:
            controller = BinaryFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: [], mode: self.mode)
        }
        self.player?.removeFromParentViewController()
        self.player?.view.removeFromSuperview()
        self.player?.url = nil
        self.player?.playbackDelegate = nil
        self.player = nil
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func dismissButtonPressed() {
        OrientationManager.shared.lock(orientation: .portrait, andRotateTo: .portrait)
        
        let animated = self.mode == AdViewMode.preview
        self.navigationController?.dismiss(animated: animated, completion: nil)
    }
    
    @objc func flagButtonPressed(sender: UIBarButtonItem) {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        
        ModerationManager.shared.fetchModeratorFeedbackCategories { (categories) in
            
            let flagBarButton = UIBarButtonItem(image: UIImage(named: "FlagAdButton"), style: .plain, target: self, action: #selector(self.flagButtonPressed(sender:)))
            self.navigationItem.rightBarButtonItem = flagBarButton
            
            let title = "alert.flagAd.title".localized()
            let message = "alert.flagAd.message".localized()
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelTitle = "alert.notifications.cancelButton".localized()
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in }
            alertController.addAction(cancelAction)
            
            for category in categories {
                let deleteAction = UIAlertAction(title: category.title, style: .default) { (action) in
                    AdvertManager.shared.flag(campaign: self.campaign, moderatorFeedbackCategory: category)
                    
                    let alert = AlertMessage.flagAdSuccess
                    self.displayMessage(title: alert.title, message: alert.message, dismissText: nil, dismissAction: { (action) in
                        self.dismissButtonPressed()
                    })
                }
                alertController.addAction(deleteAction)
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func handleLoadError() {
        let error = ErrorMessage.advertFetchFailed
        self.displayMessage(title: error.failureTitle, message: error.failureDescription, dismissText: nil, dismissAction: { (action) in
            self.dismissButtonPressed()
        })
    }
}

extension CMSAdvertViewController: PlayerPlaybackDelegate, PlayerDelegate {
    func playerReady(_ player: Player) {
        print("Ready to Play")
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        guard let navigationController = self.navigationController else { return }
        guard let viewController = navigationController.viewControllers.last else { return }
        
        if let _ = viewController as? FeedbackViewController, player.playbackState == .playing {
            player.stop()
            player.muted = true
        }
        
        if player.playbackState == .failed {
            print("Failed")
        }
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
        
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {

    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        guard let navigationController = self.navigationController else { return }
        guard let viewController = navigationController.viewControllers.last else { return }
        
        if let _ = viewController as? CMSAdvertViewController, self.mode != AdViewMode.preview {
            self.showFeedback()
        }
    }
}
