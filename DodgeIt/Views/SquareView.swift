//
//  SquareView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit
import QuartzCore

class SquareView: UIImageView, CAAnimationDelegate {
    let currentPuzzle: Puzzle
    let location: (Int, Int)
    let explosionSheet = UIImage(imageLiteralResourceName: "explosion7")
    
    init(currentPuzzle: Puzzle, location: (Int, Int)) {
        self.currentPuzzle = currentPuzzle
        self.location = location
        super.init(frame: .zero)
        backgroundColor = checkIfObstacle() ? .brown : .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkIfObstacle() -> Bool { // O(n) look up
        for position in currentPuzzle.obstaclePositions {
            if let validTuple = position.getTupleFromArray() {
                if location == validTuple { return true }
            }
        }
        return false
    }
    
    func explode() {
        if checkIfObstacle() { return }
        backgroundColor = .black
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.backgroundColor = .yellow
        }
    }
    
}
