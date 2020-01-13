//
//  SwipeFeedbackViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 06/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class SwipeFeedbackViewController: FeedbackViewController {

    @IBOutlet weak var swipeAnimationImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var imageLoadCount = 0
    var question: AdExchangeQuestion!
    var userSeenAdExchange = UserSeenAdExchange()

    class func instantiateFromStoryboard(campaign: Campaign, question: AdExchangeQuestion) -> SwipeFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SwipeFeedbackViewController") as! SwipeFeedbackViewController
        controller.campaign = campaign
        controller.question = question
        
        OrientationManager.shared.lock(orientation: .portrait, andRotateTo: .portrait)
        
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.animateSwipeImageView()
    }

    override func setupUI() {
        super.setupUI()

        self.nextAdButton.isEnabled = false
        self.nextAdButton.isHidden = true

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsMultipleSelection = false
        self.tableView.isMultipleTouchEnabled = false
        self.tableView.isUserInteractionEnabled = false
        
        if let vc = UIApplication.shared.keyWindow?.topMostWindowController() {
            if let alert = vc as? UIAlertController {
                alert.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    override func setupQuestionText() {
        if let questionText = self.question?.question {
            self.questionLabel.text = questionText
        }
    }

    func animateSwipeImageView() {

        CATransaction.begin()
        CATransaction.setCompletionBlock({
            
        })

        let animation = CABasicAnimation(keyPath: "position.x")
        animation.duration = 0.2
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = self.swipeAnimationImageView.center.x
        animation.toValue = self.swipeAnimationImageView.center.x + 10.0
        self.swipeAnimationImageView.layer.add(animation, forKey: "position.x")

        CATransaction.commit()
    }

    func handleAnswer(yes: Bool, row: Int) {
        if self.userSeenAdExchange.response1 == nil {
            self.userSeenAdExchange.response1 = yes
        } else if self.userSeenAdExchange.response2 == nil {
            self.userSeenAdExchange.response2 = yes
        } else if self.userSeenAdExchange.response3 == nil {
            self.userSeenAdExchange.response3 = yes
        }
    }

    func saveAndPushToNextAd() {
        if self.tableView.numberOfRows(inSection: 0) == 0 {
            guard let user = Session.shared.currentUser else { return }
            guard let location = Session.shared.currentLocation else { return }
            
            self.userSeenAdExchange.user = user
            self.userSeenAdExchange.location = location
            self.userSeenAdExchange.question = self.question
            self.userSeenAdExchange.questionNumber = self.question.questionNumber
            
            if let currentCoordinate = Session.shared.currentCoordinate {
                self.userSeenAdExchange.geoPoint = PFGeoPoint(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
            }
            
            self.userSeenAdExchange.saveEventually { (success, error) in
                print("Saved Swipe Feedback: \(success)")
            }

            self.pushToNextAd()
        }
    }
    
    override func skipButtonPressed(sender: UIBarButtonItem) {
        let title = "feedback.dismissSwipeAlert.title".localized()
        let message = "feedback.dismissSwipeAlert.message".localized()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelTitle = "alert.notifications.cancelButton".localized()
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let okayTitle = "alert.passwordChanged.okayButton".localized()
        let okayAction = UIAlertAction(title: okayTitle, style: .default) { (action) in
            self.pushToNextAd()
        }
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func dismissButtonPressed(sender: UIBarButtonItem) {
        let title = "feedback.dismissSwipeAlert.title".localized()
        let message = "feedback.dismissSwipeAlert.message".localized()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelTitle = "alert.notifications.cancelButton".localized()
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let okayTitle = "alert.passwordChanged.okayButton".localized()
        let okayAction = UIAlertAction(title: okayTitle, style: .default) { (action) in
            self.dismiss(animated: false, completion: nil)
        }
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SwipeFeedbackViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if self.userSeenAdExchange.response1 == nil { count += 1 }
        if self.userSeenAdExchange.response2 == nil { count += 1 }
        if self.userSeenAdExchange.response3 == nil { count += 1 }
        
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeCell", for: indexPath) as! SwipeCell
        cell.tag = indexPath.row + 1000
        cell.delegate = self
        cell.question = self.question
        cell.contentView.isExclusiveTouch = true
        cell.isExclusiveTouch = true
        
        if cell.questionImageView.image == nil {
            var imageFile = self.question?.image1
            if indexPath.row == 1 { imageFile = self.question?.image2 }
            if indexPath.row == 2 { imageFile = self.question?.image3 }

            if let imageFile = imageFile {
                imageFile.getDataInBackground(block: { (data, error) in
                    if let data = data, error == nil {
                        cell.questionImageView.image = UIImage(data: data)
                        
                        self.imageLoadCount += 1
                        if self.imageLoadCount == self.tableView.numberOfRows(inSection: 0) {
                            self.tableView.isUserInteractionEnabled = true
                        }
                    }
                })
            }
        }

        return cell
    }
}

extension SwipeFeedbackViewController: SwipeCellDelegate {
    func cellSwiped(yes: Bool, row: Int) {
        self.handleAnswer(yes: yes, row: row)
        
        guard let cell = self.tableView.viewWithTag(row) as? SwipeCell else { return }
        guard let index = self.tableView.indexPath(for: cell) else { return }
        
        CATransaction.begin()
        self.tableView.beginUpdates()
        CATransaction.setCompletionBlock {
            self.tableView.isUserInteractionEnabled = true
        }
        self.tableView.isUserInteractionEnabled = false
        self.tableView.deleteRows(at: [index], with: .fade)
        self.tableView.endUpdates()
        CATransaction.commit()
        
        self.saveAndPushToNextAd()
    }
}
