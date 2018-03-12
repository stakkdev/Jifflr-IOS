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

    class func instantiateFromStoryboard(advert: Advert, questions: [Question], answers: [Answer]) -> SwipeFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SwipeFeedbackViewController") as! SwipeFeedbackViewController
        controller.advert = advert
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

        if let firstQuestion = self.questions.first {
            self.questionLabel.text = firstQuestion.text
        }

        self.tableView.delegate = self
        self.tableView.dataSource = self
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

    func createQuestionAnswers(yes: Bool, question: Question) {
        guard self.answers.count == 2 else { return }
        let answer = yes == true ? self.answers.last! : self.answers.first!
        let questionAnswer = FeedbackManager.shared.createQuestionAnswers(question: question, answers: [answer])
        self.questionAnswers.append(questionAnswer)
    }

    func saveAndPushToNextAd() {
        if self.questions.count == 0 {
            FeedbackManager.shared.saveFeedback(advert: self.advert, questionAnswers: self.questionAnswers, completion: {
                self.pushToNextAd()
            })
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
    func cellSwiped(yes: Bool, question: Question) {
        if let index = self.questions.index(of: question) {
            let cellIndexPath = IndexPath(row: index, section: 0)
            self.questions.remove(at: index)
            self.tableView.deleteRows(at: [cellIndexPath as IndexPath], with: .fade)

            self.createQuestionAnswers(yes: yes, question: question)
            self.saveAndPushToNextAd()
        }
    }
}
