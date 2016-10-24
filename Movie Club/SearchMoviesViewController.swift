//
//  SearchMoviesViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 6/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import Material

class SearchMoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TextFieldDelegate {
    
    // MARK: - Properties
    var filteredMovies = movies
    var searchBar: SearchBar!
    
    let reuseIdentifier = "MovieTableCell"
    
    // MARK: - Outlets
    @IBOutlet weak var moviesTable: UITableView!
    
    
    // MARK: - Required Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.moviesTable.rowHeight = 72
        
        setupActionBar()
        self.searchBar.textField.becomeFirstResponder()
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
    
    
    // MARK: - Setup Action Bar
    func setupActionBar() {
        
        let containerView = UIView()
        self.view.addSubview(containerView)
        Layout.horizontally(self.view, child: containerView, left: 0, right: 0)
        Layout.top(self.view, child: containerView, top: 0)
        Layout.height(self.view, child: containerView, height: 76)
        
        searchBar = SearchBar()
        searchBar.textField.font = UIFont(name: "MoskLight300", size: 17)
        searchBar.tintColor = MaterialColor.black
        searchBar.textField.delegate = self
        searchBar.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        searchBar.placeholder = "Search for Movies ..."
        containerView.addSubview(searchBar)
        Layout.horizontally(containerView, child: searchBar, left: 0, right: 0)
        Layout.top(containerView, child: searchBar, top: 20)
        
        let image: UIImage? = MaterialIcon.cm.arrowBack
        let backButton: IconButton = IconButton()
        backButton.pulseColor = MaterialColor.grey.base
        backButton.tintColor = MaterialColor.black
        backButton.setImage(image, forState: .Normal)
        backButton.setImage(image, forState: .Highlighted)
        backButton.addTarget(self, action: #selector(finishMovieSearch), forControlEvents: .TouchUpInside)
        searchBar.leftControls = [backButton]
    }
    
    
    // MARK: - Table View Data Source & Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MovieTableViewCell
        
        // Set Movie Title
        cell.movieTitle.text = filteredMovies[(indexPath as NSIndexPath).row].name
        
        // Set Movie Poster
        let image = filteredMovies[(indexPath as NSIndexPath).row].poster
        let imageURL = image.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        cell.loadImageFromUrl(imageURL!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let tappedIndex = (indexPath as NSIndexPath).row
        
        let movieDetailsController = self.storyboard?.instantiateViewControllerWithIdentifier("Movie Details") as! MovieDetailsViewController
        
        // Send data
        movieDetailsController.movieId = filteredMovies[tappedIndex].id
        movieDetailsController.name = filteredMovies[tappedIndex].name
        movieDetailsController.director = filteredMovies[tappedIndex].director
        movieDetailsController.actors = filteredMovies[tappedIndex].actors
        movieDetailsController.cover = filteredMovies[tappedIndex].poster
        movieDetailsController.year = filteredMovies[tappedIndex].year
        movieDetailsController.story = filteredMovies[tappedIndex].story
        
        self.presentViewController(movieDetailsController, animated: true, completion: nil)
    }
    
    
    // MARK: - Finish Search
    func finishMovieSearch() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Textfield Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        print(textField.text)
    }
    
    func textFieldDidChange(textField: UITextField) {
        print(textField.text)
        filterMoviesBySearchString(textField.text!)
    }
    
    
    // MARK: - Filtering
    func filterMoviesBySearchString(searchString: String?) {
        
        if searchString == nil {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter { movie in
                return movie.name.lowercaseString.containsString(searchString!.lowercaseString)
            }
        }
        
        moviesTable.reloadData()
    }

}
