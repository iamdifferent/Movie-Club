//
//  MembersViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 4/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import Material

class MembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let reuseIdentifier = "MemberCell"
    
    // MARK: - Properties
    @IBOutlet weak var membersTableView: UITableView!
    
    
    // MARK: - Required Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(members.count)
        
        self.navigationController?.navigationBar.hidden = true

        // Do any additional setup after loading the view.
        setupActionBar()
        
        self.membersTableView.rowHeight = 54
        self.tabBarController?.tabBar.hidden = false
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
        
        let title = MaterialLabel()
        title.text = "Members"
        title.textColor = MaterialColor.black
        title.font = UIFont(name: "MoskMedium500", size: 18)
        actionBar.addSubview(title)
        Layout.horizontally(actionBar, child: title, left: 72, right: 56)
        Layout.top(actionBar, child: title, top: 17)
        
        let image = UIImage(named: "members")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 16, y: 19, width: image!.width, height: image!.height)
        actionBar.addSubview(imageView)
        
        let searchImage: UIImage? = MaterialIcon.cm.search
        let searchButton: IconButton = IconButton()
        searchButton.pulseColor = MaterialColor.grey.base
        searchButton.tintColor = MaterialColor.black
        searchButton.setImage(searchImage, forState: .Normal)
        searchButton.setImage(searchImage, forState: .Highlighted)
        searchButton.addTarget(self, action: #selector(changeDeviceUser), forControlEvents: .TouchUpInside)
        actionBar.addSubview(searchButton)
        Layout.topRight(actionBar, child: searchButton, top: 8, right: 10)
        
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MembersTableViewCell
        
        let name = members[(indexPath as NSIndexPath).row].name
        cell.backgroundColor = UIColor.clearColor()
        cell.memberImage.image = UIImage(named: name)
        cell.memberName.text = name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        print(members[(indexPath as NSIndexPath).row])
        showUserProfile((indexPath as NSIndexPath).row)
    }
    
    // MARK: - Show user profile
    func showUserProfile(itemNumber: Int) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("User Profile") as! MemberProfileViewController
        
        print(members[itemNumber].id)
        controller.name = members[itemNumber].name
        controller.about = members[itemNumber].description
        controller.nickname = members[itemNumber].nickname
        controller.id = members[itemNumber].id
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func inviteNewPeopleToClub() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("Invite New Person") as! InvitePeopleViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func changeDeviceUser() {
        let alertView = UIAlertController(title: "Choose User", message: "", preferredStyle: .ActionSheet)
        
        for index in 0 ..< members.count {
            let action = UIAlertAction(title: members[index].name, style: .Default, handler: {
                (alert: UIAlertAction!) in
                self.setDeviceUser(index + 1)
            })
            
            alertView.addAction(action)
        }
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func setDeviceUser(index: Int) {
        PlistManager.sharedInstance.saveValue("000" + String(index), forKey: "Device User")
    }

}
