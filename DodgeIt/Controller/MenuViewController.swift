//
//  MenyViewController.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/30/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit
import LocalAuthentication
import Firebase

class MenuViewController: UIViewController {

    let localAuthentication = LAContext()
    
    var feedbackView: FeedbackClearBackgroundView?
    private var puzzleVC: PuzzleViewController?
    var currentPlayer: Player?
    
    private var playButtonTitle: String = "Play"
    private let playButton = MenuButton(target: self, action: #selector(didTapPlay), buttonTitle: "Play", buttonImage: nil)
    
    private let characterSkinButton = MenuButton(target: self, action: #selector(didTapCharacterSkin), buttonTitle: "", buttonImage: UIImage(imageLiteralResourceName: "yellow_gem"))
    
    private let highScoreLabel = UILabel()
    private let currentScoreLabel = UILabel()
    private let coinView = CoinView(numberOfCoins: 0, textFont: nil, fontColor: nil)
    
    let titleLabel = UILabel()
    
    // play, remove ads, map themes, sounds(jump, die, map win)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //135-206-250
        view.backgroundColor = CONSTANTS.COLORS.MENU_BUTTONS
        print("im game over bros!")
        // Do any additional setup after loading the view.
        setupPlayer()
        setupViews()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in
            guard let strongSelf = self else { return }
            if type == .purchased {
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { alert in
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        updatePlayButton()
        updateCurrentScoreLabel()
        updateCurrentGemCount()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coinView.removeFromSuperview()
    }
    
    func setupPlayer() {
        currentPlayer = Player()
    }
    
    func updateCurrentScoreLabel() {
        let currentScore = PlayerDefaults.shared.getCurrentScore()
        let highScore = PlayerDefaults.shared.getHighScore()
        currentScoreLabel.text = currentScore == 0 ? "" : "Current Score: \(currentScore)"
        highScoreLabel.text = highScore == 0 ? "" : "High Score: \(highScore)"
    }
    
    func updateCurrentGemCount() {
        if CONSTANTS.DEVICE_SIZE.IS_SHORT_HEIGHT { return }
        let coinCount = PlayerDefaults.shared.getPlayerCoins()
        coinView.updateCoinCount(coinCount)
        if let playerExists = currentPlayer {
            view.addSubview(coinView)
            var xOffset = CGFloat()
            let offsetUnit = view.frame.width / 25
            
            if playerExists.playerCoins < 10 {
                xOffset = -(offsetUnit * 3)
            } else if playerExists.playerCoins < 100 {
                xOffset = -(offsetUnit * 2)
            } else if playerExists.playerCoins < 1000 {
                xOffset = -offsetUnit
            } else if playerExists.playerCoins < 10000 {
                xOffset = 0
            } else {
                xOffset = offsetUnit
            }
//            else if playerExists.playerCoins < 10000 {
//                xOffset = offsetUnit * 2
//            } else {
//                xOffset = offsetUnit * 3
//            }
            print(xOffset)
            coinView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
            coinView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            coinView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: CGFloat(xOffset)).isActive = true
            coinView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        }
    }
    
    func setupViews() {
        setupTitleLabel()
        if currentPlayer != nil {
            let highScoreLabel = UILabel()
            let currentScoreLabel = UILabel()
            view.addSubview(highScoreLabel)
            view.addSubview(currentScoreLabel)
        }
        setupMenuButtons()
    }
    
    func setupTitleLabel() {
        //let titleLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Splodey Bound"
        titleLabel.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 65)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.heightAnchor.constraint(equalToConstant: 110).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height/13/*50*/).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    func updatePlayButton() {
        let currentGameExists = PlayerDefaults.shared.getCurrentScore() > 0
        playButtonTitle = currentGameExists ? "Continue" : "New Game"
        playButton.setTitle(playButtonTitle, for: .normal)
    }
    
    func setupMenuButtons() {
        updatePlayButton()
        //let removeAdsButton = MenuButton(target: self, action: #selector(didTapRemoveAds), buttonTitle: "Remove Ads", buttonImage: nil)
        
        let menuButtonStackView = UIStackView(arrangedSubviews: [playButton, /*removeAdsButton,*/ characterSkinButton])
        menuButtonStackView.axis = .vertical
        menuButtonStackView.alignment = .center
        menuButtonStackView.distribution = .equalSpacing
        
        menuButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuButtonStackView)
        
        menuButtonStackView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        menuButtonStackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        menuButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        menuButtonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height/5)).isActive = true
        
        setupScoreLabels()
        
        setupBottomMenuButton()
    }
    
    func setupBottomMenuButton() {
        let shareButton = UIButton()
        shareButton.setImage(UIImage(imageLiteralResourceName: "share"), for: .normal)
        //shareButton.backgroundColor = .black
        shareButton.addTarget(self, action: #selector(didTapShareApp), for: .touchUpInside)
        view.addSubview(shareButton)
        shareButton.constrainWidthTo(dimension: view.widthAnchor, multiplier: 1/10)
        shareButton.constrainHeightTo(dimension: view.widthAnchor, multiplier: 1/10)
        shareButton.constrainCenterXTo(anchor: view.centerXAnchor)
        shareButton.constrainBottomTo(anchor: view.bottomAnchor, constant: -15)
        
        let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        
        let removeAdsAttributedTitle = NSAttributedString(string: "Remove Ads", attributes: underlineAttribute)
        let removeAdsButton = UIButton()
        removeAdsButton.addTarget(self, action: #selector(didTapRemoveAds), for: .touchUpInside)
        removeAdsButton.backgroundColor = CONSTANTS.COLORS.MENU_BUTTONS
        removeAdsButton.setTitleColor(.black, for: .normal)
        removeAdsButton.setAttributedTitle(removeAdsAttributedTitle, for: .normal)
        view.addSubview(removeAdsButton)
        removeAdsButton.constrainRightTo(anchor: view.rightAnchor, constant: -8)
        //removeAdsButton.constrainBottomTo(anchor: view.bottomAnchor, constant: -15)
        removeAdsButton.constrainCenterYTo(anchor: shareButton.centerYAnchor, constant: 2)
        removeAdsButton.constrainWidthTo(dimension: view.widthAnchor, multiplier: 1/3)
        removeAdsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let rateUsAttributedTitle = NSAttributedString(string: "Feedback", attributes: underlineAttribute)
        let rateUsButton = UIButton()
        rateUsButton.addTarget(self, action: #selector(didTapFeedback), for: .touchUpInside)
        rateUsButton.backgroundColor = CONSTANTS.COLORS.MENU_BUTTONS
        rateUsButton.setTitleColor(.black, for: .normal)
        rateUsButton.setAttributedTitle(rateUsAttributedTitle, for: .normal)
        view.addSubview(rateUsButton)
        rateUsButton.constrainLeftTo(anchor: view.leftAnchor, constant: 8)
        //rateUsButton.constrainBottomTo(anchor: view.bottomAnchor, constant: -15)
        rateUsButton.constrainCenterYTo(anchor: shareButton.centerYAnchor, constant: 2)
        rateUsButton.constrainWidthTo(dimension: view.widthAnchor, multiplier: 1/3)
        rateUsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupScoreLabels() {
        currentScoreLabel.textAlignment = .center
        currentScoreLabel.backgroundColor = .black
        currentScoreLabel.textColor = .white
        currentScoreLabel.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 40.0)
        view.addSubview(currentScoreLabel)
        currentScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        currentScoreLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        currentScoreLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        currentScoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        currentScoreLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -35).isActive = true
        
        highScoreLabel.textAlignment = .center
        highScoreLabel.backgroundColor = .black
        highScoreLabel.textColor = .white
        highScoreLabel.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 40.0)
        view.addSubview(highScoreLabel)
        highScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highScoreLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        highScoreLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        highScoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        highScoreLabel.bottomAnchor.constraint(equalTo: currentScoreLabel.topAnchor, constant: -10).isActive = true
        
    }
    
    @objc func didTapCharacterSkin() {
        let characterSkinViewController = CharacterSkinsViewController()
        characterSkinViewController.currentPlayer = currentPlayer
        navigationController?.pushViewController(characterSkinViewController, animated: true)
    }
    
    @objc func didTapPlay() {
        print("play tapped!")
        Analytics.logEvent("player_tapped_store_from_menu", parameters: [:])
        puzzleVC = PuzzleViewController()
        puzzleVC?.player = currentPlayer
        puzzleVC?.newGameSetup()
        navigationController?.pushViewController(puzzleVC!, animated: true)
        //present(puzzleVC!, animated: true, completion: nil)
    }
    @objc func didTapRemoveAds() {
        print("remove ads tapped!")
        let loadingView = FullPageLoadingIndicator(viewController: self)
        loadingView.startLoading()
        IAPHandler.shared.purchaseMyProduct(productIdentifier: "adRemovalPurchase")
        IAPHandler.shared.purchaseStatusBlock = { purchaseType in
            loadingView.stopLoading()
        }
    }
    @objc func didTapFeedback() {
//        Analytics.logEvent("player_tapped_feedback", parameters: [:])
//        AppDelegate.rateApp(appId: CONSTANTS.APP_APPLE_ID) { (completed) in
//            print("success!! on tapping feedback app!")
//        }
        print("feedback tapped")
        feedbackView = FeedbackClearBackgroundView()
        let applicationWindow = UIApplication.shared.keyWindow
        applicationWindow?.addSubview(feedbackView!)
        feedbackView!.constrainFullyToSuperView()
        feedbackView!.fadeInFeedbackView()
    }
    @objc func didTapShareApp() {
        //Analytics.logEvent("player_tapped_share", parameters: [:])
        print("tapped share")
        let activityViewController = UIActivityViewController(activityItems: ["Hey! checkout \(CONSTANTS.APP_STORE_LINK)"], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    @objc func didTapMapThemese() {
        print("map themes tapped!")
    }
}
