//
//  GameOverViewController.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/30/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    weak var puzzleVC: PuzzleViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //135-206-250
        view.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
        print("im game over bros!")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        puzzleVC?.newGameSetup(false)
        dismiss(animated: true, completion: nil)
    }
}
