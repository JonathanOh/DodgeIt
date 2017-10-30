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
    
    init(currentPuzzle: Puzzle) {
        self.currentPuzzle = currentPuzzle
        self.gridContainerView = GridContainerView(currentPuzzle: currentPuzzle)
        super.init(frame: .zero)
        backgroundColor = .black//UIColor(red: 119.0/255.0, green: 221.0/255.0, blue: 119.0/255.0, alpha: 1)
        setupContainerViewWith(puzzle: currentPuzzle)
        setupLabels()
    }
    
    func setupLabels() {
        currentScoreLabel.text = "Current Score: 123"
        currentScoreLabel.textColor = .white
        currentScoreLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 30.0)
        currentScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currentScoreLabel)
        currentScoreLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        currentScoreLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        currentScoreLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        currentScoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        highScoreLabel.text = "High Score: 1,302"
        highScoreLabel.textColor = .white
        highScoreLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 30.0)
        highScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(highScoreLabel)
        highScoreLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        highScoreLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        highScoreLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        highScoreLabel.bottomAnchor.constraint(equalTo: currentScoreLabel.topAnchor, constant: -7).isActive = true
    }
        
        
    
    
    func setupContainerViewWith(puzzle: Puzzle) {
        addSubview(gridContainerView)
        gridContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        gridContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        gridContainerView.widthAnchor.constraint(equalToConstant: CGFloat(puzzle.totalWidth)).isActive = true
        gridContainerView.heightAnchor.constraint(equalToConstant: CGFloat(puzzle.totalHeight)).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
