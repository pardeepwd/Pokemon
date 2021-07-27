//
//  UIImageView+Extensions.swift
//  Pokemon
//
//  Created by ABC on 22/07/21.
//

import Foundation
import UIKit

//extension UIImageView {
//    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
//        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
//            (data, response, error) -> Void in
//            DispatchQueue.main.async {
//                self.contentMode =  contentMode
//                if let data = data { self.image = UIImage(data: data) }
//            }
//        }).resume()
//    }
//}


let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String, imageKey: String, completion: @escaping(Result<Bool, Error>) ->()) {
        
        // Check cache images
        if let cachedImage = imageCache.object(forKey: imageKey as NSString) as? UIImage {
            image = cachedImage
            completion(.success(true))
            return
        }
        //
        // If image of Loading for the first time or removed from the memory.
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    print(err)
                    completion(.failure(err))
                    return
                    
                }
                
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage as UIImage, forKey: imageKey as NSString)
                            self.image = downloadedImage
                            completion(.success(true))
                        }
                    }
                }
            }.resume()
        }
    }
}
