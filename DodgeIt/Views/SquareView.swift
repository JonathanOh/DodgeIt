//
//  SquareView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit
import QuartzCore

class SquareView: UIView, CAAnimationDelegate {
    let currentPuzzle: Puzzle
    let location: (Int, Int)
    let locationStringValue: String
    let explosionSheet = UIImage(imageLiteralResourceName: "explosion3")
    
    let puzzleBackgroundColor: UIColor = UIColor(red: 1, green: 1, blue: 100.0/255.0, alpha: 1)
    let explosionColor: UIColor = .black//UIColor(red: 1.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1)//(255,179,186)
    let obstacleColor: UIColor = .darkGray
    
    init(currentPuzzle: Puzzle, location: (Int, Int)) {
        self.currentPuzzle = currentPuzzle
        self.location = location
        self.locationStringValue = "\(location.0),\(location.1)"
        self.explosionImageView = UIImageView(image: explosionSheet)
        super.init(frame: .zero)
        backgroundColor = checkIfObstacle() ? obstacleColor : puzzleBackgroundColor
        if checkIfSafeHaven() { backgroundColor = UIColor(red: 100/255.0, green: 1.0, blue: 100/255.0, alpha: 1) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkIfObstacle() -> Bool {
        return currentPuzzle.isLocationAnObstacle(locationStringValue)
    }
    
    func checkIfSafeHaven() -> Bool {
        return currentPuzzle.isLocationSafe(locationStringValue)
    }
    
    func explode() {
        if checkIfObstacle() { return }
        if checkIfSafeHaven() { return }
        backgroundColor = explosionColor
        UIView.animate(withDuration: 0.6, delay: 0.1, options: [UIViewAnimationOptions.allowUserInteraction], animations: { [weak self] in
            self?.backgroundColor = self?.puzzleBackgroundColor
        }, completion: nil)
    }
    
}
