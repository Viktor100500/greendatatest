//
//  PersonCell.swift
//  GreenDataTest
//
//  Created by yaruncle on 06.11.2020.
//  Copyright © 2020 yaruncle. All rights reserved.
//

import UIKit

class ImageManager {
    static let shared = ImageManager() // shared instance
    private init() {} // Prevent creation (Thread safe)
    
    private var images : Dictionary<String, UIImage> = Dictionary<String, UIImage>() // image cache
    
    func requestImage(url : URL, onSuccess : @escaping ((UIImage)->Void)) {
        if(self.images[url.absoluteString] != nil) { // check it exists (Cache hit)
            onSuccess(self.images[url.absoluteString]!)
        } else {
            let task = URLSession.shared.dataTask(with: url) { (data, resp, err) in
                if(err == nil) {
                    DispatchQueue.main.async() {
                        self.images[url.absoluteString] = UIImage(data: data!)
                        onSuccess(self.images[url.absoluteString]!)
                    }
                }
            }
            task.resume()
        }
    }
    
    func cleanCache() {
        images.removeAll()
    }
}

