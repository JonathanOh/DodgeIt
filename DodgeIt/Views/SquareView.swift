//
//  SquareView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class SquareView: UIView {
    let currentPuzzle: Puzzle
    let location: (Int, Int)
    
    init(currentPuzzle: Puzzle, location: (Int, Int)) {
        self.currentPuzzle = currentPuzzle
        self.location = location
        super.init(frame: .zero)
        backgroundColor = checkIfObstacle() ? .black : .yellow
        applyExplosionLogic()
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
    
    func applyExplosionLogic() {
        if let explosionTimers = currentPuzzle.explosionPositionAndTiming[SquareData.tupleString(location)] {
            for timer in explosionTimers {
                let delay = Double(currentPuzzle.lengthOfPuzzleCycle) * timer
                // Wait the specified delay and trigger animated explosion
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay), execute: { [weak self] in
                    self?.backgroundColor = .red
                    UIView.animate(withDuration: 0.4, animations: { [weak self] in
                        self?.backgroundColor = .yellow
                    })
                })
                // Recursively call itself to apply a repeated explosion on a timers
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(currentPuzzle.lengthOfPuzzleCycle)) { [weak self] in
                    self?.applyExplosionLogic()
                }
            }
        }
    }
}
