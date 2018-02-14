//
//  DashboardButton.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 14/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class DashboardButtonLeft: UIButton {

    var iconImageView: UIImageView!
    var valueLabel: UILabel!
    var nameLabel: UILabel!
    var arrowImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.commonInit()
    }

    func commonInit() {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20.0

        self.setTitle("", for: .normal)
        self.setupUI()
        self.setupConstraints()
    }

    func setupUI() {
        self.iconImageView = UIImageView()
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.iconImageView)

        self.arrowImageView = UIImageView(image: UIImage(named: "DashboardButtonArrow"))
        self.arrowImageView.contentMode = .scaleAspectFit
        self.arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.arrowImageView)

        self.valueLabel = UILabel()
        self.valueLabel.textColor = UIColor.white
        self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.valueLabel)

        self.nameLabel = UILabel()
        self.nameLabel.textColor = UIColor.white
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.nameLabel)

        if Constants.isSmallScreen {
            self.nameLabel.font = UIFont(name: Constants.FontNames.GothamMedium, size: 12)
            self.valueLabel.font = UIFont(name: Constants.FontNames.GothamBold, size: 18)
        } else {
            self.nameLabel.font = UIFont(name: Constants.FontNames.GothamMedium, size: 16)
            self.valueLabel.font = UIFont(name: Constants.FontNames.GothamBold, size: 24)
        }
    }

    func setupConstraints() {
        let iconLeading = NSLayoutConstraint(item: self.iconImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 12)
        let iconTop = NSLayoutConstraint(item: self.iconImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 12)
        let iconHeight = NSLayoutConstraint(item: self.iconImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.22, constant: 0)
        self.addConstraints([iconLeading, iconTop, iconHeight])

        let arrowLeading = NSLayoutConstraint(item: self.arrowImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 12)
        let arrowBottom = NSLayoutConstraint(item: self.arrowImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -12)
        let arrowHeight = NSLayoutConstraint(item: self.arrowImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16)
        let arrowWidth = NSLayoutConstraint(item: self.arrowImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16)
        self.addConstraints([arrowLeading, arrowBottom, arrowHeight, arrowWidth])

        let valueLeading = NSLayoutConstraint(item: self.valueLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 12)
        let valueTop = NSLayoutConstraint(item: self.valueLabel, attribute: .top, relatedBy: .equal, toItem: self.iconImageView, attribute: .bottom, multiplier: 1, constant: 5)
        valueTop.priority = .defaultLow
        let valueTopGreater = NSLayoutConstraint(item: self.valueLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.iconImageView, attribute: .bottom, multiplier: 1, constant: 0)
        let valueTrailing = NSLayoutConstraint(item: self.valueLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -12)
        self.addConstraints([valueLeading, valueTop, valueTopGreater, valueTrailing])

        let nameLeading = NSLayoutConstraint(item: self.nameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 12)
        let nameTop = NSLayoutConstraint(item: self.nameLabel, attribute: .top, relatedBy: .equal, toItem: self.valueLabel, attribute: .bottom, multiplier: 1, constant: 2)
        nameTop.priority = .defaultLow
        let nameTopGreater = NSLayoutConstraint(item: self.nameLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.valueLabel, attribute: .bottom, multiplier: 1, constant: 0)
        let nameTrailing = NSLayoutConstraint(item: self.nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -12)
        let nameBottom = NSLayoutConstraint(item: self.nameLabel, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self.arrowImageView, attribute: .top, multiplier: 1, constant: -12)
        if Constants.isSmallScreen {
            nameBottom.constant = -8
        }
        self.addConstraints([nameLeading, nameTop, nameTopGreater, nameTrailing, nameBottom])
    }

    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }

    func setValue(value: Int) {
        self.valueLabel.text = "\(value)"
    }

    func setName(text: String) {
        self.nameLabel.text = text
    }

    func setImage(image: UIImage?) {
        self.iconImageView.image = image
    }
}
