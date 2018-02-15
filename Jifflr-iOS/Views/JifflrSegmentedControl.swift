//
//  JifflrSegmentedControl.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 15/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

protocol JifflrSegmentedControlDelegate {
    func button1Pressed()
    func button2Pressed()
}

class JifflrSegmentedControl: UIView {

    var button1: UIButton!
    var button1BottomBar: UIView!
    var button1TopBar: UIView!

    var button2: UIButton!
    var button2BottomBar: UIView!
    var button2TopBar: UIView!

    var delegate: JifflrSegmentedControlDelegate?

    var selectedSegmentIndex = 0

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
        self.button1 = UIButton(type: .custom)
        self.button1.addTarget(self, action: #selector(self.button1Pressed(sender:)), for: .touchUpInside)
        self.button1.translatesAutoresizingMaskIntoConstraints = false
        self.button1.setButtonEnabled()
        self.addSubview(self.button1)

        self.button1BottomBar = UIView()
        self.button1BottomBar.backgroundColor = UIColor.mainOrange
        self.button1BottomBar.isHidden = false
        self.button1BottomBar.translatesAutoresizingMaskIntoConstraints = false
        self.button1.addSubview(self.button1BottomBar)

        self.button1TopBar = UIView()
        self.button1TopBar.backgroundColor = UIColor.mainWhiteTransparent20
        self.button1TopBar.isHidden = false
        self.button1TopBar.translatesAutoresizingMaskIntoConstraints = false
        self.button1.addSubview(self.button1TopBar)

        self.button2 = UIButton(type: .custom)
        self.button2.addTarget(self, action: #selector(self.button2Pressed(sender:)), for: .touchUpInside)
        self.button2.translatesAutoresizingMaskIntoConstraints = false
        self.button2.setButtonDisabled()
        self.addSubview(self.button2)

        self.button2BottomBar = UIView()
        self.button2BottomBar.backgroundColor = UIColor.mainOrange
        self.button2BottomBar.isHidden = true
        self.button2BottomBar.translatesAutoresizingMaskIntoConstraints = false
        self.button2.addSubview(self.button2BottomBar)

        self.button2TopBar = UIView()
        self.button2TopBar.backgroundColor = UIColor.mainWhiteTransparent20
        self.button2TopBar.isHidden = false
        self.button2TopBar.translatesAutoresizingMaskIntoConstraints = false
        self.button2.addSubview(self.button2TopBar)

        self.backgroundColor = UIColor.clear
    }

    func setupConstraints() {
        let button1Leading = NSLayoutConstraint(item: self.button1, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let button1Top = NSLayoutConstraint(item: self.button1, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let button1Bottom = NSLayoutConstraint(item: self.button1, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let button1Trailing = NSLayoutConstraint(item: self.button1, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraints([button1Leading, button1Top, button1Bottom, button1Trailing])

        let button1BottomBarLeading = NSLayoutConstraint(item: self.button1BottomBar, attribute: .leading, relatedBy: .equal, toItem: self.button1, attribute: .leading, multiplier: 1, constant: 0)
        let button1BottomBarHeight = NSLayoutConstraint(item: self.button1BottomBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3)
        let button1BottomBarBottom = NSLayoutConstraint(item: self.button1BottomBar, attribute: .bottom, relatedBy: .equal, toItem: self.button1, attribute: .bottom, multiplier: 1, constant: 0)
        let button1BottomBarTrailing = NSLayoutConstraint(item: self.button1BottomBar, attribute: .trailing, relatedBy: .equal, toItem: self.button1, attribute: .trailing, multiplier: 1, constant: 0)
        self.addConstraints([button1BottomBarLeading, button1BottomBarHeight, button1BottomBarBottom, button1BottomBarTrailing])

        let button1TopBarLeading = NSLayoutConstraint(item: self.button1TopBar, attribute: .leading, relatedBy: .equal, toItem: self.button1, attribute: .leading, multiplier: 1, constant: 0)
        let button1TopBarHeight = NSLayoutConstraint(item: self.button1TopBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        let button1TopBarTop = NSLayoutConstraint(item: self.button1TopBar, attribute: .top, relatedBy: .equal, toItem: self.button1, attribute: .top, multiplier: 1, constant: 0)
        let button1TopBarTrailing = NSLayoutConstraint(item: self.button1TopBar, attribute: .trailing, relatedBy: .equal, toItem: self.button1, attribute: .trailing, multiplier: 1, constant: 0)
        self.addConstraints([button1TopBarLeading, button1TopBarHeight, button1TopBarTop, button1TopBarTrailing])

        let button2Leading = NSLayoutConstraint(item: self.button2, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let button2Top = NSLayoutConstraint(item: self.button2, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let button2Bottom = NSLayoutConstraint(item: self.button2, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let button2Trailing = NSLayoutConstraint(item: self.button2, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        self.addConstraints([button2Leading, button2Top, button2Bottom, button2Trailing])

        let button2BottomBarLeading = NSLayoutConstraint(item: self.button2BottomBar, attribute: .leading, relatedBy: .equal, toItem: self.button2, attribute: .leading, multiplier: 1, constant: 0)
        let button2BottomBarHeight = NSLayoutConstraint(item: self.button2BottomBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3)
        let button2BottomBarBottom = NSLayoutConstraint(item: self.button2BottomBar, attribute: .bottom, relatedBy: .equal, toItem: self.button2, attribute: .bottom, multiplier: 1, constant: 0)
        let button2BottomBarTrailing = NSLayoutConstraint(item: self.button2BottomBar, attribute: .trailing, relatedBy: .equal, toItem: self.button2, attribute: .trailing, multiplier: 1, constant: 0)
        self.addConstraints([button2BottomBarLeading, button2BottomBarHeight, button2BottomBarBottom, button2BottomBarTrailing])

        let button2TopBarLeading = NSLayoutConstraint(item: self.button2TopBar, attribute: .leading, relatedBy: .equal, toItem: self.button2, attribute: .leading, multiplier: 1, constant: 0)
        let button2TopBarHeight = NSLayoutConstraint(item: self.button2TopBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        let button2TopBarTop = NSLayoutConstraint(item: self.button2TopBar, attribute: .top, relatedBy: .equal, toItem: self.button2, attribute: .top, multiplier: 1, constant: 0)
        let button2TopBarTrailing = NSLayoutConstraint(item: self.button2TopBar, attribute: .trailing, relatedBy: .equal, toItem: self.button2, attribute: .trailing, multiplier: 1, constant: 0)
        self.addConstraints([button2TopBarLeading, button2TopBarHeight, button2TopBarTop, button2TopBarTrailing])
    }

    @objc func button1Pressed(sender: UIButton) {
        guard self.button1.tag == 0 else { return }

        self.selectedSegmentIndex = 0

        self.button1.setButtonEnabled()
        self.button2.setButtonDisabled()

        self.button2BottomBar.isHidden = true
        self.button1BottomBar.isHidden = false

        self.button2TopBar.isHidden = true
        self.button1TopBar.isHidden = false

        self.delegate?.button1Pressed()
    }

    @objc func button2Pressed(sender: UIButton) {
        guard self.button2.tag == 0 else { return }

        self.selectedSegmentIndex = 1

        self.button2.setButtonEnabled()
        self.button1.setButtonDisabled()

        self.button2BottomBar.isHidden = false
        self.button1BottomBar.isHidden = true

        self.button2TopBar.isHidden = false
        self.button1TopBar.isHidden = true

        self.delegate?.button2Pressed()
    }

    func setButton1Title(text: String) {
        self.button1.setTitle(text, for: .normal)
    }

    func setButton2Title(text: String) {
        self.button2.setTitle(text, for: .normal)
    }
}

extension UIButton {
    func setButtonEnabled() {
        self.setTitleColor(UIColor.mainOrange, for: .normal)
        self.titleLabel?.font = UIFont(name: Constants.FontNames.GothamBold, size: 16.0)
        self.backgroundColor = UIColor.clear
        self.tag = 1
    }

    func setButtonDisabled() {
        self.setTitleColor(UIColor.mainWhiteTransparent50, for: .normal)
        self.titleLabel?.font = UIFont(name: Constants.FontNames.GothamBold, size: 16.0)
        self.backgroundColor = UIColor.mainWhiteTransparent20
        self.tag = 0
    }
}
