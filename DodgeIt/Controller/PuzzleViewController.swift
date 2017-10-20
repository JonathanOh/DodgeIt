//
//  PuzzleViewController.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController {

    private var currentPuzzleView: PuzzleView!
    private var dataOfSquares: SquareData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let testData = PuzzleTestData()
        let widthOfPuzzle: Double = testData.totalWidth * Double(view.frame.width)
        let testPuzzle = Puzzle(difficulty: testData.difficulty, totalWidth: widthOfPuzzle, numberOfCellsInWidth: testData.numberOfCellsInWidth, numberOfCellsInHeight: testData.numberOfCellsInHeight, lengthOfPuzzleCycle: testData.lengthOfPuzzleCycle, obstaclePositions: testData.obstaclePositions, explosionPositionAndTiming: testData.explosionPositionAndTiming)
        currentPuzzleView = PuzzleView(currentPuzzle: testPuzzle)
        dataOfSquares = currentPuzzleView.gridContainerView.squareData
        //let targetColumn = dataOfSquares.getSquaresAt([(1,0),(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9)])
        triggerExplosionsWith(testPuzzle)
        view = currentPuzzleView
    }
    
    func triggerExplosionsWith(_ puzzle: Puzzle) {
        let squares = dataOfSquares.getSquaresAt([(1,0),(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9)])
        let originalBackgroundColors = squares.map { $0?.backgroundColor }
        _ = squares.map { $0?.backgroundColor = .red }
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            _ = squares.map { $0?.backgroundColor = .yellow }
        }) { (completed) in
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.triggerExplosionsWith(puzzle)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        UIView.animate(withDuration: 1, animations: {
//            self.mainView.center = CGPoint(x: self.mainView.center.x, y: self.mainView.center.y - self.mainView.center.y)
//            self.view.layoutIfNeeded()
//            }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

