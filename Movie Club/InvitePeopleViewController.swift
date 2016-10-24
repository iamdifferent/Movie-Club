//
//  InvitePeopleViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 6/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import Material

class InvitePeopleViewController: UIViewController {

    @IBOutlet weak var newMemberPhoneNumber: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupControls()
        self.newMemberPhoneNumber.font = UIFont(name: "MostLight300", size: 16)
        
        self.newMemberPhoneNumber.becomeFirstResponder()
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
    
    func setupControls() {
        let image: UIImage? = MaterialIcon.cm.close
        let backButton: IconButton = IconButton()
        backButton.pulseColor = MaterialColor.grey.base
        backButton.tintColor = MaterialColor.black
        backButton.setImage(image, forState: .Normal)
        backButton.setImage(image, forState: .Highlighted)
        backButton.addTarget(self, action: #selector(cancelMemberInvitationProcess), forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        Layout.topLeft(self.view, child: backButton, top: 24, left: 9)
    }
    
    func cancelMemberInvitationProcess() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
