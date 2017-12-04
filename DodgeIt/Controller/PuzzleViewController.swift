//
//  PuzzleViewController.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

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
        
        if !PlayerDefaults.shared.userViewedGameInstructions() {
            let howToPlayView = HowToPlayView()
            let applicationView = UIApplication.shared.keyWindow
            applicationView?.addSubview(howToPlayView)
            howToPlayView.constrainFullyToSuperView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(UIScreen.main.bounds.width)
        navigationController?.navigationBar.isHidden = true
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
        if player?.userSkillDelegate == nil {
            player?.userSkillDelegate = self
        }
        let nextLevel = NextPuzzle(puzzle: getNextPuzzleLevelWithDifficulty(1), player: player!)
        nextLevel.puzzleView.puzzleVC = self
        setupPuzzleViewFrame(nextLevel.puzzleView, isFirstLevel: true)
        setupPuzzleProperties(nextLevel)
        
        Analytics.logEvent("player_started_level", parameters: ["level_id":puzzleLevel.puzzleID as NSObject])
    }

    func setupPlayerView(squareData: SquareData, puzzle: Puzzle) {
        if playerView == nil {
            playerView = PlayerView(characterID: player!.selectedSkinID/*"0"*//*CONSTANTS.CHARACTERS.DEFAULT*/, playerSize: 1, puzzle: puzzle, squareData: dataOfSquares, boundingView: currentPuzzleView)
            playerView?.victoryDelegate = self
            playerView?.gemAcquiredDelegate = self
            currentPuzzleView.gridContainerView.player = playerView
            currentPuzzleView.gridContainerView.mainView = currentPuzzleView
            view.addSubview(playerView ?? UIView())
        } else {
            playerView?.setupCharacterImageView(id: player!.selectedSkinID, center: playerView!.center)
        }
    }
    
    func setupPuzzleProperties(_ nextPuzzle: NextPuzzle) {
        puzzleLevel = nextPuzzle.puzzle
        currentPuzzleView = nextPuzzle.puzzleView
        currentPuzzleView.scoreBoardView?.buttonDelegate = self
        currentPuzzleView.arrowPadView.arrowDelegate = self
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
            self!.navigationController?.popViewController(animated: true)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] (timer) in
                self!.currentPuzzleView.removeFromSuperview()
                self!.currentPuzzleView = nil
            }
            //self!.dismiss(animated: true, completion: nil)
        }
    }
    
    func replacePlayerViewWithBloodSplat() {
        if let playerViewExists = playerView {
            let bloodSplatImageView = UIImageView(frame: CGRect(x: playerViewExists.frame.origin.x - 15, y: playerViewExists.frame.origin.y - 15, width: playerViewExists.frame.width * 2, height: playerViewExists.frame.height * 2))
            bloodSplatImageView.image = UIImage(imageLiteralResourceName: "redSplat")
            playerViewExists.removeFromSuperview()
            playerView = nil
            view.addSubview(bloodSplatImageView)
        }
    }

    @objc func didSwipe(_ gesture: UISwipeGestureRecognizer) {
        playerView?.move(gesture.direction)
    }
}

extension PuzzleViewController: VictoryDelegate {
    func playerWonLevel() {
        Analytics.logEvent("player_completed_level", parameters: ["level_id":puzzleLevel.puzzleID as NSObject])
        setupGoogleAdAfterLevelDone()
        player?.playerCompletedCurrent(puzzle: puzzleLevel)
        let nextLevel = NextPuzzle(puzzle: getNextPuzzleLevelWithDifficulty(1), player: player!)
        nextLevel.puzzleView.puzzleVC = self
        setupPuzzleViewFrame(nextLevel.puzzleView, isFirstLevel: false)
        UIView.animate(withDuration: 1.5, animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.currentPuzzleView.frame = CGRect(x: 0, y: weakSelf.view.frame.height, width: weakSelf.view.frame.width, height: weakSelf.view.frame.height)
            nextLevel.puzzleView.frame = CGRect(x: 0, y: 0, width: weakSelf.view.frame.width, height: weakSelf.view.frame.height)
        }) { [weak self] completed in
            self!.currentPuzzleView.removeFromSuperview()
            self!.currentPuzzleView = nil
            print("player won from VC.")
            self!.setupPuzzleProperties(nextLevel)
            self!.playerView?.removeFromSuperview()
            self!.playerView = nil
            self!.setupPlayerView(squareData: nextLevel.squareData, puzzle: nextLevel.puzzle)
        }
    }
    func setupGoogleAdAfterLevelDone() {
//        if let interstitial = googleAd.getInterstitialIfReady() {
//            interstitial.delegate = self
//            interstitial.present(fromRootViewController: self)
//        }
//        googleAd = nil
//        googleAd = GoogleAdService()
//        googleAd.startTimer()
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
        Analytics.logEvent("player_died", parameters: ["level_id":puzzleLevel.puzzleID as NSObject])
        
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

extension PuzzleViewController: ArrowDirectionEventDelegate {
    func didTapArrow(_ direction: ArrowButton.Direction) {
        switch direction {
        case .up:
            playerView?.move(.up)
        case .right:
            playerView?.move(.right)
        case .down:
            playerView?.move(.down)
        case .left:
            playerView?.move(.left)
        }
    }
}

extension PuzzleViewController: ScoreBoardButtonDelegate {
    func tappedMenu() {
        navigationController?.popViewController(animated: true)
    }
    func tappedStore() {
        playerView?.center = playerView!.startingLocation
        let store = CharacterSkinsViewController()
        store.currentPlayer = player
        navigationController?.pushViewController(store, animated: true)
    }
}

extension PuzzleViewController: UserSkillDelegate {
    func userIsNoLongerBeginner() {
        print("woo hoo, a professional NOW!")
        let notABeginnerView = UserIsNotBeginnerView()
        let applicationWindow = UIApplication.shared.keyWindow
        applicationWindow?.addSubview(notABeginnerView)
        notABeginnerView.topAnchor.constraint(equalTo: applicationWindow!.topAnchor, constant: 0).isActive = true
        notABeginnerView.rightAnchor.constraint(equalTo: applicationWindow!.rightAnchor, constant: 0).isActive = true
        notABeginnerView.bottomAnchor.constraint(equalTo: applicationWindow!.bottomAnchor, constant: 0).isActive = true
        notABeginnerView.leftAnchor.constraint(equalTo: applicationWindow!.leftAnchor, constant: 0).isActive = true
    }
}
