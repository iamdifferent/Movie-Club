//
//  DiscussionViewController.swift
//  Movie Club
//
//  Created by Parth Mehta on 13/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import Material

class DiscussionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var movieName: String?
    
    @IBOutlet weak var messagesCollectionView: UICollectionView!
    
    let messageCellIdentifier = "MessageCell"
    let discussion = Discussion(discussionWithId: "0001", forMovieWithId: "0001", containingMessages: [])
    let messageStrings = [
        Message(messageWithId: "0001", withContent: "Hi", havingContentType: "text", sentBy: "0001"),
        Message(messageWithId: "0002", withContent: "Hello!", havingContentType: "text", sentBy: "0002"),
        Message(messageWithId: "0003", withContent: "Hi, I am Parth", havingContentType: "text", sentBy: "0003"),
        Message(messageWithId: "0004", withContent: "Hi, I am Batman", havingContentType: "text", sentBy: "0004"),
        Message(messageWithId: "0005", withContent: "Hi, I am Lord Vader", havingContentType: "text", sentBy: "0001"),
        Message(messageWithId: "0006", withContent: "Well, this is just a long message, nothing else", havingContentType: "text", sentBy: "0002"),
        Message(messageWithId: "0007", withContent: "Hi", havingContentType: "text", sentBy: "0004"),
        Message(messageWithId: "0008", withContent: "Hi", havingContentType: "text", sentBy: "0002"),
        Message(messageWithId: "0009", withContent: "Hi", havingContentType: "text", sentBy: "0005"),
        Message(messageWithId: "00010", withContent: "That's most of us!", havingContentType: "text", sentBy: "0001"),
        Message(messageWithId: "00011", withContent: "Well, this is just a long message, nothing else", havingContentType: "text", sentBy: "0002"),
        Message(messageWithId: "00012", withContent: "Hi", havingContentType: "text", sentBy: "0004"),
        Message(messageWithId: "00013", withContent: "Hello!\nHello!", havingContentType: "text", sentBy: "0004"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupActionBar()
        self.tabBarController?.tabBar.hidden = true
        self.messagesCollectionView.backgroundColor = UIColor.whiteColor()
        self.messagesCollectionView.registerClass(MessagesCollectionViewCell.self, forCellWithReuseIdentifier: messageCellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let item = self.collectionView(self.messagesCollectionView, numberOfItemsInSection: 0) - 1
        let itemIndexPath = NSIndexPath(forItem: item, inSection: 0)
        print("item indexPath : \(itemIndexPath)")
        self.messagesCollectionView.scrollToItemAtIndexPath(itemIndexPath, atScrollPosition: .Top, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
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
    
    
    func setupActionBar() {
        let actionBar = UIView(frame: CGRect(x: 0, y: 20, width: screenSize.width, height: 56))
        actionBar.backgroundColor = MaterialColor.white
        actionBar.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        actionBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        actionBar.layer.shadowOpacity = 0.5
        actionBar.layer.shadowRadius = 2
        
        let image: UIImage? = MaterialIcon.cm.arrowBack
        let backButton: IconButton = IconButton()
        backButton.pulseColor = MaterialColor.grey.base
        backButton.tintColor = MaterialColor.black
        backButton.setImage(image, forState: .Normal)
        backButton.setImage(image, forState: .Highlighted)
        backButton.addTarget(self, action: #selector(closeMovieDiscussion), forControlEvents: .TouchUpInside)
        actionBar.addSubview(backButton)
        Layout.topLeft(actionBar, child: backButton, top: 8, left: 10)
        
        let label = UILabel()
        label.text = movieName
        label.textColor = MaterialColor.black
        label.font = UIFont(name: "MoskMedium500", size: 18)
        actionBar.addSubview(label)
        Layout.horizontally(actionBar, child: label, left: 72, right: 56)
        Layout.top(actionBar, child: label, top: 17)
        
        self.view.addSubview(actionBar)
    }
    
    func closeMovieDiscussion() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Collection View Data Source & Delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageStrings.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(messageCellIdentifier, forIndexPath: indexPath) as! MessagesCollectionViewCell
        
        cell.messageTextView.text = messageStrings[(indexPath as NSIndexPath).item].text
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageStrings[(indexPath as NSIndexPath).item].text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont(name: "MoskLight300", size: 17)!], context: nil)
        
        if messageStrings[(indexPath as NSIndexPath).item].sender == "0001" {
            cell.messageTextView.frame = CGRect(x: screenSize.width - estimatedFrame.width - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: screenSize.width - estimatedFrame.width - 16 - 16, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
            cell.prepareSentCell()
        } else {
            
            let member = members[Int(messageStrings[(indexPath as NSIndexPath).item].sender)!]
            cell.profilePicture.image = UIImage(named: member.name)
            cell.profilePicture.frame = CGRect(x: 8, y: estimatedFrame.height - 10, width: 30, height: 30)
            cell.messageTextView.frame = CGRect(x: 8 + 30 + 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: 0 + 30 + 16, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
            cell.prepareReceivedCell()
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: NSIndexPath) -> CGSize {
        let messageText = messageStrings[(indexPath as NSIndexPath).item].text
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont(name: "MoskLight300", size: 17)!], context: nil)
        
        return CGSize(width: self.view.frame.width, height: estimatedFrame.height + 20)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        print("collection view content size : \(scrollView.contentSize)")
    }

}
