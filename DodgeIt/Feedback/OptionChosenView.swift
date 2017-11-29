//
//  OptionChosenView.swift
//  DodgeIt
//
//  Created by admin on 11/28/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class OptionChosenView: UIView {
    let chosenOption: FeedbackContainerView.FeedbackOption
    init(chosenOption: FeedbackContainerView.FeedbackOption) {
        self.chosenOption = chosenOption
        super.init(frame: .zero)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
