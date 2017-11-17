//
//  PlayerView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/24/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

protocol VictoryDelegate {
    func playerWonLevel()
}

class PlayerView: UIImageView {
    var victoryDelegate: VictoryDelegate?
    let puzzle: Puzzle
    let squareData: SquareData
    let startingLocation: CGPoint
    let swipeDirections: [UISwipeGestureRecognizerDirection] = [.up, .right, .down, .left]
    weak private var boundingView: UIView?
    
    init(skin: UIColor, playerSize: Int, puzzle: Puzzle, squareData: SquareData, boundingView: PuzzleView) {
        self.boundingView = boundingView
        self.puzzle = puzzle
        self.squareData = squareData
        let width = puzzle.squareWidth * Double(playerSize) * 0.9
        let height = puzzle.squareWidth * Double(playerSize) * 0.9
        self.startingLocation = CGPoint(x: boundingView.center.x + CGFloat(puzzle.squareWidth/2), y: boundingView.center.y + CGFloat(puzzle.squareWidth/2) + CGFloat(puzzle.squareWidth * 7))
        
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: height)))
        center = startingLocation
        backgroundColor = skin
        layer.cornerRadius = frame.size.width/2
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        image = UIImage(imageLiteralResourceName: "smileyMeme")
        contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(_ direction: UISwipeGestureRecognizerDirection) {
        var playerDidWin = false
        UIView.animate(withDuration: 0.05, animations: { [weak self] in
            guard let weakSelf = self else { return }
            guard let parentView = weakSelf.boundingView else { return }
            let newCenter = weakSelf.calculateNewCenterFrom(direction: direction)
            let isNewCenterWithinView = parentView.point(inside: newCenter, with: nil)
            if isNewCenterWithinView {
                if weakSelf.isNewLocationObstacle(newCenter) { return }
                weakSelf.center = newCenter
            } else {
                if direction == .up {
                    playerDidWin = true
                    weakSelf.center = newCenter
                }
            }
        }, completion: { [weak self] completed in
            if playerDidWin { self?.victoryDelegate?.playerWonLevel() }
        })
    }
    
    func calculateNewCenterFrom(direction: UISwipeGestureRecognizerDirection) -> CGPoint {
        switch direction {
        case .up:
            return CGPoint(x: center.x, y: center.y - CGFloat(puzzle.squareWidth))
        case .right:
            return CGPoint(x: center.x + CGFloat(puzzle.squareWidth), y: center.y)
        case .down:
            return CGPoint(x: center.x, y: center.y + CGFloat(puzzle.squareWidth))
        case .left:
            return CGPoint(x: center.x - CGFloat(puzzle.squareWidth), y: center.y)
        default:
            return CGPoint(x: 0, y: 0) // Should never hit this
        }
    }
    
    func isNewLocationObstacle(_ newLocation: CGPoint) -> Bool {
        guard let parentView = boundingView else { return true }
        var obstacleTuples = [(Int, Int)]()
        for (key, _) in puzzle.obstaclePositions {
            if puzzle.isLocationAnObstacle(key) { obstacleTuples.append(key.tupleValue()!) }
        }
        let obstacleSquares = squareData.getSquaresAt(obstacleTuples)
        for obstacle in obstacleSquares { // This is an O(n) look up
            let convertedObstacle = obstacle!.convert(obstacle!.bounds, to: parentView)
            if convertedObstacle.contains(newLocation) { return true }
        }
        return false
    }
}
