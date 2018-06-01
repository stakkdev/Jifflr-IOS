//
//  QAFeedbackViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class MultiSelectFeedbackViewController: FeedbackViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndexPaths: [IndexPath] = []

    class func instantiateFromStoryboard(campaign: Campaign, content: [(question: Question, answers: [Answer])], questionAnswers: [QuestionAnswers], mode: Int) -> MultiSelectFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MultiSelectFeedbackViewController") as! MultiSelectFeedbackViewController
        controller.campaign = campaign
        controller.content = content
        controller.questionAnswers = questionAnswers
        controller.mode = mode
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let inset = (self.collectionView.frame.height - self.collectionView.contentSize.height) / 2.0
        let topInset = max(inset, 0.0)
        self.collectionView.contentInset.top = topInset
    }

    override func validateAnswers() -> Bool {
        guard self.selectedIndexPaths.count > 0 else { return false }
        
        if let noOfRequiredAnswers = self.content.first?.question.noOfRequiredAnswers {
            if self.selectedIndexPaths.count != noOfRequiredAnswers {
                return false
            }
        }
        
        self.createQuestionAnswers(indexPaths: self.selectedIndexPaths)
        return true
    }
    
    func createQuestionAnswers(indexPaths: [IndexPath]) {
        guard let question = self.content.first?.question else { return }
        guard let answers = self.content.first?.answers else { return }
        
        var chosenAnswers:[Answer] = []
        for indexPath in indexPaths {
            let answer = answers[indexPath.row]
            chosenAnswers.append(answer)
        }
        
        let questionAnswer = FeedbackManager.shared.createQuestionAnswers(question: question, answers: chosenAnswers)
        self.questionAnswers.append(questionAnswer)
    }
}

extension MultiSelectFeedbackViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let firstContent = self.content.first else { return 0 }
        
        return firstContent.answers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiSelectCell", for: indexPath) as! MultiSelectCell
        
        if let answers = self.content.first?.answers {
            cell.titleLabel.text = answers[indexPath.row].text
        }

        if self.shouldUseTwoColumns() {
            if indexPath.row % 2 == 0 {
                cell.roundedViewLeading.constant = 18.0
                cell.roundedViewTrailing.constant = 9.0
            } else {
                cell.roundedViewLeading.constant = 9.0
                cell.roundedViewTrailing.constant = 18.0
            }
        } else {
            cell.roundedViewLeading.constant = 18.0
            cell.roundedViewTrailing.constant = 18.0
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width

        if self.shouldUseTwoColumns() {
            width = UIScreen.main.bounds.width / 2.0
        }

        return CGSize(width: width, height: 50.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noOfRequiredAnswers = self.content.first?.question.noOfRequiredAnswers
        
        if let noOfRequiredAnswers = noOfRequiredAnswers, noOfRequiredAnswers == 1 {
            for selectedIndexPath in self.selectedIndexPaths {
                if let cell = collectionView.cellForItem(at: selectedIndexPath) as? MultiSelectCell {
                    self.setCellUnselected(cell: cell, indexPath: selectedIndexPath)
                }
            }
            
            if let cell = collectionView.cellForItem(at: indexPath) as? MultiSelectCell {
                self.setCellSelected(cell: cell, indexPath: indexPath)
            }
        } else {
            if let noOfRequiredAnswers = noOfRequiredAnswers, self.selectedIndexPaths.count == noOfRequiredAnswers {
                if let cell = collectionView.cellForItem(at: indexPath) as? MultiSelectCell, cell.roundedView.tag == 0 {
                    return
                }
            }
            
            if let cell = collectionView.cellForItem(at: indexPath) as? MultiSelectCell {
                if cell.roundedView.tag == 0 {
                    self.setCellSelected(cell: cell, indexPath: indexPath)
                } else {
                    self.setCellUnselected(cell: cell, indexPath: indexPath)
                }
            }
        }
    }
    
    func setCellSelected(cell: MultiSelectCell, indexPath: IndexPath) {
        cell.roundedView.tag = 1
        cell.roundedView.backgroundColor = UIColor.mainOrange
        cell.titleLabel.textColor = UIColor.white
        cell.titleLabel.font = UIFont(name: Constants.FontNames.GothamBold, size: 20.0)
        
        self.selectedIndexPaths.append(indexPath)
    }
    
    func setCellUnselected(cell: MultiSelectCell, indexPath: IndexPath) {
        cell.roundedView.tag = 0
        cell.roundedView.backgroundColor = UIColor.white
        cell.titleLabel.textColor = UIColor.mainBlue
        cell.titleLabel.font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)
        
        if let index = self.selectedIndexPaths.index(of: indexPath) {
            self.selectedIndexPaths.remove(at: index)
        }
    }

    func shouldUseTwoColumns() -> Bool {
        guard let answers = self.content.first?.answers else {
            return false
        }
        
        if answers.count > 7 {
            return true
        }

        return false
    }
}
