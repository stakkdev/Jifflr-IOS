//
//  SwipeCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 06/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

protocol SwipeCellDelegate: class {
    func cellSwiped(yes: Bool, question: AdExchangeQuestion)
}

class SwipeCell: UITableViewCell {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var questionImageView: UIImageView!

    var delegate: SwipeCellDelegate?
    var question: AdExchangeQuestion!

    var animationOptions: UIViewAnimationOptions = [.allowUserInteraction, .beginFromCurrentState]
    var animationDuration: TimeInterval = 0.5
    var animationDelay: TimeInterval = 0
    var animationSpingDamping: CGFloat = 0.5
    var animationInitialVelocity: CGFloat = 1
    let viewWidth: CGFloat = 100.0
    private var beginPoint = CGPoint.zero
    private var offset: CGFloat = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.drawGestureRecognizer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func drawGestureRecognizer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.didPan))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }

        let trans = pan.translation(in: self)

        if abs(trans.x) > abs(trans.y) {
            return true
        } else if self.roundedView.frame.origin.x != 0 {
            return true
        } else {
            return false
        }
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    @objc func didPan(sender: UIPanGestureRecognizer) {

        switch sender.state {
        case .began:
            self.beginPoint = sender.location(in: self)
            self.beginPoint.x -= self.roundedView.frame.origin.x
        case .changed:
            let now = sender.location(in: self)
            let distX = now.x - self.beginPoint.x
            if distX < 0 {
                let d = max(distX,-(self.roundedView.frame.size.width - self.viewWidth))
                if d > -self.viewWidth * 2  || self.roundedView.frame.origin.x > 0 {
                    self.roundedView.frame.origin.x = d
                } else {
                    sender.isEnabled = false
                    sender.isEnabled = true
                }
            } else {
                let d = min(distX, self.roundedView.frame.size.width - self.viewWidth)
                if d < self.viewWidth * 2 || self.roundedView.frame.origin.x < 0 {
                    self.roundedView.frame.origin.x = d
                } else {
                    sender.isEnabled = false
                    sender.isEnabled = true
                }
            }
        default:
            let offset = self.roundedView.frame.origin.x
            if offset > self.viewWidth {
                UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    self.roundedView.frame.origin.x = self.frame.width
                }, completion: { (value: Bool) in
                    self.cellSwipedWith(yes: true)
                })
            } else if -offset > self.viewWidth {
                UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    self.roundedView.frame.origin.x = -self.frame.width
                }, completion: { (value: Bool) in
                    self.cellSwipedWith(yes: false)
                })
            } else {
                UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, usingSpringWithDamping: self.animationSpingDamping, initialSpringVelocity: self.animationInitialVelocity, options: self.animationOptions, animations: { () -> Void in
                    self.roundedView.frame.origin.x = 18.0
                }, completion: nil )
            }
        }
    }

    func cellSwipedWith(yes: Bool) {
        self.delegate?.cellSwiped(yes: yes, question: self.question)
    }
}
