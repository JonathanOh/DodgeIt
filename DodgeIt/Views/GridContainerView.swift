//
//  GridContainerView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class GridContainerView: UIView {
    let currentPuzzle: Puzzle
    
    init(currentPuzzle: Puzzle) {
        self.currentPuzzle = currentPuzzle
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    //Create a 2D matrix of SquareViews
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
