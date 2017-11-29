//
//  FeedbackClearBackgroundView.swift
//  DodgeIt
//
//  Created by admin on 11/28/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class FeedbackClearBackgroundView: UIView {
    
    let feedbackContainer: FeedbackContainerView = FeedbackContainerView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupFeedBackContainerView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSelf))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapSelf() {
        print("tapped self")
        removeFromSuperview()
    }
    
    func fadeInFeedbackView() {
        layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.feedbackContainer.alpha = 1
        }
    }

    func setupFeedBackContainerView() {
        feedbackContainer.alpha = 0
        addSubview(feedbackContainer)
        feedbackContainer.constrainCenterXTo(anchor: centerXAnchor)
        feedbackContainer.constrainCenterYTo(anchor: centerYAnchor)
        feedbackContainer.constrainHeightTo(dimension: heightAnchor, multiplier: 0.5)
        feedbackContainer.constrainWidthTo(dimension: widthAnchor, multiplier: 0.8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedbackClearBackgroundView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view!.isDescendant(of: feedbackContainer) ? false : true
    }
}
