//
//  Message.swift
//  Movie Club
//
//  Created by Parth Mehta on 10/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import Foundation

class Message {
    
    // MARK: Properties
    var id: String
    var text = ""
    var photo = ""
    var sender: String
    
    // MARK: - Initialisation
    init(messageWithId messageId: String, withContent content: String, havingContentType contentType: String, sentBy messageSender: String) {
        self.id = messageId
        self.sender = messageSender
        
        if contentType == "photo" {
            self.photo = content
        } else {
            self.text = content
        }
    }
}