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
        puzzleLevel = Puzzle(difficulty: testData.difficulty, totalWidth: widthOfPuzzle, numberOfCellsInWidth: testData.numberOfCellsInWidth, numberOfCellsInHeight: testData.numberOfCellsInHeight, lengthOfPuzzleCycle: testData.lengthOfPuzzleCycle, safeHavens: testData.safeHavens, obstaclePositions: testData.obstaclePositions, explosionPositionAndTiming: testData.explosionPositionAndTiming)
        currentPuzzleView = PuzzleView(currentPuzzle: puzzleLevel)
        dataOfSquares = currentPuzzleView.gridContainerView.squareData
        setupPuzzleView()
        addSwipeGestures(directions: swipeDirections)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPlayer(squareData: dataOfSquares, puzzle: puzzleLevel)
    }
    
    func setupPuzzleView() {
        view.addSubview(currentPuzzleView)
        currentPuzzleView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    func setupPlayer(squareData: SquareData, puzzle: Puzzle) {
        if currentPlayer == nil {
            currentPlayer = PlayerView(skin: .red, playerSize: 1, puzzle: puzzle, squareData: dataOfSquares, boundingView: view)
            currentPlayer?.victoryDelegate = self
            currentPuzzleView.gridContainerView.player = currentPlayer
            currentPuzzleView.gridContainerView.mainView = view
            view.addSubview(currentPlayer ?? UIView())
        }
    }
    
    func addSwipeGestures(directions: [UISwipeGestureRecognizerDirection]) {
        _ = swipeDirections.map { swipeDirection in
            let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
            swipeGesture.direction = swipeDirection
            view.addGestureRecognizer(swipeGesture)
        }
    }

    @objc func didSwipe(_ gesture: UISwipeGestureRecognizer) {
        currentPlayer!.move(gesture.direction)
    }
}
// Pick next puzzle getNextPuzzleData() -> Puzzle
// Create Puzzle/PuzzleView/SquareData objects
// Create view and slide in views setupNextLevelView()

extension PuzzleViewController: VictoryDelegate {
    func playerWonLevel() {
        let testData = PuzzleTestDataTwo()
        let widthOfPuzzle: Double = testData.totalWidth * Double(view.frame.width)
        let newLevel = Puzzle(difficulty: testData.difficulty, totalWidth: widthOfPuzzle, numberOfCellsInWidth: testData.numberOfCellsInWidth, numberOfCellsInHeight: testData.numberOfCellsInHeight, lengthOfPuzzleCycle: testData.lengthOfPuzzleCycle, safeHavens: testData.safeHavens, obstaclePositions: testData.obstaclePositions, explosionPositionAndTiming: testData.explosionPositionAndTiming)
        let newView = PuzzleView(currentPuzzle: newLevel)
        newView.backgroundColor = .blue
        let newData = newView.gridContainerView.squareData
        view.addSubview(newView)
        newView.frame = CGRect(x: 0, y: -view.frame.height, width: view.frame.width, height: view.frame.height)
        //view.bringSubview(toFront: newView)
        UIView.animate(withDuration: 1.5, animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.currentPuzzleView.frame = CGRect(x: 0, y: weakSelf.view.frame.height, width: weakSelf.view.frame.width, height: weakSelf.view.frame.height)
            newView.frame = CGRect(x: 0, y: 0, width: weakSelf.view.frame.width, height: weakSelf.view.frame.height)
        }) { [weak self] completed in
            self!.currentPuzzleView.removeFromSuperview()
            print("player won from VC.")
            self!.puzzleLevel = newLevel
            self!.currentPuzzleView = newView
            self!.dataOfSquares = newData
            self!.currentPlayer = nil
            self!.setupPlayer(squareData: newData, puzzle: newLevel)
        }
    }
}
