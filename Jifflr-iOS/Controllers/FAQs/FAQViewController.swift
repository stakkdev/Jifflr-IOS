//
//  FAQViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 19/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class FAQViewController: BaseViewController {

    @IBOutlet weak var segmentedControl: FAQSegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    var faqData:[(category: FAQCategory, data: [FAQ])]? {
        didSet {
            let categories = self.faqData!.map { $0.category }
            self.segmentedControl.setupButtons(categories: categories)

            self.tableView.reloadData()
        }
    }

    class func instantiateFromStoryboard() -> FAQViewController {
        let storyboard = UIStoryboard(name: "FAQs", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.fetchData()
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)

        self.segmentedControl.delegate = self
        self.tableView.estimatedRowHeight = 70.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    func setupLocalization() {
        self.title = "faqs.navigation.title".localized()
    }

    func fetchData() {
        FAQManager.shared.fetchLocalFAQs { (data, error) in
            guard let data = data, error == nil else {
                if let error = error {
                    self.displayMessage(title: error.failureTitle, message: error.failureDescription)
                }
                return
            }

            self.faqData = data
        }

        FAQManager.shared.fetchFAQs { (data, error) in
            guard let data = data, error == nil else {
                if let error = error {
                    self.displayMessage(title: error.failureTitle, message: error.failureDescription)
                }
                return
            }

            self.faqData = data
        }
    }
}

extension FAQViewController: FAQSegmentedControlDelegate {
    func valueChanged() {
        self.tableView.reloadData()
    }
}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let faqData = self.faqData, faqData.count > 0 else { return 0 }

        let selectedTab = self.segmentedControl.selectedSegmentIndex
        return faqData[selectedTab].data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell") as! FAQCell
        cell.accessoryType = .none
        cell.selectionStyle = .none

        let selectedTab = self.segmentedControl.selectedSegmentIndex
        cell.titleLabel.text = self.faqData?[selectedTab].data[indexPath.row].title

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTab = self.segmentedControl.selectedSegmentIndex
        guard let faq = self.faqData?[selectedTab].data[indexPath.row] else { return }

        let viewController = FAQDetailViewController.instantiateFromStoryboard()
        viewController.faq = faq
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
