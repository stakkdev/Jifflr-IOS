//
//  FAQSegmentedControl.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 19/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

protocol FAQSegmentedControlDelegate {
    func valueChanged()
}

class FAQSegmentedControl: UIView {

    var previousButton: FAQSegmentedControlButton?

    var selectedSegmentIndex = 0

    var delegate: FAQSegmentedControlDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.commonInit()
    }

    func commonInit() {
        self.setupUI()
    }

    func setupUI() {
        self.backgroundColor = UIColor.clear
    }

    func setupButtons(categories: [FAQCategory]) {

        guard categories.count > 0 else { return }

        self.resetView()

        for (index, category) in categories.enumerated() {
            let button = FAQSegmentedControlButton()
            button.setTitle(category.name, for: .normal)
            button.addTarget(self, action: #selector(self.buttonPressed(sender:)), for: .touchUpInside)
            button.tag = index

            if category == categories.first! {
                button.setFAQButtonEnabled()
            } else {
                button.setFAQButtonDisabled()
            }

            self.addSubview(button)

            if category == categories.last! {
                self.setupConstraints(button: button, lastButton: true)
            } else {
                self.setupConstraints(button: button, lastButton: false)
            }
        }
    }

    func setupConstraints(button: FAQSegmentedControlButton, lastButton: Bool) {

        let top = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)

        var leading: NSLayoutConstraint!
        if let previousButton = self.previousButton {
            leading = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: previousButton, attribute: .trailing, multiplier: 1.0, constant: 0.0)

            let width = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: previousButton, attribute: .width, multiplier: 1.0, constant: 0.0)
            self.addConstraint(width)
        } else {
            leading = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        }

        if lastButton == true {
            let trailing = NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            self.addConstraint(trailing)
        }

        self.addConstraints([top, bottom, leading])

        self.previousButton = button
    }

    @objc func buttonPressed(sender: FAQSegmentedControlButton) {
        guard sender.tag != self.selectedSegmentIndex else { return }

        self.selectedSegmentIndex = sender.tag

        for subview in self.subviews {
            if let button = subview as? FAQSegmentedControlButton {
                button.setFAQButtonDisabled()
            }
        }

        sender.setFAQButtonEnabled()

        self.delegate?.valueChanged()
    }

    func resetView() {
        self.previousButton = nil
        for subview in self.subviews {
            if let button = subview as? FAQSegmentedControlButton {
                self.removeConstraints(button.constraints)
                button.removeFromSuperview()
            }
        }
    }
}

class FAQSegmentedControlButton: UIButton {

    var bottomBar: UIView!
    var topBar: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.commonInit()
    }

    func commonInit() {
        self.setupUI()
        self.setupConstraints()
    }

    func setupUI() {
        self.bottomBar = UIView()
        self.bottomBar.backgroundColor = UIColor.mainOrange
        self.bottomBar.isHidden = false
        self.bottomBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.bottomBar)

        self.topBar = UIView()
        self.topBar.backgroundColor = UIColor.mainWhiteTransparent20
        self.topBar.isHidden = false
        self.topBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.topBar)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    func setupConstraints() {
        let bottomBarLeading = NSLayoutConstraint(item: self.bottomBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let bottomBarHeight = NSLayoutConstraint(item: self.bottomBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3)
        let bottomBarBottom = NSLayoutConstraint(item: self.bottomBar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let bottomBarTrailing = NSLayoutConstraint(item: self.bottomBar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        self.addConstraints([bottomBarLeading, bottomBarHeight, bottomBarBottom, bottomBarTrailing])

        let topBarLeading = NSLayoutConstraint(item: self.topBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let topBarHeight = NSLayoutConstraint(item: self.topBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        let topBarTop = NSLayoutConstraint(item: self.topBar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let topBarTrailing = NSLayoutConstraint(item: self.topBar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        self.addConstraints([topBarLeading, topBarHeight, topBarTop, topBarTrailing])
    }
}

extension FAQSegmentedControlButton {
    func setFAQButtonEnabled() {
        self.setTitleColor(UIColor.mainOrange, for: .normal)
        self.titleLabel?.font = UIFont(name: Constants.FontNames.GothamBold, size: 16.0)
        self.backgroundColor = UIColor.clear
        self.bottomBar.isHidden = false
        self.topBar.isHidden = false
    }

    func setFAQButtonDisabled() {
        self.setTitleColor(UIColor.mainWhiteTransparent50, for: .normal)
        self.titleLabel?.font = UIFont(name: Constants.FontNames.GothamBold, size: 16.0)
        self.backgroundColor = UIColor.mainWhiteTransparent20
        self.bottomBar.isHidden = true
        self.topBar.isHidden = true
    }
}
