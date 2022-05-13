//
//  CachingImageView.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/20/21.
//

import UIKit

class CachingImageView: UIImageView {
    static var imageCache: NSCache<NSString, NSData> = {
        let cache =  NSCache<NSString, NSData>()
        cache.name = "imageCache"
        return cache
    }()
    
    var filterAction: ((UIImage)->(UIImage))?
    
    func loadImage(from urlString: String) {
        if let cachedImageData = CachingImageView.imageCache.object(forKey: urlString as NSString) {
            setImage(cachedImageData as Data)
        } else {
            let session = SessionProvider()
            session.requestImageData(urlString: urlString) { [weak self] result in
                switch result {
                case .failure(_):
                    break
                case .success(let imageData):
                    CachingImageView.imageCache.setObject(imageData as NSData, forKey: urlString as NSString)
                    self?.setImage(imageData)
                }
            }
        }
    }
    
    func setImage(_ imageData: Data) {
        DispatchQueue.main.async { [weak self] in
            guard let image = UIImage(data: imageData)
            else {
                print("Error || Image data cannot be loaded")
                return
            }
            
            self?.image = self?.filterAction?(image) ?? image
        }
    }
}
