//
//  EditProfileViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 6/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import CoreData
import Material

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    
    var userName: String?
    var userNickname: String?
    var userDescription: String?
    
    private var _userName: String?
    private var _userNickname: String?
    private var _userDescription: String?
    
    @IBOutlet weak var memberDetailsContainer: UIScrollView!
    @IBOutlet weak var memberProfilePictureContainer: MaterialView!
    @IBOutlet weak var memberProfilePicture: UIImageView!
    @IBOutlet weak var memberName: TextField!
    @IBOutlet weak var memberNickname: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupActionBar()
        
        let image: UIImage? = MaterialIcon.cm.photoCamera
        let cameraButton: IconButton = IconButton()
        cameraButton.tintColor = MaterialColor.white
        cameraButton.setImage(image, forState: .Normal)
        cameraButton.setImage(image, forState: .Highlighted)
        memberProfilePictureContainer.addSubview(cameraButton)
        Layout.horizontally(memberProfilePictureContainer, child: cameraButton)
        Layout.vertically(memberProfilePictureContainer, child: cameraButton)
        
        
        // Setup up outlets
        self.memberProfilePicture.image = UIImage(named: userName!)
        self.memberProfilePicture.layer.cornerRadius = 38
        
        self.memberName.addTarget(self, action: #selector(nameDidChange(_:)), forControlEvents: .EditingChanged)
        self.memberName.text = userName
        _userName = userName
        self.memberName.font = UIFont(name: "MoskLight300", size: 17)
        
        self.memberNickname.addTarget(self, action: #selector(nicknameDidChange(_:)), forControlEvents: .EditingChanged)
        self.memberNickname.text = userNickname
        _userNickname = userNickname
        self.memberNickname.font = UIFont(name: "MoskLight300", size: 17)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var contentRect = CGRectZero
        for view in self.memberDetailsContainer.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        self.memberDetailsContainer.contentSize.width = screenSize.width
        self.memberDetailsContainer.contentSize.height = contentRect.height + 20
        print(contentRect)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // setup controls
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
        
        let title = MaterialLabel()
        title.text = "Edit Profile"
        title.textColor = MaterialColor.black
        title.font = UIFont(name: "MoskMedium500", size: 18)
        actionBar.addSubview(title)
        Layout.horizontally(actionBar, child: title, left: 72, right: 56)
        Layout.top(actionBar, child: title, top: 18)
        
        var image: UIImage? = MaterialIcon.cm.arrowBack
        let backButton: IconButton = IconButton()
        backButton.pulseColor = MaterialColor.grey.base
        //backButton.tintColor = UIColor(red: 0.74, green: 0.06, blue: 0.88, alpha: 1.0)
        backButton.tintColor = MaterialColor.black
        backButton.setImage(image, forState: .Normal)
        backButton.setImage(image, forState: .Highlighted)
        backButton.addTarget(self, action: #selector(closeMemberDetails), forControlEvents: .TouchUpInside)
        actionBar.addSubview(backButton)
        Layout.topLeft(actionBar, child: backButton, top: 9, left: 5)
        
        image = MaterialIcon.cm.check
        let doneButton: IconButton = IconButton()
        doneButton.pulseColor = MaterialColor.grey.base
        doneButton.tintColor = MaterialColor.black
        doneButton.setImage(image, forState: .Normal)
        doneButton.setImage(image, forState: .Highlighted)
        doneButton.addTarget(self, action: #selector(saveProfileChanges), forControlEvents: .TouchUpInside)
        actionBar.addSubview(doneButton)
        Layout.topRight(actionBar, child: doneButton, top: 9, right: 5)
    }
    
    func closeMemberDetails() {
        
        self.navigationController?.popViewControllerAnimated(true)
        
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveProfileChanges() {
        print("save profile")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func nameDidChange(textField: TextField) {
        _userName = textField.text
        print(_userName)
    }
    
    func nicknameDidChange(textField: TextField) {
        _userNickname = textField.text
        
        print(_userNickname)
    }

}
