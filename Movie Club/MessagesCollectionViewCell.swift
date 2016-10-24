//
//  MessagesCollectionViewCell.swift
//  Movie Club
//
//  Created by Parth Mehta on 13/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit

class MessagesCollectionViewCell: UICollectionViewCell {
    
    var messageType = "text"
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "MoskLight300", size: 17)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clearColor()
        textView.userInteractionEnabled = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    func prepareReceivedCell() {
        textBubbleView.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 0.09)
        messageTextView.textColor = UIColor.blackColor()
        
        if messageType == "text" {
            prepareReceivedTextCell()
        } else {
            prepareReceivedPhotoCell()
        }
    }
    
    func prepareSentCell() {
        textBubbleView.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 0.54)
        messageTextView.textColor = UIColor.whiteColor()
        
        if messageType == "text" {
            prepareSentTextCell()
        } else {
            prepareSentPhotoCell()
        }
    }
    
    private func prepareReceivedTextCell() {
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profilePicture)
    }
    
    private func prepareReceivedPhotoCell() {
        
    }
    
    private func prepareSentTextCell() {
        addSubview(textBubbleView)
        addSubview(messageTextView)
    }
    
    private func prepareSentPhotoCell() {
        
    }
}
