//
//  PuzzleView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class PuzzleView: UIView {
    let currentPuzzle: Puzzle
    let gridContainerView: GridContainerView
    let currentScoreLabel = UILabel()
    let highScoreLabel = UILabel()
    let livesRemainingLabel = UILabel()
    let arrowPadView = ArrowPadView()
    
    init(currentPuzzle: Puzzle, player: Player) {
        self.currentPuzzle = currentPuzzle
        self.gridContainerView = GridContainerView(currentPuzzle: currentPuzzle, currentPlayer: player)
        super.init(frame: .zero)
        backgroundColor = .clear
        
        let backgroundImageView = player.randomMapTheme.getBackgroundImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        
        setupContainerViewWith(puzzle: currentPuzzle)
        setupLabels(player)
        //setupArrowPad()
    }
    
    func setupLabels(_ player: Player) {

        currentScoreLabel.text = "Current Score: \(player.currentScore)"
        currentScoreLabel.textColor = .black//UIColor.getRGBFromArray(player.randomMapTheme.labelColors)//CONSTANTS.COLORS.LABEL_COLOR
        currentScoreLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 30.0)
        currentScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currentScoreLabel)
        currentScoreLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        currentScoreLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        currentScoreLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        currentScoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        highScoreLabel.text = "High Score: \(player.highScore)"
        highScoreLabel.textColor = .black//UIColor.getRGBFromArray(player.randomMapTheme.labelColors)//CONSTANTS.COLORS.LABEL_COLOR
        highScoreLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 30.0)
        highScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(highScoreLabel)
        highScoreLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        highScoreLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        highScoreLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        highScoreLabel.bottomAnchor.constraint(equalTo: currentScoreLabel.topAnchor, constant: -7).isActive = true
    }
        
    func updateLivesTo(_ text: Int) {
        //let livesLeft = Int(livesRemainingLabel.text!)!
        livesRemainingLabel.text = "\(text)"
    }
    
    func setupContainerViewWith(puzzle: Puzzle) {
        addSubview(gridContainerView)
        gridContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        //gridContainerView.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height / 10).isActive = true
        //gridContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        gridContainerView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -(CGFloat(currentPuzzle.squareWidth) * 3)).isActive = true
        gridContainerView.widthAnchor.constraint(equalToConstant: CGFloat(puzzle.totalWidth)).isActive = true
        gridContainerView.heightAnchor.constraint(equalToConstant: CGFloat(puzzle.totalHeight)).isActive = true
    }
    
    func setupArrowPad() {
        addSubview(arrowPadView)
        arrowPadView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        arrowPadView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        arrowPadView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35).isActive = true
        arrowPadView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
