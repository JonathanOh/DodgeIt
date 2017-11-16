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
    let currentPlayer: Player
    let location: (Int, Int)
    let locationStringValue: String
    let explosionSheet = UIImage(imageLiteralResourceName: "explosion3")
    
//    let puzzleBackgroundColor: UIColor = CONSTANTS.COLORS.PUZZLE_SQUARE//.black//UIColor(red: 1, green: 1, blue: 100.0/255.0, alpha: 1)
//    let explosionColor: UIColor = CONSTANTS.COLORS.PUZZLE_SQUARE_EXPLOSION
//    let obstacleColor: UIColor = CONSTANTS.COLORS.OBSTACLE
    
    init(currentPuzzle: Puzzle, location: (Int, Int), currentPlayer: Player) {
        self.currentPuzzle = currentPuzzle
        self.currentPlayer = currentPlayer
        self.location = location
        self.locationStringValue = "\(location.0),\(location.1)"
        super.init(frame: .zero)
        layer.borderWidth = 1
        layer.cornerRadius = CGFloat(currentPuzzle.squareWidth) / 6
        layer.borderColor = UIColor.getRGBFromArray(currentPlayer.randomMapTheme.backgroundColor)?.cgColor//CONSTANTS.COLORS.BACKGROUND_VIEW.cgColor//UIColor.black.cgColor
        backgroundColor = isObstacle() ? UIColor.getRGBFromArray(currentPlayer.randomMapTheme.obstacleColor)! : UIColor.getRGBFromArray(currentPlayer.randomMapTheme.courseColor)!//CONSTANTS.COLORS.OBSTACLE : CONSTANTS.COLORS.PUZZLE_SQUARE
        if isSafe() {
            backgroundColor = UIColor.getRGBFromArray(currentPlayer.randomMapTheme.courseColor)//CONSTANTS.COLORS.PUZZLE_CONTAINER_VIEW
            layer.borderWidth = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isSafe() -> Bool {
        return currentPuzzle.isLocationSafe(locationStringValue)
    }
    func isObstacle() -> Bool {
        return currentPuzzle.isLocationAnObstacle(locationStringValue)
    }
    
    func explode() {
        if isSafe() || isObstacle() { return }
        backgroundColor = UIColor.getRGBFromArray(currentPlayer.randomMapTheme.explosionColor)//CONSTANTS.COLORS.PUZZLE_SQUARE_EXPLOSION
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [UIViewAnimationOptions.allowUserInteraction], animations: { [weak self] in
            self?.backgroundColor = UIColor.getRGBFromArray(self!.currentPlayer.randomMapTheme.courseColor)//CONSTANTS.COLORS.PUZZLE_SQUARE
        }, completion: nil)
    }
    
}
