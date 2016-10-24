//
//  RegisterDeviceViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 9/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import Material

class RegisterDeviceViewController: UIViewController, TextFieldDelegate {

    @IBOutlet weak var phoneNumber: TextField!
    
    var doneButton: IconButton!
    var closeButton: IconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var image: UIImage? = MaterialIcon.cm.close
        closeButton = IconButton()
        closeButton.pulseColor = MaterialColor.grey.base
        closeButton.tintColor = MaterialColor.black
        closeButton.setImage(image, forState: .Normal)
        closeButton.setImage(image, forState: .Highlighted)
        closeButton.addTarget(self, action: #selector(cancelRegistrationProcess), forControlEvents: .TouchUpInside)
        self.view.addSubview(closeButton)
        Layout.topLeft(self.view, child: closeButton, top: 26, left: 16)
        
        image = MaterialIcon.cm.check
        doneButton = IconButton()
        doneButton.pulseColor = MaterialColor.grey.base
        doneButton.tintColor = MaterialColor.black
        doneButton.setImage(image, forState: .Normal)
        doneButton.setImage(image, forState: .Highlighted)
        doneButton.hidden = true
        doneButton.addTarget(self, action: #selector(finishDeviceRegistration), forControlEvents: .TouchUpInside)
        self.view.addSubview(doneButton)
        Layout.topRight(self.view, child: doneButton, top: 26, right: 16)
        
        self.phoneNumber.font = UIFont(name: "MoskMedium500", size: 17)
        self.phoneNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        self.phoneNumber.becomeFirstResponder()
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
    
    func cancelRegistrationProcess() {
        demoDone = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidChange(textField: TextField) {
        if textField.text?.characters.count >= 10 {
            self.doneButton.hidden = false
        } else {
            self.doneButton.hidden = true
        }
    }
    
    func finishDeviceRegistration() {
        demoDone = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
