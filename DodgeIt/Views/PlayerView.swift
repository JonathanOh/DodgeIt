//
//  PlayerView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/24/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    let puzzle: Puzzle
    let squareData: SquareData
    let startingLocation: CGPoint
    let swipeDirections: [UISwipeGestureRecognizerDirection] = [.up, .right, .down, .left]
    weak private var boundingView: UIView?
    
    init(skin: UIColor, playerSize: Int, puzzle: Puzzle, squareData: SquareData, boundingView: UIView) {
        self.boundingView = boundingView
        self.puzzle = puzzle
        self.squareData = squareData
        let width = puzzle.squareWidth * Double(playerSize)
        let height = puzzle.squareWidth * Double(playerSize)
        self.startingLocation = CGPoint(x: boundingView.center.x + CGFloat(puzzle.squareWidth/2), y: boundingView.center.y + CGFloat(puzzle.squareWidth/2) + CGFloat(puzzle.squareWidth * 7))
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: height)))
        center = startingLocation
        backgroundColor = skin
        layer.cornerRadius = frame.size.width/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(_ direction: UISwipeGestureRecognizerDirection) {
        guard let parentView = boundingView else { return }
        UIView.animate(withDuration: 0.05) { [weak self] in
            guard let weakSelf = self else { return }
            var newCenter = CGPoint()
            switch direction {
            case .up:
                newCenter = CGPoint(x: weakSelf.center.x, y: weakSelf.center.y - CGFloat(weakSelf.puzzle.squareWidth))
            case .right:
                newCenter = CGPoint(x: weakSelf.center.x + CGFloat(weakSelf.puzzle.squareWidth), y: weakSelf.center.y)
            case .down:
                newCenter = CGPoint(x: weakSelf.center.x, y: weakSelf.center.y + CGFloat(weakSelf.puzzle.squareWidth))
            case .left:
                newCenter = CGPoint(x: weakSelf.center.x - CGFloat(weakSelf.puzzle.squareWidth), y: weakSelf.center.y)
            default:
                return
            }
            if parentView.point(inside: newCenter, with: nil) {
                let obstacleTuples = weakSelf.puzzle.obstaclePositions.map { $0.getTupleFromArray()! }
                let obstacleSquares = weakSelf.squareData.getSquaresAt(obstacleTuples)
                // NEED TO CONVERT RECT TO SUPERVIEW TO WORK THIS
                for obstacle in obstacleSquares {
                    print(obstacle!.frame)
                    print(newCenter)
                    if obstacle!.point(inside: newCenter, with: nil) { return }
                }
                weakSelf.center = newCenter
            }
            //if parentView.point(inside: newCenter, with: nil) { weakSelf.center = newCenter }
        }
    }
}
