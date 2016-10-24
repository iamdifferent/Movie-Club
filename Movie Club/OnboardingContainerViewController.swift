//
//  OnboardingContainerViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 8/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit

class OnboardingContainerViewController: UIViewController, UIPageViewControllerDataSource {
    
    private let onboardingImages = [
        UIImage(named: "Happy Face Symbol"),
        UIImage(named: "Movies Symbol"),
        UIImage(named: "Add to Watchlist Symbol"),
        UIImage(named: "Add to Watched Symbol"),
        UIImage(named: "Movie Night Symbol")
    ]
    private let onboardingTitles = [
        "Welcome to Movie Club",
        "Your Universe of Movies",
        "Add to your Watchlist",
        "Already watched it ?",
        "Organise a Movie Night"
    ]
    
    private let onboardingDescriptions = [
        "Explore movies - when you want, where you want, with whom you want",
        "Look around or maybe search for something you have in mind. You’ll definitely find something you like !",
        "Add movies to your watchlist and come back to them when you can\n\n😀",
        "Mark it as watched and let your club members know",
        "Bring everyone together and have a great time! \n\nP.S. Don’t forget the popcorn 😇"
    ]
    
    var onboardingControl: UIPageViewController!
    @IBOutlet weak var startButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.onboardingControl = self.storyboard?.instantiateViewControllerWithIdentifier("Onboarding Control") as! UIPageViewController
        self.onboardingControl.dataSource = self
        
        let startingView = self.viewControllerAtIndex(0)
        self.onboardingControl.setViewControllers([startingView!], direction: .Forward, animated: false, completion: nil)
        
        self.onboardingControl.view.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 104)
        
        self.addChildViewController(self.onboardingControl)
        self.view.addSubview(self.onboardingControl.view)
        self.onboardingControl.didMoveToParentViewController(self)
        
        
        self.startButton.layer.cornerRadius = 5
        self.startButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.startButton.layer.borderWidth = 1
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Customisation point
        if demoDone {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Page View Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! OnboardingViewController).pageIndex
        
        if index == nil || index == 0 {
            return nil
        }
        
        var newIndex = index!
        newIndex -= 1
        return self.viewControllerAtIndex(newIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let controller = viewController as! OnboardingViewController
        
        let index = controller.pageIndex
        
        if index == nil {
            return nil
        }
        
        var newIndex = index!
        newIndex += 1
        
        if newIndex == self.onboardingTitles.count {
            return nil
        }
        
        return self.viewControllerAtIndex(newIndex)
    }
    
    func viewControllerAtIndex(index: Int) -> OnboardingViewController? {
        if index >= self.onboardingTitles.count {
            return nil
        }
        
        let onboardingView = self.storyboard?.instantiateViewControllerWithIdentifier("Onboarding") as! OnboardingViewController
        onboardingView.image = onboardingImages[index]
        onboardingView.header = onboardingTitles[index]
        onboardingView.about = onboardingDescriptions[index]
        onboardingView.pageIndex = index
        
        return onboardingView
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.onboardingTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    @IBAction func finishOnboarding() {
        demoDone = true
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("Register Device") as! RegisterDeviceViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }

}
