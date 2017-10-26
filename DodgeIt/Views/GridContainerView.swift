//
//  GridContainerView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class GridContainerView: UIView {
    let currentPuzzle: Puzzle
    let squareData: SquareData
    weak var player: PlayerView?
    weak var mainView: UIView?
    
    init(currentPuzzle: Puzzle) {
        self.currentPuzzle = currentPuzzle
        self.squareData = SquareData(matrix: GridContainerView.generateSquareViews(currentPuzzle: currentPuzzle))
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .yellow
        addAllSquareViews(self.squareData.matrix)
        applyExplosions()
    }
    
    static func generateSquareViews(currentPuzzle: Puzzle) -> [[SquareView]] {
        var squareViews = [[SquareView]]()
        for y in 0..<currentPuzzle.numberOfCellsInHeight {
            var squareRow = [SquareView]()
            for x in 0..<currentPuzzle.numberOfCellsInWidth {
                squareRow.append(SquareView(currentPuzzle: currentPuzzle, location: (x, y)))
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
            dispatchExplosions(explosionTimer, positionsOfExplosions: explosionPositions)
        }
    }
    
    func dispatchExplosions(_ delay: Double, positionsOfExplosions: [[Int]]) {
        let explosionDelay = delay * currentPuzzle.lengthOfPuzzleCycle
        DispatchQueue.main.asyncAfter(deadline: .now() + explosionDelay) { [weak self] in
            let squaresToExplode: [SquareView]? = self?.squareData.getSquaresAt(positionsOfExplosions.map { $0.getTupleFromArray()! }) as? [SquareView]
            _ = squaresToExplode?.map { [weak self] square in
                if square.isSafe() || square.isObstacle() { return }
                guard let playerFrame = self!.player else { return }
                let isPlayerInsideExplosiveSquare = square.bounds.intersects(square.convert(playerFrame.bounds, from: playerFrame))
                if isPlayerInsideExplosiveSquare {
                    UIView.animate(withDuration: 0.4, animations: {
                        playerFrame.center = playerFrame.startingLocation
                    })
                    print("player died!")
                }
                square.explode()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + currentPuzzle.lengthOfPuzzleCycle) { [weak self] in
            print("recursive call \(self?.currentPuzzle.lengthOfPuzzleCycle ?? 0)")
            self?.dispatchExplosions(delay, positionsOfExplosions: positionsOfExplosions)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
