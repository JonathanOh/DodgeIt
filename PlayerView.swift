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
protocol GemDelegate {
    func playerDidGetGem()
}

class PlayerView: UIView {
    var victoryDelegate: VictoryDelegate?
    var gemAcquiredDelegate: GemDelegate?
    let puzzle: Puzzle
    let squareData: SquareData
    let startingLocation: CGPoint
    let swipeDirections: [UISwipeGestureRecognizerDirection] = [.up, .right, .down, .left]
    private var characterImageView = CharacterImageView(characterID: "0")
    let characterID: String
    weak private var boundingView: UIView?
    
    init(characterID: String, playerSize: Int, puzzle: Puzzle, squareData: SquareData, boundingView: PuzzleView) {
        self.characterID = characterID
        self.boundingView = boundingView
        self.puzzle = puzzle
        self.squareData = squareData
        let width = puzzle.squareWidth * Double(playerSize) * 0.9
        let height = puzzle.squareWidth * Double(playerSize) * 0.9
        self.startingLocation = CGPoint(x: boundingView.center.x + CGFloat(puzzle.squareWidth/2), y: boundingView.center.y + CGFloat(puzzle.squareWidth/2) + CGFloat(puzzle.squareWidth * 5))
        
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: height)))
        center = startingLocation

        characterImageView = CharacterImageView(characterID: characterID)
        let character = PoolOfPossibleCharacters.shared.getCharacterByID(characterID)!
        addSubview(characterImageView)
        characterImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: CGFloat(character.yOffsetConstant)).isActive = true
        characterImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CGFloat(character.widthMultiplier)).isActive = true
        characterImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: CGFloat(character.heightMultiplier)).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(_ direction: UISwipeGestureRecognizerDirection) {
        var playerDidWin = false
        characterImageView.readjustImageAccordingTo(swipeDirection: direction)
        //characterImageView.animateImageViewFor(0.40)
        
        UIView.animate(withDuration: 0.05, animations: { [weak self] in
            guard let weakSelf = self else { return }
            guard let parentView = weakSelf.boundingView else { return }
            let newCenter = weakSelf.calculateNewCenterFrom(direction: direction)
            let isNewCenterWithinView = parentView.point(inside: newCenter, with: nil)
            if isNewCenterWithinView {
                if weakSelf.isNewLocationObstacle(newCenter) { return }
                if let gemSquare = weakSelf.getSquareViewIfContainsGem(newCenter) {
                    if !gemSquare.gemImageView.isHidden {
                        gemSquare.gemImageView.isHidden = true
                        weakSelf.gemAcquiredDelegate?.playerDidGetGem()
                    }
                }
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
    
    func getSquareViewIfContainsGem(_ newLocation: CGPoint) -> SquareView? {
        guard let parentView = boundingView else { return nil }
        var gemLocationTuples = [(Int, Int)]()
        for (key, _) in puzzle.gemPositions {
            if puzzle.isLocationAGem(key) { gemLocationTuples.append(key.tupleValue()!) }
        }
        let gemSquares = squareData.getSquaresAt(gemLocationTuples)
        for gem in gemSquares {
            let convertedGemLocation = gem!.convert(gem!.bounds, to: parentView)
            if convertedGemLocation.contains(newLocation) {
                return gem
            }
        }
        return nil
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
