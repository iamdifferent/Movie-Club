//
//  MemberProfileViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 5/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import Material

let screenSize = UIScreen.mainScreen().bounds
let currentUser = PlistManager.sharedInstance.getValueForKey("Device User") as! String

class MemberProfileViewController: UIViewController, UIScrollViewDelegate {

    var name: String?
    var nickname: String?
    var about: String?
    var id: String?
    var currentUserIndex: Int!
    var _watchlistActualCount = 0
    var _wishlistActualCount = 0
    
    var actionBar: UIView!
    var label: UILabel!
    
    @IBOutlet weak var memberDetailsContainer: UIScrollView!
    @IBOutlet weak var memberProfilePicture: UIImageView!
    @IBOutlet weak var memberNickname: UILabel!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var memberDescription: UILabel!
    @IBOutlet weak var memberWatchedMoviesContainer: UIScrollView!
    @IBOutlet weak var memberWishlistMoviesContainer: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.memberDetailsContainer.delegate = self
        
        self.memberName.text = name
        self.memberNickname.text = nickname
        self.memberDescription.text = about
        
        self.memberProfilePicture.image = UIImage(named: name!)
        self.memberProfilePicture.layer.cornerRadius = 38
        self.memberProfilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        self.memberProfilePicture.layer.borderWidth = 4
        self.currentUserIndex = Int(id!)! - 1
        
        setupControls()
        
        showMemberWatchedMovies()
        showMemberWishlistMovies()
        
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var contentRect = CGRect.zero
        for view in self.memberDetailsContainer.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        self.memberDetailsContainer.contentSize.width = screenSize.width
        self.memberDetailsContainer.contentSize.height = contentRect.height + 20
        print(contentRect)
        
        contentRect = CGRect.zero
        for view in self.memberWatchedMoviesContainer.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        self.memberWatchedMoviesContainer.contentSize = CGSize(width: contentRect.width + 16, height: 168)
        
        contentRect = CGRect.zero
        for view in self.memberWishlistMoviesContainer.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        self.memberWishlistMoviesContainer.contentSize = CGSize(width: contentRect.width + 16, height: 168)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        
        if scrollView.contentOffset.y > 144 {
            actionBar.alpha = 1
        } else {
            actionBar.alpha = (scrollView.contentOffset.y + 20)/164
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Setup controls
    func setupControls() {
        actionBar = UIView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 56))
        actionBar.backgroundColor = UIColor.whiteColor()
        actionBar.layer.shadowColor = MaterialColor.grey.base.CGColor
        actionBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        actionBar.layer.shadowOpacity = 0.5
        actionBar.layer.shadowRadius = 1
        
        label = UILabel()
        label.text = name
        label.font = UIFont(name: "MoskMedium500", size: 18)
        label.textColor = MaterialColor.black
        actionBar.addSubview(label)
        Layout.left(actionBar, child: label, left: 72)
        Layout.right(actionBar, child: label, right: 56)
        Layout.top(actionBar, child: label, top: 17)
        
        actionBar.alpha = 0
        self.view.addSubview(actionBar)
        
        var image: UIImage? = MaterialIcon.cm.arrowBack
        let backButton: IconButton = IconButton()
        backButton.pulseColor = MaterialColor.grey.base
        backButton.tintColor = MaterialColor.black
        backButton.setImage(image, forState: .Normal)
        backButton.setImage(image, forState: .Highlighted)
        backButton.addTarget(self, action: #selector(closeMemberDetails), forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        Layout.topLeft(self.view, child: backButton, top: 27, left: 10)
        
        if currentUser == id {
            image = MaterialIcon.cm.edit
            let editButton: IconButton = IconButton()
            editButton.pulseColor = MaterialColor.grey.base
            editButton.tintColor = MaterialColor.black
            editButton.setImage(image, forState: .Normal)
            editButton.setImage(image, forState: .Highlighted)
            editButton.addTarget(self, action: #selector(editMemberProfile), forControlEvents: .TouchUpInside)
            self.view.addSubview(editButton)
            Layout.topRight(self.view, child: editButton, top:27, right: 10)
        }
    }
    
    func closeMemberDetails() {
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.popViewControllerAnimated(true)
        /*
        self.dismissViewControllerAnimated(true, completion: nil)*/
    }
    
    func editMemberProfile() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("Edit Profile") as! EditProfileViewController
        
        controller.userName = name
        controller.userNickname = nickname
        controller.userDescription = about
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        //self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func showMemberWatchedMovies() {
        let count = members[self.currentUserIndex].moviesWatched.count
        
        for index in 0 ..< count {
            
            let _movieIndex = members[self.currentUserIndex].moviesWatched[index]
            
            if _movieIndex != "" {
                _watchlistActualCount += 1
                let movieView = self.getMovieViewFor(_movieIndex, andItemIndex: index)
                
                self.memberWatchedMoviesContainer.addSubview(movieView)
            }
        }
    }
    
    func showMemberWishlistMovies() {
        let count = members[self.currentUserIndex].moviesWantToWatch.count
        
        for index in 0 ..< count {
            let _movieIndex = members[self.currentUserIndex].moviesWantToWatch[index]
            
            if _movieIndex != "" {
                _wishlistActualCount += 1
                let movieView = self.getMovieViewFor(_movieIndex, andItemIndex: index)
                
                self.memberWishlistMoviesContainer.addSubview(movieView)
            }
        }
    }
    
    internal func getMovieViewFor(movieIndex: String, andItemIndex index: Int) -> UIView {
        let movie = movies[Int(movieIndex)!]
        let movieView = UIView(frame: CGRect(x: CGFloat(index * 112), y: 0, width: 112, height: 168))
        
        let posterView = UIView(frame: CGRect(x: 16, y: 0, width: 96, height: 142))
        posterView.layer.shadowOpacity = 0.5
        posterView.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        posterView.layer.shadowRadius = 4
        posterView.layer.shadowOffset = CGSize(width: 0, height: 2)
        posterView.backgroundColor = UIColor.clearColor()
        
        let poster = UIImageView(frame: CGRect(x: 0, y: 0, width: 96, height: 142))
        poster.contentMode = .ScaleAspectFill
        poster.layer.cornerRadius = 2
        poster.clipsToBounds = true
        loadImageFromUrl(movie.poster, posterDestination: poster)
        posterView.addSubview(poster)
        movieView.addSubview(posterView)
        
        let movieLabel = UILabel()
        movieLabel.text = movie.name
        movieLabel.font = UIFont(name: "MoskLight300", size: 12)
        movieLabel.frame = CGRect(x: 16, y: 142, width: 96, height: 26)
        movieLabel.numberOfLines = 2
        movieLabel.textAlignment = .Center
        movieView.addSubview(movieLabel)
        
        return movieView
    }
    
    func loadImageFromUrl(poster: String, posterDestination: UIImageView){
        
        // Create Url from string
        let posterURL = poster.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string: posterURL!)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    posterDestination.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
    }
}
