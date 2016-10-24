//
//  MovieNightOrganiserViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 15/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import Material

class MovieNightOrganiserViewController: UIViewController {

    var name: String?
    var cover: String?
    
    @IBOutlet weak var container: UIScrollView!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupActionBar()
        
        self.movieTitle.text = name
        downloadImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var contentRect = CGRectZero
        for view in self.container.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        self.container.contentSize.width = contentRect.width
        self.container.contentSize.height = contentRect.height + 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupActionBar() {
        let actionBar = MaterialView()
        actionBar.backgroundColor = MaterialColor.white
        actionBar.shadowColor = MaterialColor.grey.base
        actionBar.shadowOffset = CGSize(width: 0, height: 2)
        actionBar.shadowOpacity = 0.5
        actionBar.shadowRadius = 1
        self.view.addSubview(actionBar)
        Layout.horizontally(self.view, child: actionBar, left: 0, right: 0)
        Layout.top(self.view, child: actionBar, top: 20)
        Layout.height(self.view, child: actionBar, height: 56)
        
        let image: UIImage? = MaterialIcon.cm.arrowBack
        let backButton: IconButton = IconButton()
        backButton.pulseColor = MaterialColor.grey.base
        backButton.tintColor = MaterialColor.black
        backButton.setImage(image, forState: .Normal)
        backButton.setImage(image, forState: .Highlighted)
        backButton.addTarget(self, action: #selector(cancelOrganising), forControlEvents: .TouchUpInside)
        actionBar.addSubview(backButton)
        Layout.topLeft(actionBar, child: backButton, top: 10, left: 5)
        
        let label = UILabel()
        label.text = "New Movie Night"
        label.font = UIFont(name: "MoskMedium500", size: 18)
        label.textColor = MaterialColor.black
        actionBar.addSubview(label)
        Layout.left(actionBar, child: label, left: 72)
        Layout.right(actionBar, child: label, right: 56)
        Layout.top(actionBar, child: label, top: 19)
    }
    
    func cancelOrganising() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func downloadImage() {
        cover = cover!.stringByReplacingOccurrencesOfString("300", withString: "800")
        let coverURL = cover!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string: coverURL!)!
        
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
