//
//  SquareView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class SquareView: UIImageView, CAAnimationDelegate {
    let currentPuzzle: Puzzle
    let location: (Int, Int)
    let explosionSheet = UIImage(imageLiteralResourceName: "explosion7")
    
    init(currentPuzzle: Puzzle, location: (Int, Int)) {
        self.currentPuzzle = currentPuzzle
        self.location = location
        super.init(frame: .zero)
        backgroundColor = checkIfObstacle() ? .black : .yellow
        
        let puzzleWidth = currentPuzzle.squareWidth * Double(currentPuzzle.numberOfCellsInWidth)
        let puzzleHeight = currentPuzzle.squareWidth * Double(currentPuzzle.numberOfCellsInHeight)
        let resizedImage = explosionSheet.resizeImage(targetSize: CGSize(width: puzzleWidth, height: puzzleHeight))
        clipsToBounds = true
        contentMode = .scaleAspectFill
        
        //bounds = CGRect(x: 0.0, y: CGFloat(currentPuzzle.squareWidth * 3), width: bounds.width, height: bounds.height)
        //image = resizedImage
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
        let imageCollection: [UIImage] = [UIImage(imageLiteralResourceName: "explosion3"),UIImage(imageLiteralResourceName: "explosion4"),UIImage(imageLiteralResourceName: "explosion5"),UIImage(imageLiteralResourceName: "explosion6"),UIImage(imageLiteralResourceName: "explosion7")]
        animationImages = imageCollection
        animationDuration = 0.4
        animationRepeatCount = 1
        startAnimating()
//        backgroundColor = .red
//        UIView.animate(withDuration: 0.4) { [weak self] in
//            self?.backgroundColor = .yellow
//        }
    }
    
}
