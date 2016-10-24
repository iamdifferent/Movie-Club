//
//  DiscussionsViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 13/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import Material

class DiscussionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let reuseIdentifier = "DiscussionTableCell"
    
    @IBOutlet weak var discussionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.hidden = true
        
        self.discussionsTableView.rowHeight = 72
        
        print("opened")
        
        setupActionBar()
        
        loadDiscussions()
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
    
    func loadDiscussions() {
        let discussion1 = Discussion(discussionWithId: "0001", forMovieWithId: "0001", containingMessages: [])
        let discussion2 = Discussion(discussionWithId: "0002", forMovieWithId: "0006", containingMessages: [])
        let discussion3 = Discussion(discussionWithId: "0003", forMovieWithId: "00025", containingMessages: [])
        let discussion4 = Discussion(discussionWithId: "0004", forMovieWithId: "000175", containingMessages: [])
        let discussion5 = Discussion(discussionWithId: "0005", forMovieWithId: "00083", containingMessages: [])
        let discussion6 = Discussion(discussionWithId: "0006", forMovieWithId: "000261", containingMessages: [])
        
        discussions = [discussion1, discussion2, discussion3, discussion4, discussion5, discussion6]
    }
    
    func setupActionBar() {
        let containerView = UIView()
        self.view.addSubview(containerView)
        Layout.top(self.view, child: containerView, top: 0)
        Layout.horizontally(self.view, child: containerView, left: 0, right: 0)
        Layout.height(self.view, child: containerView, height: 76)
        
        let statusBarView = MaterialView()
        statusBarView.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
        containerView.addSubview(statusBarView)
        Layout.top(containerView, child: statusBarView, top: 0)
        Layout.horizontally(containerView, child: statusBarView, left: 0, right: 0)
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
        
        let title = MaterialLabel()
        title.text = "Discussions"
        title.textColor = MaterialColor.black
        title.font = UIFont(name: "MoskMedium500", size: 18)
        actionBar.addSubview(title)
        Layout.horizontally(actionBar, child: title, left: 72, right: 56)
        Layout.top(actionBar, child: title, top: 17)
        
        let image = UIImage(named: "discussionsImage")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 15, y: 15, width: image!.width * 0.8, height: image!.height * 0.8)
        actionBar.addSubview(imageView)
        
        let searchImage: UIImage? = MaterialIcon.cm.search
        let searchButton: IconButton = IconButton()
        searchButton.pulseColor = MaterialColor.grey.base
        searchButton.tintColor = MaterialColor.black
        searchButton.setImage(searchImage, forState: .Normal)
        searchButton.setImage(searchImage, forState: .Highlighted)
        actionBar.addSubview(searchButton)
        Layout.topRight(actionBar, child: searchButton, top: 8, right: 10)
        
    }
    
    // MARK: - Table View Delegate & Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DiscussionTableViewCell
        
        // Set Movie Title
        let discussion = discussions[(indexPath as NSIndexPath).row]
        
        let _movie = movies[Int(discussion.movieId)! - 1]
        
        cell.movieTitle.text = _movie.name
        
        // Set Movie Poster
        let image = _movie.poster
        let imageURL = image.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        cell.loadImageFromUrl(imageURL!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("Discussion") as! DiscussionViewController
        
        let discussion = discussions[(indexPath as NSIndexPath).row]
        let _movie = movies[Int(discussion.movieId)! - 1]
        controller.movieName = _movie.name
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func chooseMovieForNewDiscussion() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("Search Movies") as! SearchMoviesViewController
        controller.modalTransitionStyle = .CrossDissolve
        self.presentViewController(controller, animated: true, completion: nil)
    }

}
