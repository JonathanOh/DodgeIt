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
        UIView.animate(withDuration: 1, animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.currentPuzzleView.center = CGPoint(x: weakSelf.currentPuzzleView.center.x, y: weakSelf.currentPuzzleView.center.y * 3)
        }) { completed in
            print("player won from VC")
        }
    }
}
