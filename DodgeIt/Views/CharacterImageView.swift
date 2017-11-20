//
//  CharacterImageView.swift
//  DodgeIt
//
//  Created by admin on 11/19/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class CharacterImageView: UIImageView {
    //let characterID: String
    let imageNameLiteral: String
    let rightFacingImage: UIImage
    let leftFacingImage: UIImage

    private var imageRightAnimationArray = [UIImage]()
    private var imageLeftAnimationArray = [UIImage]()
    
    // Relies on image naming convention of imageName001, imageName002, imageName003, etc...
    //init(imageNameLiteral: String, numberOfImagesForAnimation: Int) {
    init(characterID: String) {
        let character: Character = PoolOfPossibleCharacters.shared.getCharacterByID(characterID)!
        
        self.imageNameLiteral = character.right_facing_asset_name_literal
        rightFacingImage = UIImage(imageLiteralResourceName: imageNameLiteral)
        leftFacingImage = UIImage(cgImage: UIImage(imageLiteralResourceName: imageNameLiteral).cgImage!, scale: 1, orientation: .upMirrored)
    
        var imageName = imageNameLiteral
        imageName.removeLast()
        
        var lastTwoCharacterRemovedFromImage = imageNameLiteral
        lastTwoCharacterRemovedFromImage.removeLast()
        lastTwoCharacterRemovedFromImage.removeLast()
        
        for x in 0..<character.number_of_images {
            if x >= 10 {
                imageRightAnimationArray.append(UIImage(imageLiteralResourceName: "\(lastTwoCharacterRemovedFromImage)\(x)"))
                continue
            } // needs to be imageName010, NOT imageName0010
            imageRightAnimationArray.append(UIImage(imageLiteralResourceName: "\(imageName)\(x)"))
        }
        
        for x in 0..<character.number_of_images {
            if x >= 10 {
                imageLeftAnimationArray.append(UIImage(cgImage: UIImage(imageLiteralResourceName: "\(lastTwoCharacterRemovedFromImage)\(x)").cgImage!, scale: 1, orientation: .upMirrored))
                continue
            } // needs to be imageName010, NOT imageName0010
            imageLeftAnimationArray.append(UIImage(cgImage: UIImage(imageLiteralResourceName: "\(imageName)\(x)").cgImage!, scale: 1, orientation: .upMirrored))
        }
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        image = self.rightFacingImage
        
        animationDuration = 0.40
        animationImages = self.imageLeftAnimationArray
        contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func readjustImageAccordingTo(swipeDirection: UISwipeGestureRecognizerDirection) {
        //image = nil
        switch swipeDirection {
        case .up:
            break
        case .down:
            break
        case .left:
            animationImages = self.imageLeftAnimationArray
            image = self.leftFacingImage
        case .right:
            animationImages = self.imageRightAnimationArray
            image = self.rightFacingImage
        default:
            break
        }
        layoutIfNeeded()
    }
    
    private var animationStartCounter: Int = 0
    func animateImageViewFor(_ duration: TimeInterval) {
        startAnimating()
        animationStartCounter += 1
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { [weak self] (timer) in
            if let weakSelf = self {
                weakSelf.animationStartCounter -= 1
                if weakSelf.animationStartCounter <= 0 {
                    weakSelf.stopAnimating()
                }
            }
        })
    }
}
