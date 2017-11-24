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
//        layer.borderWidth = 1
 //       layer.cornerRadius = CGFloat(currentPuzzle.squareWidth) / 6
//        layer.borderColor = UIColor.getRGBFromArray(currentPlayer.randomMapTheme.backgroundColor)?.cgColor//CONSTANTS.COLORS.BACKGROUND_VIEW.cgColor//UIColor.black.cgColor
        //backgroundColor = isObstacle() ? UIColor.getRGBFromArray(currentPlayer.randomMapTheme.obstacleColor)! : UIColor.getRGBFromArray(currentPlayer.randomMapTheme.courseColor)!//CONSTANTS.COLORS.OBSTACLE : CONSTANTS.COLORS.PUZZLE_SQUARE
        backgroundColor = .clear
        if isSafe() {
            backgroundColor = UIColor.getRGBFromArray(currentPlayer.randomMapTheme.courseColor)//CONSTANTS.COLORS.PUZZLE_CONTAINER_VIEW
            layer.borderWidth = 0
        }
        
        if isObstacle() {
            let woodObstacle = UIImage(imageLiteralResourceName: "crateWood")
            let metalObstacle = UIImage(imageLiteralResourceName: "crateMetal")
            let array = [woodObstacle, metalObstacle]
            let randomNumber = Int(arc4random_uniform(2))
            let obstacleImage = array[randomNumber]
            let obstacleImageView = UIImageView(image: obstacleImage)
            obstacleImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(obstacleImageView)
            obstacleImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            obstacleImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            obstacleImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            obstacleImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        } else {
            let randomNumber = Int(arc4random_uniform(2))
            let grassTileOne = UIImage(imageLiteralResourceName: "tileSand1")
            let grassTileTwo = UIImage(imageLiteralResourceName: "tileSand2")
            let grassCollection = [grassTileOne, grassTileTwo]
            let grassImageView = UIImageView(image: grassCollection[randomNumber])
            grassImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(grassImageView)
            grassImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            grassImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            grassImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            grassImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
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
//        backgroundColor = UIColor.getRGBFromArray(currentPlayer.randomMapTheme.explosionColor)//CONSTANTS.COLORS.PUZZLE_SQUARE_EXPLOSION
//        UIView.animate(withDuration: 0.3, delay: 0.1, options: [UIViewAnimationOptions.allowUserInteraction], animations: { [weak self] in
//            self?.backgroundColor = UIColor.getRGBFromArray(self!.currentPlayer.randomMapTheme.courseColor)//CONSTANTS.COLORS.PUZZLE_SQUARE
//        }, completion: nil)
        let explosion2 = UIImage(imageLiteralResourceName: "explosion2")
        let explosion3 = UIImage(imageLiteralResourceName: "explosion3")
        let explosion4 = UIImage(imageLiteralResourceName: "explosion4")
        let explosion5 = UIImage(imageLiteralResourceName: "explosion5")
        let explosionAnimationImageView = UIImageView()//UIImageView(image: UIImage(imageLiteralResourceName: "explosion3"))
        explosionAnimationImageView.animationImages = [explosion3, explosion2, explosion4, explosion5]
        explosionAnimationImageView.animationRepeatCount = 1
        explosionAnimationImageView.animationDuration = 0.4
        explosionAnimationImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(explosionAnimationImageView)
        explosionAnimationImageView.startAnimating()
        explosionAnimationImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        explosionAnimationImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        explosionAnimationImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        explosionAnimationImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        //layoutIfNeeded()
    }
    
}
