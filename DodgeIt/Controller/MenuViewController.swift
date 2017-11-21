//
//  MenyViewController.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/30/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    private var puzzleVC: PuzzleViewController?
    var currentPlayer: Player?
    
    private var playButtonTitle: String = "Play"
    private let playButton = MenuButton(target: self, action: #selector(didTapPlay), buttonTitle: "Play")
    
    private let highScoreLabel = UILabel()
    private let currentScoreLabel = UILabel()
    private let coinView = CoinView(numberOfCoins: 0)
    
    let titleLabel = UILabel()
    
    // play, remove ads, map themes, sounds(jump, die, map win)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //135-206-250
        view.backgroundColor = .black
        print("im game over bros!")
        // Do any additional setup after loading the view.
        setupPlayer()
        setupViews()
        
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
        updatePlayButton()
        updateCurrentScoreLabel()
        updateCurrentGemCount()
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
        let coinCount = PlayerDefaults.shared.getPlayerCoins()
        coinView.updateCoinCount(coinCount)
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
        titleLabel.text = "Splodey Blocks"
        titleLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 50)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.heightAnchor.constraint(equalToConstant: 110).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        if let _ = currentPlayer {
            view.addSubview(coinView)
            coinView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
            coinView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            coinView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            coinView.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        }
    }
    
    func updatePlayButton() {
        let currentGameExists = PlayerDefaults.shared.getCurrentScore() > 0
        playButtonTitle = currentGameExists ? "Continue" : "New Game"
        playButton.setTitle(playButtonTitle, for: .normal)
    }
    
    func setupMenuButtons() {
        updatePlayButton()
        let removeAdsButton = MenuButton(target: self, action: #selector(didTapRemoveAds), buttonTitle: "Remove Ads")
        
        let menuButtonStackView = UIStackView(arrangedSubviews: [playButton, removeAdsButton])
        menuButtonStackView.axis = .vertical
        menuButtonStackView.alignment = .center
        menuButtonStackView.distribution = .equalSpacing
        
        menuButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuButtonStackView)
        
        menuButtonStackView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        menuButtonStackView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        menuButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        menuButtonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        setupScoreLabels()
    }
    
    func setupScoreLabels() {
        currentScoreLabel.textAlignment = .center
        currentScoreLabel.textColor = .white
        currentScoreLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 30.0)
        view.addSubview(currentScoreLabel)
        currentScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        currentScoreLabel.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        currentScoreLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        currentScoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        currentScoreLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -45).isActive = true
        
        highScoreLabel.textAlignment = .center
        highScoreLabel.textColor = .white
        highScoreLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 30.0)
        view.addSubview(highScoreLabel)
        highScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highScoreLabel.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        highScoreLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        highScoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        highScoreLabel.bottomAnchor.constraint(equalTo: currentScoreLabel.topAnchor, constant: -10).isActive = true
        
    }
    
    @objc func didTapPlay() {
        print("play tapped!")
        puzzleVC = PuzzleViewController()
        puzzleVC?.player = currentPlayer
        puzzleVC?.newGameSetup()
        present(puzzleVC!, animated: true, completion: nil)
    }
    @objc func didTapRemoveAds() {
        print("remove ads tapped!")
        IAPHandler.shared.purchaseMyProduct(index: 0)
    }
    @objc func didTapMapThemese() {
        print("map themes tapped!")
    }
}
