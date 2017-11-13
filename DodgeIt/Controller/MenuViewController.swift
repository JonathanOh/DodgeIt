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
//    let highScoreLabel = UILabel()
//    let currentScoreLabel = UILabel()
    
    // play, remove ads, map themes, sounds(jump, die, map win)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //135-206-250
        view.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
        print("im game over bros!")
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews() {
        if currentPlayer != nil {
            let highScoreLabel = UILabel()
            let currentScoreLabel = UILabel()
        
            view.addSubview(highScoreLabel)
            view.addSubview(currentScoreLabel)
        }
        let playButton = UIButton()
        playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
        playButton.setTitle("Play", for: .normal)
        
        let removeAdsButton = UIButton()
        removeAdsButton.addTarget(self, action: #selector(didTapRemoveAds), for: .touchUpInside)
        removeAdsButton.setTitle("Remove Ads", for: .normal)
        
        let mapThemesButton = UIButton()
        mapThemesButton.addTarget(self, action: #selector(didTapMapThemese), for: .touchUpInside)
        mapThemesButton.setTitle("Map Themes", for: .normal)
        
        
        let menuButtonStackView = UIStackView(arrangedSubviews: [playButton, removeAdsButton, mapThemesButton])
        menuButtonStackView.axis = .vertical
    }
    
    func didTapPlay() {
        print("play tapped!")
    }
    func didTapRemoveAds() {
        print("remove ads tapped!")
    }
    func didTapMapThemese() {
        print("map themes tapped!")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        puzzleVC?.newGameSetup(false)
        dismiss(animated: true, completion: nil)
    }
}
