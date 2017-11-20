//
//  PuzzleViewController.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PuzzleViewController: UIViewController {

    var player: Player?
    private var playerView: PlayerView?
    private var puzzleLevel: Puzzle!
    private var currentPuzzleView: PuzzleView!
    private var dataOfSquares: SquareData!
    
    private var googleAd: GoogleAdService!
    
    
    let poolOfPossiblePuzzles = PoolOfPossiblePuzzles(viewsWidth: Double(UIScreen.main.bounds.width))
    let swipeDirections: [UISwipeGestureRecognizerDirection] = [.up, .right, .down, .left]
    let playerLostNotification = NSNotification.Name(rawValue: Player.playerLostNotification)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        googleAd = GoogleAdService()
        googleAd.interstitial.delegate = self
        addSwipeGestures(directions: swipeDirections)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPlayerView(squareData: dataOfSquares, puzzle: puzzleLevel)
    }
    
    func newGameSetup() {
        playerView = nil
        puzzleLevel = nil
        currentPuzzleView = nil
        dataOfSquares = nil
        if player == nil {
            player = Player()
        }
        let nextLevel = NextPuzzle(puzzle: getNextPuzzleLevelWithDifficulty(1), player: player!)
        setupPuzzleViewFrame(nextLevel.puzzleView, isFirstLevel: true)
        setupPuzzleProperties(nextLevel)
    }

    func setupPlayerView(squareData: SquareData, puzzle: Puzzle) {
        if playerView == nil {
            playerView = PlayerView(characterID: CONSTANTS.CHARACTERS.DEFAULT, playerSize: 1, puzzle: puzzle, squareData: dataOfSquares, boundingView: currentPuzzleView)
            playerView?.victoryDelegate = self
            playerView?.gemAcquiredDelegate = self
            currentPuzzleView.gridContainerView.player = playerView
            currentPuzzleView.gridContainerView.mainView = currentPuzzleView
            view.addSubview(playerView ?? UIView())
        }
    }
    
    func setupPuzzleProperties(_ nextPuzzle: NextPuzzle) {
        puzzleLevel = nextPuzzle.puzzle
        currentPuzzleView = nextPuzzle.puzzleView
        currentPuzzleView.gridContainerView.playerEventDelegate = self
        dataOfSquares = nextPuzzle.squareData
    }
    
    func setupPuzzleViewFrame(_ puzzleView: PuzzleView, isFirstLevel: Bool) {
        view.addSubview(puzzleView)
        puzzleView.frame = CGRect(x: 0, y: isFirstLevel ? 0 : -view.frame.height, width: view.frame.width, height: view.frame.height)
    }
    
    func getNextPuzzleLevelWithDifficulty(_ difficulty: Int) -> Puzzle {
        if TEST.USER_IS_BEGINNER { return poolOfPossiblePuzzles.getBeginnerPuzzleByID(player!.getNextLevelByID()) }
        if player!.isUserBeginner { return poolOfPossiblePuzzles.getBeginnerPuzzleByID(player!.getNextLevelByID()) }
        return poolOfPossiblePuzzles.getPuzzleByID(player!.getNextLevelByID())
    }
    
    func addSwipeGestures(directions: [UISwipeGestureRecognizerDirection]) {
        _ = swipeDirections.map { swipeDirection in
            let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
            swipeGesture.direction = swipeDirection
            view.addGestureRecognizer(swipeGesture)
        }
    }
    
    func playerLost() {
        print("player lost!!!!")
        replacePlayerViewWithBloodSplat()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] (timer) in
            self!.player!.resetPlayer()
            self!.dismiss(animated: true, completion: nil)
        }
    }
    
    func replacePlayerViewWithBloodSplat() {
        let bloodSplatImageView = UIImageView(frame: CGRect(x: playerView!.frame.origin.x - 15, y: playerView!.frame.origin.y - 15, width: playerView!.frame.width * 2, height: playerView!.frame.height * 2))
        bloodSplatImageView.image = UIImage(imageLiteralResourceName: "redSplat")
        playerView!.removeFromSuperview()
        playerView = nil
        view.addSubview(bloodSplatImageView)
    }

    @objc func didSwipe(_ gesture: UISwipeGestureRecognizer) {
        playerView?.move(gesture.direction)
    }
}

extension PuzzleViewController: VictoryDelegate {
    func playerWonLevel() {
        setupGoogleAdAfterLevelDone()
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
            self!.playerView?.removeFromSuperview()
            self!.playerView = nil
            self!.setupPlayerView(squareData: nextLevel.squareData, puzzle: nextLevel.puzzle)
        }
    }
    func setupGoogleAdAfterLevelDone() {
        googleAd.getInterstitialIfReady()?.present(fromRootViewController: self)
        googleAd = GoogleAdService()
        googleAd.startTimer()
    }
}

extension PuzzleViewController: GemDelegate {
    func playerDidGetGem() {
        print("I GOT THE GEM")
        player?.playerObtainedCoins(1)
    }
}

extension PuzzleViewController: PlayerEventDelegate {

    func playerDied() {
        guard let playerExists = player else { return }
        view.isUserInteractionEnabled = false
        playerExists.playerDied()
        currentPuzzleView.updateLivesTo(playerExists.livesRemaining)
        
        if playerExists.playerLost() {
            playerLost()
            //view.isUserInteractionEnabled = true
            return
        }
        UIView.animate(withDuration: 0.75, animations: { [weak self] in
            self?.playerView?.center = self!.playerView!.startingLocation
        }) { [weak self] (completed) in
            self?.view.isUserInteractionEnabled = true
        }
    }
}

extension PuzzleViewController: GADInterstitialDelegate {
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
        googleAd.startTimer()
    }
}
