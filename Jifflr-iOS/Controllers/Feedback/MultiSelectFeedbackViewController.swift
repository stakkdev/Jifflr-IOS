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

    override func validateAnswers() -> Bool {
        return true
    }
}

extension MultiSelectFeedbackViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiSelectCell", for: indexPath) //as! Cell
        return cell
    }
}
