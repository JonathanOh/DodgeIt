//
//  FeedbackContainerView.swift
//  DodgeIt
//
//  Created by admin on 11/28/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class FeedbackContainerView: UIView {

    enum FeedbackOption: String {
        case loveThisGame = "I love this game!"
        case issues = "Ran into some issues"
        case suggestions = "Suggestions"
        case thisGameSucks = "This game sucks!"
    }
    
    let feedbackOptions: [FeedbackOption] = [.loveThisGame, .issues, .suggestions, .thisGameSucks]
    let titleLabel = UILabel()
    let feedbackTableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .red
        layer.cornerRadius = 5
        setupViews()
    }
    
    func setupViews() {
        titleLabel.text = "FEEDBACK"
        titleLabel.textAlignment = .center
        //titleLabel.backgroundColor = .white
        titleLabel.textColor = .white
        titleLabel.layer.cornerRadius = 5
        titleLabel.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 40)
        addSubview(titleLabel)
        titleLabel.constrainTopTo(anchor: topAnchor, constant: 5)
        titleLabel.constrainWidthTo(dimension: widthAnchor, multiplier: 0.9)
        //titleLabel.constrainHeightTo(dimension: heightAnchor, multiplier: 0.15)
        titleLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        titleLabel.constrainCenterXTo(anchor: centerXAnchor)
        
        //let feedbackTableView = UITableView()
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.layer.cornerRadius = 5
        feedbackTableView.bounces = false
        addSubview(feedbackTableView)
        feedbackTableView.constrainTopTo(anchor: titleLabel.bottomAnchor, constant: 10)
        feedbackTableView.constrainRightTo(anchor: rightAnchor, constant: -10)
        feedbackTableView.constrainBottomTo(anchor: bottomAnchor, constant: -10)
        feedbackTableView.constrainLeftTo(anchor: leftAnchor, constant: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedbackContainerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let feedbackOptionLabels = UILabel()
        feedbackOptionLabels.text = feedbackOptions[indexPath.row].rawValue
        feedbackOptionLabels.textAlignment = .center
        feedbackOptionLabels.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 35)
        cell.addSubview(feedbackOptionLabels)
        feedbackOptionLabels.constrainFullyToSuperView()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return feedbackTableView.frame.height / CGFloat(feedbackOptions.count)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackOptions.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
