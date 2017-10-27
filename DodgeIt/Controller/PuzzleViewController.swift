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
        let nextLevel = NextPuzzle(puzzle: getNextPuzzleLevelWithDifficulty(1))
        setupPuzzleViewFrame(nextLevel.puzzleView, isFirstLevel: true)
        setupPuzzleProperties(nextLevel)
        addSwipeGestures(directions: swipeDirections)
        
        let puzzles = PoolOfPossiblePuzzles()
        _ = puzzles.possiblePuzzles.map {
            print($0.lengthOfPuzzleCycle)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPlayer(squareData: dataOfSquares, puzzle: puzzleLevel)
    }
    
    func setupPuzzleProperties(_ nextPuzzle: NextPuzzle) {
        puzzleLevel = nextPuzzle.puzzle
        currentPuzzleView = nextPuzzle.puzzleView
        dataOfSquares = nextPuzzle.squareData
    }
    
    func setupPuzzleViewFrame(_ puzzleView: PuzzleView, isFirstLevel: Bool) {
        view.addSubview(puzzleView)
        puzzleView.frame = CGRect(x: 0, y: isFirstLevel ? 0 : -view.frame.height, width: view.frame.width, height: view.frame.height)
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
    
    func getNextPuzzleLevelWithDifficulty(_ difficulty: Int) -> Puzzle {
        let randomNum = Int(arc4random_uniform(UInt32(2)))
        let puzzleOne = PuzzleTestData()
        let puzzleTwo = PuzzleTestDataTwo()
        let puzzleWidth = puzzleOne.totalWidth * Double(view.frame.width)
        switch randomNum {
        case 0:
            return Puzzle(difficulty: puzzleOne.difficulty, totalWidth: puzzleWidth, numberOfCellsInWidth: puzzleOne.numberOfCellsInWidth, numberOfCellsInHeight: puzzleOne.numberOfCellsInHeight, lengthOfPuzzleCycle: puzzleOne.lengthOfPuzzleCycle, safeHavens: puzzleOne.safeHavens, obstaclePositions: puzzleOne.obstaclePositions, explosionPositionAndTiming: puzzleOne.explosionPositionAndTiming)
        case 1:
            return Puzzle(difficulty: puzzleTwo.difficulty, totalWidth: puzzleWidth, numberOfCellsInWidth: puzzleTwo.numberOfCellsInWidth, numberOfCellsInHeight: puzzleTwo.numberOfCellsInHeight, lengthOfPuzzleCycle: puzzleTwo.lengthOfPuzzleCycle, safeHavens: puzzleTwo.safeHavens, obstaclePositions: puzzleTwo.obstaclePositions, explosionPositionAndTiming: puzzleTwo.explosionPositionAndTiming)
        default:
            return Puzzle(difficulty: puzzleOne.difficulty, totalWidth: puzzleWidth, numberOfCellsInWidth: puzzleOne.numberOfCellsInWidth, numberOfCellsInHeight: puzzleOne.numberOfCellsInHeight, lengthOfPuzzleCycle: puzzleOne.lengthOfPuzzleCycle, safeHavens: puzzleOne.safeHavens, obstaclePositions: puzzleOne.obstaclePositions, explosionPositionAndTiming: puzzleOne.explosionPositionAndTiming)
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

extension PuzzleViewController: VictoryDelegate {
    func playerWonLevel() {
        let nextLevel = NextPuzzle(puzzle: getNextPuzzleLevelWithDifficulty(1))
        setupPuzzleViewFrame(nextLevel.puzzleView, isFirstLevel: false)
        UIView.animate(withDuration: 1.5, animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.currentPuzzleView.frame = CGRect(x: 0, y: weakSelf.view.frame.height, width: weakSelf.view.frame.width, height: weakSelf.view.frame.height)
            nextLevel.puzzleView.frame = CGRect(x: 0, y: 0, width: weakSelf.view.frame.width, height: weakSelf.view.frame.height)
        }) { [weak self] completed in
            self!.currentPuzzleView.removeFromSuperview()
            print("player won from VC.")
            self!.setupPuzzleProperties(nextLevel)
            self!.currentPlayer = nil
            self!.setupPlayer(squareData: nextLevel.squareData, puzzle: nextLevel.puzzle)
        }
    }
}
