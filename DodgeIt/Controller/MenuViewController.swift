//
//  MenyViewController.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/30/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    weak var puzzleVC: PuzzleViewController?
    var currentPlayer: Player?
    let titleLabel = UILabel()
    
    // play, remove ads, map themes, sounds(jump, die, map win)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //135-206-250
        view.backgroundColor = .black
        print("im game over bros!")
        // Do any additional setup after loading the view.
        setupViews()
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
        titleLabel.text = "Dodge Block"
        titleLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 50)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    func setupMenuButtons() {
        let playButton = MenuButton(target: self, action: #selector(didTapPlay), buttonTitle: "Play")
        let removeAdsButton = MenuButton(target: self, action: #selector(didTapRemoveAds), buttonTitle: "Remove Ads")
        let mapThemesButton = MenuButton(target: self, action: #selector(didTapMapThemese), buttonTitle: "Map Themes")
        
        let menuButtonStackView = UIStackView(arrangedSubviews: [playButton, removeAdsButton, mapThemesButton])
        menuButtonStackView.axis = .vertical
        menuButtonStackView.alignment = .center
        menuButtonStackView.distribution = .equalSpacing
        
        menuButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuButtonStackView)
        
        menuButtonStackView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        menuButtonStackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        menuButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        menuButtonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    
    @objc func didTapPlay() {
        print("play tapped!")
        puzzleVC?.newGameSetup(false)
        dismiss(animated: true, completion: nil)
    }
    @objc func didTapRemoveAds() {
        print("remove ads tapped!")
    }
    @objc func didTapMapThemese() {
        print("map themes tapped!")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //puzzleVC?.newGameSetup(false)
        //dismiss(animated: true, completion: nil)
    }
}
