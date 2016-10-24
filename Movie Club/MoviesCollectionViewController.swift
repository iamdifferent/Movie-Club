//
//  MoviesCollectionViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 4/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import Material

let cellCount = ROWS * COLS
var demoDone = false

class MoviesCollectionViewController: UICollectionViewController {
    
    let reuseIdentifier = "MovieCell"
    
    // MARK: - Required Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        setupSearchControl()
        
        // Set collection view layout
        self.collectionView!.collectionViewLayout = MoviesCollectionViewLayout()

        // Register cell classes
        self.collectionView!.registerClass(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        let tapGestureRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMovieDetails(_:)))
        tapGestureRecogniser.numberOfTapsRequired = 1
        self.collectionView!.addGestureRecognizer(tapGestureRecogniser)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        if !demoDone {
            let startingView = self.storyboard?.instantiateViewControllerWithIdentifier("Onboarding Container") as! OnboardingContainerViewController
            self.presentViewController(startingView, animated: true, completion: nil)
        }*/
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Additional Setup
    func setupSearchControl() {
        let image: UIImage? = MaterialIcon.cm.search
        let searchButton: IconButton = IconButton()
        searchButton.pulseColor = MaterialColor.grey.base
        searchButton.tintColor = MaterialColor.black
        searchButton.setImage(image, forState: .Normal)
        searchButton.setImage(image, forState: .Highlighted)
        self.view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(searchForMovies), forControlEvents: .TouchUpInside)
        Layout.topRight(self.view, child: searchButton, top: 24, right: 9)
    }
    
    func searchForMovies() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("Search Movies") as! SearchMoviesViewController
        controller.modalTransitionStyle = .CrossDissolve
        self.presentViewController(controller, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cellCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MoviesCollectionViewCell
    
        // Configure the cell
        let movie = movies[(indexPath as NSIndexPath).item]
        let poster = movie.poster
        
        print(poster)
        if poster.rangeOfString("http") != nil && poster.rangeOfString(".jpg") != nil {
            let posterURL = poster.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let url = NSURL(string: posterURL)!
            print("downloading image for poster")
            cell.downloadImage(url)
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    // MARK: - Show Movie Details
    func showMovieDetails(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            let point: CGPoint = sender.locationInView(self.collectionView)
            let indexPath: NSIndexPath? = self.collectionView!.indexPathForItemAtPoint(point)
            
            if indexPath != nil {
                let tappedIndex = (indexPath! as NSIndexPath).item
                
                let movieDetailsController = self.storyboard?.instantiateViewControllerWithIdentifier("Movie Details") as! MovieDetailsViewController
                
                print(movies[tappedIndex].name)
                movieDetailsController.movieId = movies[tappedIndex].id
                movieDetailsController.name = movies[tappedIndex].name
                movieDetailsController.director = movies[tappedIndex].director
                movieDetailsController.actors = movies[tappedIndex].actors
                movieDetailsController.cover = movies[tappedIndex].poster
                movieDetailsController.year = movies[tappedIndex].year
                movieDetailsController.story = movies[tappedIndex].story
                
                self.presentViewController(movieDetailsController, animated: true, completion: nil)
            }
        }
    }

}
