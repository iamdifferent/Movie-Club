//
//  MoviesCollectionViewCell.swift
//  Movie Club
//
//  Created by Parth Mehta on 4/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var imageView: UIImageView!
    
    // MARK: - Required Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Do custom setup
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.backgroundColor = UIColor.whiteColor().CGColor
        self.contentView.clipsToBounds = true
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.imageView.contentMode = .ScaleAspectFill
        self.contentView.addSubview(imageView)
    }
    
    // MARK: - Download Movie Image
    
    
    func downloadImage(imageURL: NSURL) {
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        print("asked to download")
        let task = NSURLSession.sharedSession().dataTaskWithURL(imageURL) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imageView.image = UIImage(data: data)
                    print("Setting image")
                })
            }
        }
        
        // Run task
        task.resume()
    }
}
