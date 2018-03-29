//
//  CMSAdvertViewController+Constraints.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 27/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation
import UIKit

extension CMSAdvertViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.titleBackgroundView.layer.masksToBounds = true
        self.titleBackgroundView.layer.cornerRadius = 20.0
        
        self.messageTextView.layer.masksToBounds = true
        self.messageTextView.layer.cornerRadius = 20.0
        self.messageTextView.textContainerInset = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 52.0)
    }
    
    func setupConstraints() {
        guard let template = self.advert.details?.template else { return }
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.messageTextView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.trianglesImageView.translatesAutoresizingMaskIntoConstraints = false
        self.spinner.translatesAutoresizingMaskIntoConstraints = false
        
        switch template.key {
        case AdvertTemplateKey.imageVideoPortait:
            self.setupImageVideoPortait()
        case AdvertTemplateKey.imageVideoLandscape:
            self.setupImageVideoLandscape()
        case AdvertTemplateKey.titleMessageImage:
            self.setupTitleMessageImage()
        case AdvertTemplateKey.titleImageMessage:
            self.setupTitleImageMessage()
        case AdvertTemplateKey.imageTitleMessage:
            self.setupImageTitleMessage()
        default:
            return
        }
    }
    
    func setupImageVideoPortait() {
        self.titleBackgroundView.isHidden = true
        self.titleLabel.isHidden = true
        self.messageTextView.isHidden = true
        self.trianglesImageView.isHidden = true
        
        let imageViewLeading = NSLayoutConstraint(item: self.imageView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let imageViewTrailing = NSLayoutConstraint(item: self.imageView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let imageViewTop = NSLayoutConstraint(item: self.imageView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let imageViewBottom = NSLayoutConstraint(item: self.imageView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([imageViewLeading, imageViewTrailing, imageViewTop, imageViewBottom])
        
        self.addSpinnerConstraints()
    }
    
    func setupImageVideoLandscape() {
        self.setupImageVideoPortait()
    }
    
    func setupTitleMessageImage() {
        
        let titleBackgroundLeading = NSLayoutConstraint(item: self.titleBackgroundView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: -20.0)
        let titleBackgroundTrailing = NSLayoutConstraint(item: self.titleBackgroundView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -18.0)
        let titleBackgroundHeight = NSLayoutConstraint(item: self.titleBackgroundView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.11, constant: 0.0)
        let titleBackgroundTop = NSLayoutConstraint(item: self.titleBackgroundView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        self.view.addConstraints([titleBackgroundLeading, titleBackgroundTrailing, titleBackgroundHeight, titleBackgroundTop])
        
        self.addTitleLabelConstraints()
        
        let imageViewLeading = NSLayoutConstraint(item: self.imageView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let imageViewTrailing = NSLayoutConstraint(item: self.imageView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let imageViewHeight = NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.34, constant: 0.0)
        let imageViewBottom = NSLayoutConstraint(item: self.imageView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -48.0)
        self.view.addConstraints([imageViewLeading, imageViewTrailing, imageViewHeight, imageViewBottom])
        
        self.addTrianglesImageViewConstraints()
        
        let textViewLeading = NSLayoutConstraint(item: self.messageTextView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 18.0)
        let textViewTrailing = NSLayoutConstraint(item: self.messageTextView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 20.0)
        let textViewTop = NSLayoutConstraint(item: self.messageTextView, attribute: .top, relatedBy: .equal, toItem: self.titleBackgroundView, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        let textViewBottom = NSLayoutConstraint(item: self.messageTextView, attribute: .bottom, relatedBy: .equal, toItem: self.imageView, attribute: .top, multiplier: 1.0, constant: -15.0)
        self.view.addConstraints([textViewLeading, textViewTrailing, textViewTop, textViewBottom])
        
        self.addSpinnerConstraints()
    }
    
    func setupTitleImageMessage() {
        let titleBackgroundLeading = NSLayoutConstraint(item: self.titleBackgroundView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: -20.0)
        let titleBackgroundTrailing = NSLayoutConstraint(item: self.titleBackgroundView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -18.0)
        let titleBackgroundHeight = NSLayoutConstraint(item: self.titleBackgroundView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.11, constant: 0.0)
        let titleBackgroundTop = NSLayoutConstraint(item: self.titleBackgroundView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        self.view.addConstraints([titleBackgroundLeading, titleBackgroundTrailing, titleBackgroundHeight, titleBackgroundTop])
        
        self.addTitleLabelConstraints()
        
        let imageViewLeading = NSLayoutConstraint(item: self.imageView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let imageViewTrailing = NSLayoutConstraint(item: self.imageView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let imageViewHeight = NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.34, constant: 0.0)
        let imageViewTop = NSLayoutConstraint(item: self.imageView, attribute: .top, relatedBy: .equal, toItem: self.titleBackgroundView, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        self.view.addConstraints([imageViewLeading, imageViewTrailing, imageViewHeight, imageViewTop])
        
        self.addTrianglesImageViewConstraints()
        
        let textViewLeading = NSLayoutConstraint(item: self.messageTextView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 18.0)
        let textViewTrailing = NSLayoutConstraint(item: self.messageTextView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 20.0)
        let textViewTop = NSLayoutConstraint(item: self.messageTextView, attribute: .top, relatedBy: .equal, toItem: self.imageView, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        let textViewBottom = NSLayoutConstraint(item: self.messageTextView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -48.0)
        self.view.addConstraints([textViewLeading, textViewTrailing, textViewTop, textViewBottom])
        
        self.addSpinnerConstraints()
    }
    
    func setupImageTitleMessage() {
        
        let imageViewLeading = NSLayoutConstraint(item: self.imageView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let imageViewTrailing = NSLayoutConstraint(item: self.imageView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let imageViewHeight = NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.34, constant: 0.0)
        let imageViewTop = NSLayoutConstraint(item: self.imageView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        self.view.addConstraints([imageViewLeading, imageViewTrailing, imageViewHeight, imageViewTop])
        
        let titleBackgroundLeading = NSLayoutConstraint(item: self.titleBackgroundView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: -20.0)
        let titleBackgroundTrailing = NSLayoutConstraint(item: self.titleBackgroundView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -18.0)
        let titleBackgroundHeight = NSLayoutConstraint(item: self.titleBackgroundView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.11, constant: 0.0)
        let titleBackgroundTop = NSLayoutConstraint(item: self.titleBackgroundView, attribute: .top, relatedBy: .equal, toItem: self.imageView, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        self.view.addConstraints([titleBackgroundLeading, titleBackgroundTrailing, titleBackgroundHeight, titleBackgroundTop])
        
        self.addTitleLabelConstraints()
        
        self.addTrianglesImageViewConstraints()
        
        let textViewLeading = NSLayoutConstraint(item: self.messageTextView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 18.0)
        let textViewTrailing = NSLayoutConstraint(item: self.messageTextView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 20.0)
        let textViewTop = NSLayoutConstraint(item: self.messageTextView, attribute: .top, relatedBy: .equal, toItem: self.titleBackgroundView, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        let textViewBottom = NSLayoutConstraint(item: self.messageTextView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -48.0)
        self.view.addConstraints([textViewLeading, textViewTrailing, textViewTop, textViewBottom])
        
        self.addSpinnerConstraints()
    }
    
    func addTitleLabelConstraints() {
        let titleLabelLeading = NSLayoutConstraint(item: self.titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.titleBackgroundView, attribute: .leading, multiplier: 1.0, constant: 59.0)
        let titleLabelTrailing = NSLayoutConstraint(item: self.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self.titleBackgroundView, attribute: .trailing, multiplier: 1.0, constant: -8.0)
        let titleLabelCenterY = NSLayoutConstraint(item: self.titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self.titleBackgroundView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.titleBackgroundView.addConstraints([titleLabelLeading, titleLabelTrailing, titleLabelCenterY])
    }
    
    func addTrianglesImageViewConstraints() {
        let trianglesTrailing = NSLayoutConstraint(item: self.trianglesImageView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let trianglesHeight = NSLayoutConstraint(item: self.trianglesImageView, attribute: .height, relatedBy: .equal, toItem: self.messageTextView, attribute: .height, multiplier: 0.54, constant: 0.0)
        let trianglesCenterY = NSLayoutConstraint(item: self.trianglesImageView, attribute: .centerY, relatedBy: .equal, toItem: self.messageTextView, attribute: .centerY, multiplier: 1.0, constant: 30.0)
        let trianglesWidth = NSLayoutConstraint(item: self.trianglesImageView, attribute: .width, relatedBy: .equal, toItem: self.trianglesImageView, attribute: .height, multiplier: 0.36, constant: 0.0)
        self.view.addConstraints([trianglesTrailing, trianglesHeight, trianglesCenterY, trianglesWidth])
    }
    
    func addSpinnerConstraints() {
        let spinnerCenterX = NSLayoutConstraint(item: self.spinner, attribute: .centerX, relatedBy: .equal, toItem: self.imageView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let spinnerCenterY = NSLayoutConstraint(item: self.spinner, attribute: .centerY, relatedBy: .equal, toItem: self.imageView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([spinnerCenterX, spinnerCenterY])
    }
}
