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
    let squareViewMatrix: [[SquareView]]
    let squareData: SquareData
    
    init(currentPuzzle: Puzzle) {
        self.currentPuzzle = currentPuzzle
        self.squareViewMatrix = GridContainerView.generateSquareViews(currentPuzzle: currentPuzzle)
        self.squareData = SquareData(matrix: self.squareViewMatrix)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
        addAllSquareViews(squareViewMatrix)
        _ = squareViewMatrix.map { $0.map { print($0.location) } }
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
    
    //Create a 2D matrix of SquareViews
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
