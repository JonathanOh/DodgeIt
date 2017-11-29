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
    private var feedbackCenterXAnchor: NSLayoutConstraint?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .red
        layer.cornerRadius = 5
        setupViews()
        clipsToBounds = true
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
        feedbackCenterXAnchor = feedbackTableView.constrainCenterXTo(anchor: centerXAnchor)
        feedbackTableView.constrainBottomTo(anchor: bottomAnchor, constant: -10)
        feedbackTableView.constrainWidthTo(dimension: widthAnchor, multiplier: 0.93)
    }
    
    func animateViewWithOption(_ option: FeedbackOption) {
        let optionsChosenView = OptionChosenView(chosenOption: option)
        addSubview(optionsChosenView)
        
        optionsChosenView.constrainTopTo(anchor: titleLabel.bottomAnchor, constant: 50)
        let centerX = optionsChosenView.constrainCenterXTo(anchor: centerXAnchor, constant: frame.width + 100)
        optionsChosenView.constrainBottomTo(anchor: bottomAnchor, constant: -50)
        optionsChosenView.constrainWidthTo(dimension: widthAnchor, multiplier: 0.7)
        layoutIfNeeded()

        feedbackCenterXAnchor?.constant = -(frame.width + 100)
        centerX.constant = 0
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.layoutIfNeeded()
        }
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
        animateViewWithOption(feedbackOptions[indexPath.row])
    }
}
