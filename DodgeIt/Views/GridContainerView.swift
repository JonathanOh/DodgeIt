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
    let squareViewMatrix: [[SquareView]]
    
    init(currentPuzzle: Puzzle) {
        self.currentPuzzle = currentPuzzle
        self.squareViewMatrix = GridContainerView.generateSquareViews(currentPuzzle: currentPuzzle)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
    }
    
    static func generateSquareViews(currentPuzzle: Puzzle) -> [[SquareView]] {
        var squareViews = [[SquareView]]()
        for y in 0..<currentPuzzle.numberOfCellsInHeight {
            var squareRow = [SquareView]()
            for x in 0..<currentPuzzle.numberOfCellsInWidth {
                squareRow.append(SquareView(currentPuzzle: currentPuzzle, location: (x, y)))
            }
            squareViews.append(squareRow)
        }
        return squareViews
    }
    
    //Create a 2D matrix of SquareViews
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
