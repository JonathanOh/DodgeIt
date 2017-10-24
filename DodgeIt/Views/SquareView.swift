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

        clipsToBounds = true
        contentMode = .scaleAspectFill
        
        //bounds = CGRect(x: 0.0, y: CGFloat(currentPuzzle.squareWidth * 3), width: bounds.width, height: bounds.height)
        //alpha = 0
        //image = UIImage(imageLiteralResourceName: "explosion3")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkIfObstacle() -> Bool {
//        for position in currentPuzzle.obstaclePositions {
//            if let validTuple = position.tupleValue() {
//                return location == validTuple
//            }
//        }
        for position in currentPuzzle.obstaclePositions {
            if let validTuple = position.getTupleFromArray() {
                if location == validTuple { return true }
            }
        }
        return false
    }
    
    func explode() {
        if checkIfObstacle() { return }
        
//        let imageCollection: [UIImage] = [UIImage(imageLiteralResourceName: "explosion3"),UIImage(imageLiteralResourceName: "explosion4"),UIImage(imageLiteralResourceName: "explosion5"),UIImage(imageLiteralResourceName: "explosion6"),UIImage(imageLiteralResourceName: "explosion7")]
//        animationImages = imageCollection
//        animationDuration = 0.4
//        animationRepeatCount = 1
//        startAnimating()
//        UIView.animate(withDuration: 0.4) { [weak self] in
//            self?.backgroundColor = .yellow
//        }
//        alpha = 1
//        UIView.animate(withDuration: 0.6, animations: { [weak self] in
//            self?.alpha = 0
//        }) { [weak self] (completed) in
//
//        }
        backgroundColor = .black
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.backgroundColor = .yellow
        }
    }
    
}
