//
//  String+TupleValue.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

extension String {
    func tupleValue() -> (Int, Int)? {
        let spacesRemoved = self.filter { $0 != " " }
        let stringArray = spacesRemoved.components(separatedBy: ",")
        if stringArray.count != 2 { return nil }
        guard let firstValue = stringArray.first,
            let secondValue = stringArray.last,
            let firstInteger = Int(firstValue),
            let secondInteger = Int(secondValue) else { return nil }
        if firstInteger < 0 || secondInteger < 0 { return nil }
        return (firstInteger, secondInteger)
    }
}

extension Array {
    func getTupleFromArray() -> (Int, Int)? {
        if self.count != 2 { return nil }
        guard let first = self.first as? Int,
            let last = self.last as? Int else { return nil }
        return (first, last)
    }
    
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
