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
        //setupPlayer(squareData: dataOfSquares, puzzle: testPuzzle)
        addSwipeGestures(directions: swipeDirections)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPlayer(squareData: dataOfSquares, puzzle: puzzleLevel)
    }
    
    func setupPuzzleView() {
        currentPuzzleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentPuzzleView)
        currentPuzzleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        currentPuzzleView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        currentPuzzleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        currentPuzzleView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
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

extension PuzzleViewController: VictoryDelegate {
    func playerWonLevel() {
        let testData = PuzzleTestData()
        let widthOfPuzzle: Double = testData.totalWidth * Double(view.frame.width)
        let newLevel = Puzzle(difficulty: testData.difficulty, totalWidth: widthOfPuzzle, numberOfCellsInWidth: testData.numberOfCellsInWidth, numberOfCellsInHeight: testData.numberOfCellsInHeight, lengthOfPuzzleCycle: 1, safeHavens: testData.safeHavens, obstaclePositions: testData.obstaclePositions, explosionPositionAndTiming: testData.explosionPositionAndTiming)
        let newView = PuzzleView(currentPuzzle: newLevel)
        let newData = newView.gridContainerView.squareData
        newView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newView)
        newView.widthAnchor.constraint(equalToConstant: currentPuzzleView.frame.width).isActive = true
        newView.heightAnchor.constraint(equalToConstant: currentPuzzleView.frame.height).isActive = true
        newView.centerXAnchor.constraint(equalTo: currentPuzzleView.centerXAnchor).isActive = true
        newView.bottomAnchor.constraint(equalTo: currentPuzzleView.topAnchor).isActive = true
        
        UIView.animate(withDuration: 1, animations: { [weak self] in
            guard let weakSelf = self else { return }
            newView.center = CGPoint(x: newView.center.x, y: newView.center.y * 3)
            weakSelf.currentPuzzleView.center = CGPoint(x: weakSelf.currentPuzzleView.center.x, y: weakSelf.currentPuzzleView.center.y * 3)
        }) { [weak self] completed in
            self!.currentPuzzleView.removeFromSuperview()
            print("player won from VC.")
            self!.puzzleLevel = newLevel
            self!.currentPuzzleView = newView
            self!.dataOfSquares = newData
        }
    }
}
