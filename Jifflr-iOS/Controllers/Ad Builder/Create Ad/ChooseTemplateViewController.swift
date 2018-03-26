//
//  ChooseTemplateViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 26/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class ChooseTemplateViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var templates: [AdvertTemplate] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    class func instantiateFromStoryboard() -> ChooseTemplateViewController {
        let storyboard = UIStoryboard(name: "CreateAd", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ChooseTemplateViewController") as! ChooseTemplateViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupData()
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 93.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 48.0, right: 0.0)
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = self.footerView()
    }
    
    func setupLocalization() {
        self.title = "chooseTemplate.navigation.title".localized()
    }
    
    func setupData() {
        AdBuilderManager.shared.fetchTemplates { (templates) in
            guard templates.count > 0 else {
                return
            }
            
            self.templates = templates
        }
    }
    
    @objc func nextButtonPressed(sender: UIButton) {
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        
        let template = self.templates[indexPath.row]
        // TODO - Do something with template
    }
}

extension ChooseTemplateViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.templates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseTemplateCell", for: indexPath) as! ChooseTemplateCell
        cell.accessoryType = .none
        cell.selectionStyle = .none
        
        let template = self.templates[indexPath.row]
        cell.titleLabel.text = template.text
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.lineBreakMode = .byWordWrapping
        
        if let imageFile = template.image {
            imageFile.getDataInBackground(block: { (data, error) in
                if let data = data, error == nil {
                    cell.templateImageView.image = UIImage(data: data)
                }
            })
        }
        
        return cell
    }
    
    func footerView() -> UIView {
        let width = UIScreen.main.bounds.width
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 63.0))
        view.backgroundColor = UIColor.clear
        
        let margin: CGFloat = 18.0
        let buttonWidth = width - (margin * 2)
        let button = JifflrButton(frame: CGRect(x: margin, y: 13.0, width: buttonWidth, height: 50.0))
        button.setBackgroundColor(color: UIColor.mainPink)
        button.setTitle("createAd.nextButton.title".localized(), for: .normal)
        button.addTarget(self, action: #selector(self.nextButtonPressed(sender:)), for: .touchUpInside)
        view.addSubview(button)
        
        return view
    }
}
