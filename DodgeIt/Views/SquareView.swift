//
//  SquareView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class SquareView: UIView, CAAnimationDelegate {
    let currentPuzzle: Puzzle
    let location: (Int, Int)
    
    init(currentPuzzle: Puzzle, location: (Int, Int)) {
        self.currentPuzzle = currentPuzzle
        self.location = location
        super.init(frame: .zero)
        backgroundColor = checkIfObstacle() ? .black : .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkIfObstacle() -> Bool {
        for position in currentPuzzle.obstaclePositions {
            if let validTuple = position.tupleValue() {
                return location == validTuple
            }
        }
        return false
    }
    
    func explode() {        
        backgroundColor = .red
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.backgroundColor = .yellow
        }
    }
    
}
