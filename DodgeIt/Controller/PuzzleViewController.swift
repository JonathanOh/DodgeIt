//
//  PuzzleViewController.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController {

    var currentPlayer: PlayerView?
    private var puzzleLevel: Puzzle!
    private var currentPuzzleView: PuzzleView!
    private var dataOfSquares: SquareData!
    let swipeDirections: [UISwipeGestureRecognizerDirection] = [.up, .right, .down, .left]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let testData = PuzzleTestData()
        let widthOfPuzzle: Double = testData.totalWidth * Double(view.frame.width)
        puzzleLevel = Puzzle(difficulty: testData.difficulty, totalWidth: widthOfPuzzle, numberOfCellsInWidth: testData.numberOfCellsInWidth, numberOfCellsInHeight: testData.numberOfCellsInHeight, lengthOfPuzzleCycle: testData.lengthOfPuzzleCycle, obstaclePositions: testData.obstaclePositions, explosionPositionAndTiming: testData.explosionPositionAndTiming)
        currentPuzzleView = PuzzleView(currentPuzzle: puzzleLevel)
        dataOfSquares = currentPuzzleView.gridContainerView.squareData
        view = currentPuzzleView
        //setupPlayer(squareData: dataOfSquares, puzzle: testPuzzle)
        addSwipeGestures(directions: swipeDirections)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPlayer(squareData: dataOfSquares, puzzle: puzzleLevel)
    }
    
    func setupPlayer(squareData: SquareData, puzzle: Puzzle) {
        if currentPlayer != nil { return }
        let bottomLeftSquare = squareData.getSingleSquare((x: 0, y: puzzle.numberOfCellsInHeight - 1))
        //let convertedCenter = bottomLeftSquare?.convert(bottomLeftSquare!.center, to: view)
        let convertedCenter = bottomLeftSquare!.convert(bottomLeftSquare!.center, to: view)
        print(convertedCenter)
        let playerStartingPosition: CGPoint = CGPoint(x: convertedCenter.x /*+ CGFloat(puzzle.squareWidth * 4)*/, y: convertedCenter.y)
        currentPlayer = PlayerView(skin: .cyan, playerSize: 1, position: playerStartingPosition, widthOfPuzzleSquare: puzzle.squareWidth)
        currentPuzzleView.gridContainerView.player = currentPlayer
        currentPuzzleView.gridContainerView.mainView = view
        view.addSubview(currentPlayer!)
    }
    
    func addSwipeGestures(directions: [UISwipeGestureRecognizerDirection]) {
        _ = swipeDirections.map { swipeDirection in
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
            swipeGesture.direction = swipeDirection
            view.addGestureRecognizer(swipeGesture)
        }
    }

    @objc func didSwipe(_ gesture: UISwipeGestureRecognizer) {
        currentPlayer!.move(gesture.direction)
    }
    
}

