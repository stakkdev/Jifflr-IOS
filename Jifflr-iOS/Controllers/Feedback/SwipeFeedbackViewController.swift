//
//  SwipeFeedbackViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 06/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class SwipeFeedbackViewController: FeedbackViewController {

    @IBOutlet weak var swipeAnimationImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var questions: [AdExchangeQuestion] = []
    var answers: [Answer] = []
    var userSeenAdExchange = UserSeenAdExchange()

    class func instantiateFromStoryboard(campaign: Campaign, questions: [AdExchangeQuestion], answers: [Answer]) -> SwipeFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SwipeFeedbackViewController") as! SwipeFeedbackViewController
        controller.campaign = campaign
        controller.questions = questions
        controller.answers = answers
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.animateSwipeImageView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let inset = (self.tableView.frame.height - self.tableView.contentSize.height) / 2.0
        let topInset = max(inset, 0.0)
        self.tableView.contentInset.top = topInset
    }

    override func setupUI() {
        super.setupUI()

        self.nextAdButton.isEnabled = false
        self.nextAdButton.isHidden = true

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func setupQuestionText() {
        if let firstQuestion = self.questions.first {
            self.questionLabel.text = firstQuestion.text
        }
    }

    func animateSwipeImageView() {

        CATransaction.begin()
        CATransaction.setCompletionBlock({
            UIView.animate(withDuration: 1.0, delay: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.swipeAnimationImageView.alpha = 0.0
            }, completion: { (completion) -> Void in
                if completion == true {
                    self.swipeAnimationImageView.isHidden = true
                    self.swipeAnimationImageView.alpha = 1.0
                }
            })
        })

        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.2
        animation.repeatCount = 8
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.swipeAnimationImageView.center.x, y: self.swipeAnimationImageView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.swipeAnimationImageView.center.x + 10.0, y: self.swipeAnimationImageView.center.y))
        self.swipeAnimationImageView.layer.add(animation, forKey: "position")

        CATransaction.commit()
    }

    func createQuestionAnswers(yes: Bool, question: AdExchangeQuestion) {
        guard let user = Session.shared.currentUser else { return }
        guard self.answers.count == 2 else { return }
        let answer = yes == true ? self.answers.last! : self.answers.first!
        
        if self.userSeenAdExchange.question1 == nil {
            self.userSeenAdExchange.question1 = question
            self.userSeenAdExchange.response1 = answer
            user.details.lastExchangeQuestion = question
        } else if self.userSeenAdExchange.question2 == nil {
            self.userSeenAdExchange.question2 = question
            self.userSeenAdExchange.response2 = answer
            user.details.lastExchangeQuestion = question
        } else if self.userSeenAdExchange.question3 == nil {
            self.userSeenAdExchange.question3 = question
            self.userSeenAdExchange.response3 = answer
            user.details.lastExchangeQuestion = question
        }
    }

    func saveAndPushToNextAd() {
        if self.questions.count == 0 {
            guard let user = Session.shared.currentUser else { return }
            self.userSeenAdExchange.user = user
            self.userSeenAdExchange.saveEventually { (success, error) in
                print("Saved Swipe Feedback: \(success)")
            }
            
            user.saveEventually { (success, error) in
                print("User Updated")
            }
            
            self.pushToNextAd()
        }
    }
}

extension SwipeFeedbackViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeCell", for: indexPath) as! SwipeCell
        cell.tag = indexPath.row
        cell.delegate = self
        cell.question = self.questions[indexPath.row]

        if let imageFile = self.questions[indexPath.row].image {
            imageFile.getDataInBackground(block: { (data, error) in
                if let data = data, error == nil {
                    cell.questionImageView.image = UIImage(data: data)
                }
            })
        }

        return cell
    }
}

extension SwipeFeedbackViewController: SwipeCellDelegate {
    func cellSwiped(yes: Bool, question: AdExchangeQuestion) {
        if let index = self.questions.index(of: question) {
            let cellIndexPath = IndexPath(row: index, section: 0)
            self.questions.remove(at: index)
            self.tableView.deleteRows(at: [cellIndexPath as IndexPath], with: .fade)
            
            if let question = self.questions.first {
                self.questionLabel.text = question.text
            }

            self.createQuestionAnswers(yes: yes, question: question)
            self.saveAndPushToNextAd()
        }
    }
}
