//
//  OnboardingViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 8/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var onboardingTitle: UILabel!
    @IBOutlet weak var onboardingDescription: UITextView!
    
    
    // MARK: - Properties
    var pageIndex: Int?
    var image: UIImage?
    var header: String?
    var about: String?
    
    // MARK: - Required Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.onboardingImage.image = image
        self.onboardingTitle.text = header
        self.onboardingDescription.text = about
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

}
