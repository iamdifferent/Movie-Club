//
//  MovieDetailsViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 4/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import CoreData
import Material

//let deviceId = PlistManager.sharedInstance.getValueForKey("Device User") as! String
//let deviceUserIndex = Int(deviceId)! - 1

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Variables
    private var contentRect: CGRect!
    var movieId: String?
    var name: String?
    var cover: String?
    var year: String?
    var story: String?
    var director: String?
    var actors: String?
    var watchedListButton: IconButton!
    var watchedListButtonSelected: IconButton!
    var watchListButton: IconButton!
    var watchListButtonSelected: IconButton!
    
    var deviceId = ""
    var deviceUserIndex: Int = 0
    
    
    // MARK: - Properties
    @IBOutlet weak var movieDetailsContainer: UIScrollView!
    @IBOutlet weak var movieCover: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseYear: UILabel!
    @IBOutlet weak var movieStory: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    @IBOutlet weak var movieActors: UILabel!
    
    // MARK: - Required Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupActionBar()
        
        cover = cover?.stringByReplacingOccurrencesOfString("300", withString: "800")
        let coverURL = cover!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string: coverURL!)!
        downloadImage(url, andAssignTo: self.movieCover)
        
        print(name)
        movieTitle.text = name
        movieReleaseYear.text = year
        movieStory.text = story
        movieDirector.text = director
        movieActors.text = actors
        
        deviceId = PlistManager.sharedInstance.getValueForKey("Device User") as! String
        deviceUserIndex = Int(deviceId)! - 1
        
        updateActionBarItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // set scroll view content size
        contentRect = CGRectZero
        for view in self.movieDetailsContainer.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        self.movieDetailsContainer.contentSize.width = screenSize.width
        self.movieDetailsContainer.contentSize.height = contentRect.height + 20
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Action Bar
    func setupActionBar() {
        let containerView = UIView()
        self.view.addSubview(containerView)
        Layout.horizontally(self.view, child: containerView, left: 0, right: 0)
        Layout.top(self.view, child: containerView, top: 0)
        Layout.height(self.view, child: containerView, height: 76)
        
        let statusBarView = MaterialView()
        statusBarView.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
        containerView.addSubview(statusBarView)
        Layout.horizontally(containerView, child: statusBarView, left: 0, right: 0)
        Layout.top(containerView, child: statusBarView, top: 0)
        Layout.height(containerView, child: statusBarView, height: 20)
        
        
        let actionBar = MaterialView()
        actionBar.backgroundColor = MaterialColor.white
        actionBar.shadowColor = MaterialColor.grey.base
        actionBar.shadowOffset = CGSize(width: 0, height: 2)
        actionBar.shadowOpacity = 0.5
        actionBar.shadowRadius = 1
        containerView.addSubview(actionBar)
        Layout.horizontally(containerView, child: actionBar, left: 0, right: 0)
        Layout.top(containerView, child: actionBar, top: 20)
        Layout.height(containerView, child: actionBar, height: 56)
        
        // left control
        var image: UIImage? = MaterialIcon.cm.arrowBack
        let backButton: IconButton = IconButton()
        backButton.pulseColor = MaterialColor.grey.base
        backButton.tintColor = MaterialColor.black
        backButton.setImage(image, forState: .Normal)
        backButton.setImage(image, forState: .Highlighted)
        backButton.addTarget(self, action: #selector(closeMovieDetails), forControlEvents: .TouchUpInside)
        actionBar.addSubview(backButton)
        Layout.topLeft(actionBar, child: backButton, top: 10, left: 5)
        
        // right controls
        image = UIImage(named: "calendar")
        let eventButton: IconButton = IconButton()
        eventButton.pulseColor = MaterialColor.grey.base
        eventButton.tintColor = MaterialColor.black
        eventButton.setImage(image, forState: .Normal)
        eventButton.setImage(image, forState: .Highlighted)
        eventButton.addTarget(self, action: #selector(organiseMovieNight), forControlEvents: .TouchUpInside)
        actionBar.addSubview(eventButton)
        Layout.topRight(actionBar, child: eventButton, top: 8, right: 0)
        
        // watched buttons
        image = UIImage(named: "add to watched list")
        watchedListButton = IconButton()
        watchedListButton.pulseColor = MaterialColor.grey.base
        watchedListButton.tintColor = MaterialColor.black
        watchedListButton.setImage(image, forState: .Normal)
        watchedListButton.setImage(image, forState: .Highlighted)
        watchedListButton.addTarget(self, action: #selector(addMovieToWatchedList), forControlEvents: .TouchUpInside)
        actionBar.addSubview(watchedListButton)
        Layout.topRight(actionBar, child: watchedListButton, top: 10, right: 50)
        
        image = UIImage(named: "added to watched list")
        watchedListButtonSelected = IconButton()
        watchedListButtonSelected.pulseColor = MaterialColor.grey.base
        watchedListButtonSelected.tintColor = MaterialColor.green.base
        watchedListButtonSelected.setImage(image, forState: .Normal)
        watchedListButtonSelected.setImage(image, forState: .Highlighted)
        watchedListButtonSelected.addTarget(self, action: #selector(removeMovieFromWatchedList), forControlEvents: .TouchUpInside)
        actionBar.addSubview(watchedListButtonSelected)
        Layout.topRight(actionBar, child: watchedListButtonSelected, top: 10, right: 50)
        
        // watchlist buttons
        image = UIImage(named: "add to watchlist")
        watchListButton = IconButton()
        watchListButton.pulseColor = MaterialColor.grey.base
        watchListButton.tintColor = MaterialColor.black
        watchListButton.setImage(image, forState: .Normal)
        watchListButton.setImage(image, forState: .Highlighted)
        watchListButton.addTarget(self, action: #selector(addMovieToWantToWatchList), forControlEvents: .TouchUpInside)
        actionBar.addSubview(watchListButton)
        Layout.topRight(actionBar, child: watchListButton, top: 10, right: 100)
        
        image = UIImage(named: "added to watchlist")
        watchListButtonSelected = IconButton()
        watchListButtonSelected.pulseColor = MaterialColor.grey.base
        watchListButtonSelected.tintColor = MaterialColor.black
        watchListButtonSelected.setImage(image, forState: .Normal)
        watchListButtonSelected.setImage(image, forState: .Highlighted)
        watchListButtonSelected.addTarget(self, action: #selector(removeMovieFromWantToWatch), forControlEvents: .TouchUpInside)
        actionBar.addSubview(watchListButtonSelected)
        Layout.topRight(actionBar, child: watchListButtonSelected, top: 10, right: 100)
    }
    
    func updateActionBarItems() {
        updateMemberDetails()
        
        // now decide which buttons to hide and show
        print("User Index : \(deviceUserIndex)")
        if members[deviceUserIndex].hasWatchedTheMovie(movieId!) {
            // only one button -> user has watched the movie should be shown
            print("user has watched the movie")
            
            watchListButton.hidden = true
            watchListButtonSelected.hidden = true
            watchedListButton.hidden = true
            watchedListButtonSelected.hidden = false
            
        } else {
            
            if members[deviceUserIndex].wantsToWatchTheMovie(movieId!) {
                // two buttons -> wants to watch selected & unselected watched button
                print("user wants to watch the movie")
                watchListButton.hidden = true
                watchedListButtonSelected.hidden = true
                
                watchListButtonSelected.hidden = false
                watchedListButton.hidden = false
            } else {
                print("none")
                watchedListButtonSelected.hidden = true
                watchListButtonSelected.hidden = true
                
                watchedListButton.hidden = false
                watchedListButton.hidden = false
            }
        }
    }
    
    func updateMemberDetails() {
        if members[deviceUserIndex].needsToUpdatePersonalDetails() {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let watched = members[deviceUserIndex].moviesWatched.joinWithSeparator("---")
            let wishlist = members[deviceUserIndex].moviesWantToWatch.joinWithSeparator("---")
            
            memberObjects[deviceUserIndex].setValue(watched, forKey: memberMoviesWatchedKey)
            memberObjects[deviceUserIndex].setValue(wishlist, forKey: memberMoviesWantToWatchKey)
            
            print(memberObjects[deviceUserIndex])
            
            do {
                try managedContext.save()
                print("saving member details")
                members[deviceUserIndex].updatesSuccessfullySaved()
                print(memberObjects[deviceUserIndex])
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Close View
    func closeMovieDetails() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Download image
    func downloadImage(imageURL: NSURL, andAssignTo: UIImageView?) {
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(imageURL) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    andAssignTo!.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
    }
    
    // MARK: - Add to Watched
    func addMovieToWatchedList() {
        print("adding to watched")
        
        members[deviceUserIndex].addToWatched(movieId!)
        
        updateActionBarItems()
    }
    
    func removeMovieFromWatchedList() {
        print("removing from watched")
        
        members[deviceUserIndex].removeFromWatched(movieId!)
        
        updateActionBarItems()
    }
    
    func addMovieToWantToWatchList() {
        print("adding to wishlist")
        
        members[deviceUserIndex].addToWishlist(movieId!)
        
        updateActionBarItems()
    }
    
    func removeMovieFromWantToWatch() {
        print("removing from wishlist")
        
        members[deviceUserIndex].removeFromWishlist(movieId!)
        
        updateActionBarItems()
    }
    
    func organiseMovieNight() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("Movie Night") as! MovieNightOrganiserViewController
        controller.name = name
        controller.cover = cover
        self.presentViewController(controller, animated: true, completion: nil)
    }

}
