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
    
    var timer: Timer?
    var player: Player?

    var advert: Advert!
    var isPreview = false
    var content:[(question: Question, answers: [Answer])] = []

    class func instantiateFromStoryboard(advert: Advert, isPreview: Bool) -> CMSAdvertViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let advertViewController = storyboard.instantiateViewController(withIdentifier: "CMSAdvertViewController") as! CMSAdvertViewController
        advertViewController.advert = advert
        advertViewController.isPreview = isPreview
        
        if advert.details?.template.key == AdvertTemplateKey.imageVideoLandscape {
            OrientationManager.shared.set(orientation: .landscape)
        } else {
            OrientationManager.shared.set(orientation: .portrait)
        }
        
        return advertViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupData()
        
        if !self.isPreview {
            self.fetchData()
        }
    }

    func setupUI() {
        self.setupLocalization()
        self.setupConstraints()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.spinner.startAnimating()
        
        if self.isPreview {
            let dismissBarButton = UIBarButtonItem(image: UIImage(named: "NavigationDismiss"), style: .plain, target: self, action: #selector(self.dismissButtonPressed(sender:)))
            self.navigationItem.leftBarButtonItem = dismissBarButton
        } else {
            let flagBarButton = UIBarButtonItem(image: UIImage(named: "FlagAdButton"), style: .plain, target: self, action: #selector(self.flagButtonPressed(sender:)))
            self.navigationItem.rightBarButtonItem = flagBarButton
        }
    }
    
    func setupData() {
        self.titleLabel.text = self.advert.details?.title
        self.messageTextView.text = self.advert.details?.message
        
        self.spinner.stopAnimating()
        
        if let url = MediaManager.shared.get(id: self.advert.details?.objectId, fileExtension: "jpg") {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    self.imageView.image = image
                    
                    if !self.isPreview {
                        self.startTimer()
                    }
                }
            } catch {
                self.handleLoadError()
            }
            
            return
        }
        
        if let url = MediaManager.shared.get(id: self.advert.details?.objectId, fileExtension: "mp4") {
            self.player = Player()
            self.player?.playerDelegate = self
            self.player?.playbackDelegate = self
            self.player?.fillMode = PlayerFillMode.resizeAspectFill.avFoundationType
            self.player?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.addChildViewController(self.player!)
            self.view.addSubview(self.player!.view)
            self.player!.didMove(toParentViewController: self)
            
            self.player?.url = url
            self.player?.playFromBeginning()
        } else {
            self.handleLoadError()
        }
    }

    func setupLocalization() {
        if self.isPreview {
            self.title = "adPreview.navigation.title".localized()
        }
    }
    
    func fetchData() {
        AdvertManager.shared.fetchLocalQuestionsAndAnswers(advert: self.advert) { (content) in
            self.spinner.stopAnimating()
            guard content.count > 0 else {
                if !self.isPreview { self.handleLoadError() }
                return
            }
            self.content = content
        }
    }
    
    func startTimer() {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false, block: { (timer) in
                self.showFeedback()
            })
        }
    }

    func showFeedback() {
        guard let question = self.content.first?.question else { return }
        
        var controller: UIViewController!
        
        switch question.type.type {
        case AdvertQuestionType.Binary:
            controller = BinaryFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [], isPreview: false)
        case AdvertQuestionType.DatePicker:
            controller = DateTimeFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [], isTime: false, isPreview: false)
        case AdvertQuestionType.MultipleChoice, AdvertQuestionType.Month, AdvertQuestionType.DayOfWeek:
            controller = MultiSelectFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [], isPreview: false)
        case AdvertQuestionType.NumberPicker:
            controller = NumberPickerFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [], isPreview: false)
        case AdvertQuestionType.Rating:
            controller = ScaleFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [], isPreview: false)
        case AdvertQuestionType.TimePicker:
            controller = DateTimeFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [], isTime: true, isPreview: false)
        case AdvertQuestionType.URLLinks:
            controller = URLFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [], isPreview: false)
        default:
            controller = BinaryFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [], isPreview: false)
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func dismissButtonPressed(sender: UIBarButtonItem) {
        OrientationManager.shared.set(orientation: .portrait)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func flagButtonPressed(sender: UIBarButtonItem) {
        AdvertManager.shared.flag(advert: self.advert.objectId!) { (error) in
            if let error = error {
                self.displayError(error: error)
            }
        }
    }
    
    func handleLoadError() {
        let error = ErrorMessage.advertFetchFailed
        self.displayMessage(title: error.failureTitle, message: error.failureTitle, dismissText: nil, dismissAction: { (action) in
            self.dismissButtonPressed(sender: self.navigationItem.leftBarButtonItem!)
        })
    }
}

extension CMSAdvertViewController: PlayerPlaybackDelegate, PlayerDelegate {
    func playerReady(_ player: Player) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
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
        if self.isPreview {
            self.player?.playFromBeginning()
        } else {
            self.showFeedback()
        }
    }
}
