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
    let gemImageView = UIImageView(image: UIImage(imageLiteralResourceName: "yellow_gem"))
    let location: (Int, Int)
    let locationStringValue: String
    //let explosionSheet = UIImage(imageLiteralResourceName: "explosion3")
    
//    let puzzleBackgroundColor: UIColor = CONSTANTS.COLORS.PUZZLE_SQUARE//.black//UIColor(red: 1, green: 1, blue: 100.0/255.0, alpha: 1)
//    let explosionColor: UIColor = CONSTANTS.COLORS.PUZZLE_SQUARE_EXPLOSION
//    let obstacleColor: UIColor = CONSTANTS.COLORS.OBSTACLE
    
    init(currentPuzzle: Puzzle, location: (Int, Int), currentPlayer: Player) {
        self.currentPuzzle = currentPuzzle
        self.currentPlayer = currentPlayer
        self.location = location
        self.locationStringValue = "\(location.0),\(location.1)"
        super.init(frame: .zero)
        backgroundColor = .clear
        
        if isObstacle() {
            let obstacleImageView = currentPlayer.randomMapTheme.getObstacleTileImageView()
            addSubview(obstacleImageView)
            obstacleImageView.constrainFullyToSuperView()
        } else {
            let grassImageView = currentPlayer.randomMapTheme.getCourseTileImageView()
            addSubview(grassImageView)
            grassImageView.constrainFullyToSuperView()
        }
        
        if isSafe() {
            let safeImage = UIImage(imageLiteralResourceName: "safeTileNoBorder")
            let safeImageView = UIImageView(image: safeImage)
            addSubview(safeImageView)
            safeImageView.constrainFullyToSuperView()
        }
        
        if isGemLocation() {
            gemImageView.contentMode = .scaleAspectFit
            addSubview(gemImageView)
            gemImageView.translatesAutoresizingMaskIntoConstraints = false
            gemImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            gemImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            gemImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
            gemImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9).isActive = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isGemLocation() -> Bool {
        return currentPuzzle.isLocationAGem(locationStringValue)
    }
    
    func isSafe() -> Bool {
        return currentPuzzle.isLocationSafe(locationStringValue)
    }
    func isObstacle() -> Bool {
        return currentPuzzle.isLocationAnObstacle(locationStringValue)
    }
    
    func explode() {
        if isSafe() || isObstacle() { return }
    //    let explosionAnimationImageView = currentPlayer.randomMapTheme.getExplosionAnimatedImageView()
    //    addSubview(explosionAnimationImageView)
        //explosionAnimationImageView.startAnimating()
  //      explosionAnimationImageView.constrainFullyToSuperView()
//        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (timer) in
//            explosionAnimationImageView.removeFromSuperview()
//        }
        
        let explosionImage = UIImageView(image: UIImage(imageLiteralResourceName: "explosion0"))
        addSubview(explosionImage)
        explosionImage.constrainFullyToSuperView()
        
//        UIView.animate(withDuration: 0.4, animations: {
//            explosionImage.alpha = 0
//        }) { (completed) in
//            explosionImage.removeFromSuperview()
//        }

        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            explosionImage.alpha = 0
        }) { (completed) in
            explosionImage.removeFromSuperview()
        }
        
//        let explosionView = UIView()
//        explosionView.backgroundColor = .black
//        addSubview(explosionView)
//        explosionView.constrainFullyToSuperView()
//        UIView.animate(withDuration: 0.4, animations: {
//            explosionView.alpha = 0
//        }) { (completed) in
//            explosionView.removeFromSuperview()
//        }
    }
    
}
