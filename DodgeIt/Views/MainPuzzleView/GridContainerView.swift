//
//  GridContainerView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

protocol PlayerEventDelegate {
    func playerDied()
}

class GridContainerView: UIView {
    let currentPuzzle: Puzzle
    let currentPlayer: Player
    let squareData: SquareData
    var playerEventDelegate: PlayerEventDelegate?
    weak var player: PlayerView?
    weak var mainView: PuzzleView?
    private var isCurrentlyInBackground: Bool = false
    
    init(currentPuzzle: Puzzle, currentPlayer: Player) {
        self.currentPuzzle = currentPuzzle
        self.currentPlayer = currentPlayer
        self.squareData = SquareData(matrix: GridContainerView.generateSquareViews(currentPuzzle: currentPuzzle, currentPlayer: currentPlayer))
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        //backgroundColor = UIColor.getRGBFromArray(currentPlayer.randomMapTheme.courseColor)
        backgroundColor = .clear
        addAllSquareViews(self.squareData.matrix)
        applyExplosions()
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didEnterBackground() { isCurrentlyInBackground = true }
    @objc func didEnterForeground() { isCurrentlyInBackground = false }
    
    static func generateSquareViews(currentPuzzle: Puzzle, currentPlayer: Player) -> [[SquareView]] {
        var squareViews = [[SquareView]]()
        for y in 0..<currentPuzzle.numberOfCellsInHeight {
            var squareRow = [SquareView]()
            for x in 0..<currentPuzzle.numberOfCellsInWidth {
                squareRow.append(SquareView(currentPuzzle: currentPuzzle, location: (x, y), currentPlayer: currentPlayer))
            }
            squareViews.append(squareRow)
        }
        return squareViews
    }
    
    func addAllSquareViews(_ nestedSquares: [[SquareView]]) {
        var stackArray = [UIStackView]()
        for squares in nestedSquares {
            let squareStack = UIStackView(arrangedSubviews: squares)
            squareStack.axis = .horizontal
            squareStack.distribution = .fillEqually
            squareStack.spacing = 0.0
            squareStack.alignment = .fill
            stackArray.append(squareStack)
        }
        let mainSquareStack = UIStackView(arrangedSubviews: stackArray)
        mainSquareStack.axis = .vertical
        mainSquareStack.distribution = .fillEqually
        mainSquareStack.spacing = 0.0
        mainSquareStack.alignment = .fill
        mainSquareStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainSquareStack)

        mainSquareStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainSquareStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainSquareStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mainSquareStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }

    func applyExplosions() {
        for (explosionTimer, explosionPositions) in currentPuzzle.explosionPositionAndTiming {
            dispatchExplosions(Int(explosionTimer)!, positionsOfExplosions: explosionPositions)
        }
    }
    
    func dispatchExplosions(_ delay: Int, positionsOfExplosions: [[Int]]) {
        let explosionDelay = Double(delay)/Double(1000) * currentPuzzle.lengthOfPuzzleCycle
        Timer.scheduledTimer(withTimeInterval: explosionDelay, repeats: false) { [weak self] (timer) in
            if self?.isCurrentlyInBackground ?? true { return }
            let squaresToExplode: [SquareView]? = self?.squareData.getSquaresAt(positionsOfExplosions.map { $0.getTupleFromArray()! }) as? [SquareView]
            _ = squaresToExplode?.map { [weak self] square in
                if square.isSafe() || square.isObstacle() { return }
//                if let playerFrame = self?.player {
//                    let isPlayerInsideExplosiveSquare = square.bounds.intersects(square.convert(playerFrame.bounds, from: playerFrame))
//                    if isPlayerInsideExplosiveSquare { self?.playerEventDelegate?.playerDied() }
//                }
                square.explode()
            }
        }
        Timer.scheduledTimer(withTimeInterval: currentPuzzle.lengthOfPuzzleCycle, repeats: false) { [weak self] (timer) in
            self?.dispatchExplosions(delay, positionsOfExplosions: positionsOfExplosions)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
