//
//  DiscussionTableViewCell.swift
//  Movie Club
//
//  Created by Parth Mehta on 13/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit

class DiscussionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    // MARK: Required Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: - Download Movie Image
    func loadImageFromUrl(url: String){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.moviePoster.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
    }

}
