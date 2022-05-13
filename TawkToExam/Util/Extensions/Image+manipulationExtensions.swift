//
//  UIImage+manipulations.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/18/21.
//

import UIKit

extension UIImage {
    func inverted() -> UIImage {
        let beginImage = CIImage(image: self)
        let filterName = "CIColorInvert"
        if let filter = CIFilter(name: filterName) {
            filter.setValue(beginImage, forKey: kCIInputImageKey)
            let newImage = UIImage(ciImage: filter.outputImage!)
            return newImage
        } else {
            print("Error || \(filterName) not found in CIFilter names")
            return self
        }
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
