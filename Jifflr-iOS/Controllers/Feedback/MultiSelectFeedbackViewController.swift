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

    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    class func instantiateFromStoryboard(advert: Advert, question: Question?) -> MultiSelectFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MultiSelectFeedbackViewController") as! MultiSelectFeedbackViewController
        controller.advert = advert
        controller.question = question
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
        return true
    }
}

extension MultiSelectFeedbackViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.months.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiSelectCell", for: indexPath) as! MultiSelectCell
        cell.titleLabel.text = self.months[indexPath.row]

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
        if let cell = collectionView.cellForItem(at: indexPath) as? MultiSelectCell {
            if cell.roundedView.tag == 0 {
                cell.roundedView.tag = 1
                cell.roundedView.backgroundColor = UIColor.mainOrange
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.font = UIFont(name: Constants.FontNames.GothamBold, size: 20.0)
            } else {
                cell.roundedView.tag = 0
                cell.roundedView.backgroundColor = UIColor.white
                cell.titleLabel.textColor = UIColor.mainBlue
                cell.titleLabel.font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)
            }
        }
    }

    func shouldUseTwoColumns() -> Bool {
        if self.months.count > 6 {
            return true
        }

        return false
    }
}
