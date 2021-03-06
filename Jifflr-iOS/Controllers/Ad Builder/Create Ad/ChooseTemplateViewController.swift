//
//  ChooseTemplateViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 26/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class ChooseTemplateViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var advert: Advert!
    
    var templates: [AdvertTemplate] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    class func instantiateFromStoryboard(advert: Advert) -> ChooseTemplateViewController {
        let storyboard = UIStoryboard(name: "CreateAd", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChooseTemplateViewController") as! ChooseTemplateViewController
        vc.advert = advert
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MediaManager.shared.deleteCreateAdMedia()
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
        if Reachability.isConnectedToNetwork() {
            self.updateServerData()
        } else {
            self.updateLocalData()
        }
    }
    
    func updateServerData() {
        AdBuilderManager.shared.fetchTemplates(local: false) { (templates) in
            guard templates.count > 0 else {
                self.updateLocalData()
                return
            }
            
            self.templates = templates
        }
    }
    
    func updateLocalData() {
        AdBuilderManager.shared.fetchTemplates(local: true) { (templates) in
            guard templates.count > 0 else {
                self.displayError(error: ErrorMessage.templateFetchFailed)
                return
            }
            
            self.templates = templates
        }
    }
    
    @objc func nextButtonPressed(sender: UIButton) {
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            self.displayError(error: ErrorMessage.chooseTemplate)
            return
        }
        
        let template = self.templates[indexPath.row]
        self.advert.details?.template = template
        
        if self.advert.objectId == nil && self.advert.details?.image != nil {
            self.advert.details?.remove(forKey: "image")
        }
        
        let vc = AddContentViewController.instantiateFromStoryboard(advert: self.advert)
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let template = self.templates[indexPath.row]
        if let chosenTemplate = self.advert.details?.template {
            if template.key == chosenTemplate.key {
                cell.setSelected(true, animated: false)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
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
