//
//  MapThemeNew.swift
//  DodgeIt
//
//  Created by admin on 11/23/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class MapTheme: Codable {
    let description: String
    let id: String
    let courseTiles: [String]
    let explosionTiles: String
    let numberOfExplosionImages: Int
    let obstacleTiles: [String]
    let backgroundImage: String
    let isFreeMap: Bool
    
    private func getArrayOfExplosionImagesForAnimation() -> [UIImage] {
        var explosionImageArray = [UIImage]()
        for x in 0..<numberOfExplosionImages {
            let explosionImage = UIImage(imageLiteralResourceName: "\(explosionTiles)" + "\(x)")
            explosionImageArray.append(explosionImage)
        }
        return explosionImageArray
    }
    
    func getExplosionAnimatedImageView() -> UIImageView {
        let explosionImageView = UIImageView()
        explosionImageView.animationImages = getArrayOfExplosionImagesForAnimation()
        explosionImageView.animationDuration = 0.4
        explosionImageView.animationRepeatCount = 1
        return explosionImageView
    }
    
    func getCourseTileImageView() -> UIImageView {
        let randomCourseTileImage = UIImage(imageLiteralResourceName: courseTiles[Int.randomUpTo(courseTiles.count)])
        let courseTileImageView = UIImageView(image: randomCourseTileImage)
        return courseTileImageView
    }
    func getObstacleTileImageView() -> UIImageView {
        let randomObstacleTileImage = UIImage(imageLiteralResourceName: obstacleTiles[Int.randomUpTo(obstacleTiles.count)])
        let obstacleTileImageView = UIImageView(image: randomObstacleTileImage)
        return obstacleTileImageView
    }
    func getBackgroundImageView() -> UIImageView {
        let bgImage = UIImage(imageLiteralResourceName: backgroundImage)
        let backgroundImageView = UIImageView(image: bgImage)
        return backgroundImageView
    }
}
