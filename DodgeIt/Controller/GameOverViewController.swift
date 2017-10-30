//
//  GameOverViewController.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/30/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    var puzzleVC: PuzzleViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        print("im game over bros!")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        puzzleVC?.newGameSetup(false)
        dismiss(animated: true, completion: nil)
    }
}
