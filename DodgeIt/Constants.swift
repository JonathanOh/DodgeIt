//
//  Constants.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 11/10/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

struct CONSTANTS {
    private init() {}
    struct GOOGLE_SERVICES {
        struct ADS {
            static let AD_MOB_APP_ID = "ca-app-pub-2890175151799850~5941100437"
            static let AD_MOB_UNIT_ID = "ca-app-pub-2890175151799850/1427495570"
        }
    }
    struct COLORS {
        static let BACKGROUND_VIEW: UIColor = CONSTANTS.getRGB(R: 161, G: 234, B: 251)//CONSTANTS.getRGB(R: 207, G: 238, B: 145)//R: 207 G: 238 B: 145
        static let PUZZLE_CONTAINER_VIEW: UIColor = CONSTANTS.COLORS.BACKGROUND_VIEW
        static let OBSTACLE: UIColor = .black//CONSTANTS.getRGB(R: 8, G: 95, B: 99)
        static let PUZZLE_SQUARE: UIColor = CONSTANTS.COLORS.BACKGROUND_VIEW
        static let PUZZLE_SQUARE_EXPLOSION: UIColor = CONSTANTS.getRGB(R: 207, G: 10, B: 44)//R: 207 G: 10 B: 44
        static let PLAYER: UIColor = CONSTANTS.getRGB(R: 252, G: 207, B: 77)
        static let LABEL_COLOR: UIColor = UIColor.black
    }
    
    static func getRGB(R: Int, G: Int, B: Int) -> UIColor {
        return UIColor(red: CGFloat(R)/255, green: CGFloat(G)/255, blue: CGFloat(B)/255, alpha: 1)
    }
}
//UIColor(red: 25/255, green: 137/255, blue: 172/255, alpha: 1)//navyblue
