//
//  Extensions.swift
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

extension Int {
    func getCommaFormattedNumberToString() -> String {
        var string = String(self)
        if string.count > 3 {
            let remainder = string.count % 3
            if remainder == 0 {
                string.insert(",", at: string.index(string.startIndex, offsetBy: 3))
                return string
            } else {
                string.insert(",", at: string.index(string.startIndex, offsetBy: remainder))
                return string
            }
        } else {
            return String(self)
        }
    }
    static func randomUpTo(_ int: Int) -> Int {
        return Int(arc4random_uniform(UInt32(int)))
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

extension UIView {
    static func addConstraintsWithVisualFormat(vfl: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary["v\(index)"] = view
        }
        NSLayoutConstraint.constraints(withVisualFormat: vfl, metrics: nil, views: viewsDictionary)
    }
    func constrainFullyToSuperView() {
        if let superExists = superview {
            translatesAutoresizingMaskIntoConstraints = false
            topAnchor.constraint(equalTo: superExists.topAnchor).isActive = true
            rightAnchor.constraint(equalTo: superExists.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superExists.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superExists.leftAnchor).isActive = true
        }
    }
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension UIColor {
    static func getRGBFromArray(_ array: [Int]) -> UIColor? {
        if array.count != 3 { return nil }
        return UIColor(red: CGFloat(array[0])/255, green: CGFloat(array[1])/255, blue: CGFloat(array[2])/255, alpha: 1)
    }
}
