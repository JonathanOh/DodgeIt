//
//  PuzzleViewController.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController {

    private var player: Player?
    private var playerView: PlayerView?
    private var puzzleLevel: Puzzle!
    private var currentPuzzleView: PuzzleView!
    private var dataOfSquares: SquareData!
    
    let poolOfPossiblePuzzles = PoolOfPossiblePuzzles(viewsWidth: Double(UIScreen.main.bounds.width))
    let swipeDirections: [UISwipeGestureRecognizerDirection] = [.up, .right, .down, .left]
    let playerLostNotification = NSNotification.Name(rawValue: Player.playerLostNotification)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupPlayer()
        let nextLevel = NextPuzzle(puzzle: getNextPuzzleLevelWithDifficulty(1), player: player!)
        setupPuzzleViewFrame(nextLevel.puzzleView, isFirstLevel: true)
        setupPuzzleProperties(nextLevel)
        addSwipeGestures(directions: swipeDirections)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(playerLost), name: playerLostNotification, object: nil)
        setupPlayerView(squareData: dataOfSquares, puzzle: puzzleLevel)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: playerLostNotification, object: nil)
    }
    
    func setupPlayer() {
        player = Player(currentScore: PlayerDummyData.currentScore, highScore: PlayerDummyData.highScore, livesRemaining: PlayerDummyData.livesRemaining, poolOfPuzzlesByID: poolOfPossiblePuzzles.possiblePuzzles, completedPuzzlesByID: [])
    }
    func setupPlayerView(squareData: SquareData, puzzle: Puzzle) {
        if playerView == nil {
            playerView = PlayerView(skin: .red, playerSize: 1, puzzle: puzzle, squareData: dataOfSquares, boundingView: currentPuzzleView)
            playerView?.victoryDelegate = self
            currentPuzzleView.gridContainerView.player = playerView
            currentPuzzleView.gridContainerView.mainView = currentPuzzleView
            view.addSubview(playerView ?? UIView())
        }
    }
    
    func setupPuzzleProperties(_ nextPuzzle: NextPuzzle) {
        puzzleLevel = nextPuzzle.puzzle
        currentPuzzleView = nextPuzzle.puzzleView
        currentPuzzleView.gridContainerView.playerRespawnDelegate = self
        dataOfSquares = nextPuzzle.squareData
    }
    
    func setupPuzzleViewFrame(_ puzzleView: PuzzleView, isFirstLevel: Bool) {
        view.addSubview(puzzleView)
        puzzleView.frame = CGRect(x: 0, y: isFirstLevel ? 0 : -view.frame.height, width: view.frame.width, height: view.frame.height)
    }
    
    func getNextPuzzleLevelWithDifficulty(_ difficulty: Int) -> Puzzle {
        return poolOfPossiblePuzzles.getPuzzleByID(player!.getNextLevelByID())
    }
    
    func addSwipeGestures(directions: [UISwipeGestureRecognizerDirection]) {
        _ = swipeDirections.map { swipeDirection in
            let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
            swipeGesture.direction = swipeDirection
            view.addGestureRecognizer(swipeGesture)
        }
    }
    
    @objc func playerLost() {
        print("player lost!!!!")
    }

    @objc func didSwipe(_ gesture: UISwipeGestureRecognizer) {
        playerView!.move(gesture.direction)
    }
}

extension PuzzleViewController: VictoryDelegate {
    func playerWonLevel() {
        player?.playerCompletedCurrent(puzzle: puzzleLevel)
        let nextLevel = NextPuzzle(puzzle: getNextPuzzleLevelWithDifficulty(1), player: player!)
        setupPuzzleViewFrame(nextLevel.puzzleView, isFirstLevel: false)
        UIView.animate(withDuration: 1.5, animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.currentPuzzleView.frame = CGRect(x: 0, y: weakSelf.view.frame.height, width: weakSelf.view.frame.width, height: weakSelf.view.frame.height)
            nextLevel.puzzleView.frame = CGRect(x: 0, y: 0, width: weakSelf.view.frame.width, height: weakSelf.view.frame.height)
        }) { [weak self] completed in
            self!.currentPuzzleView.removeFromSuperview()
            print("player won from VC.")
            self!.setupPuzzleProperties(nextLevel)
            self!.playerView = nil
            self!.setupPlayerView(squareData: nextLevel.squareData, puzzle: nextLevel.puzzle)
        }
    }
}

extension PuzzleViewController: PlayerRespawnEventDelegate {
    func playerIsRespawning() {
        view.isUserInteractionEnabled = false
    }
    func playerRespawned() {
        player?.playerDied()
        print("Player Lives Remaining: \(player?.livesRemaining ?? 0)")
        view.isUserInteractionEnabled = true
    }
}
