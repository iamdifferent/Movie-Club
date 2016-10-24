//
//  Discussion.swift
//  Movie Club
//
//  Created by Parth Mehta on 10/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import Foundation

class Discussion {
    
    // MARK: - Properties
    var id: String
    var movieId: String
    var messages: [String]
    
    
    // MARK: - Initialisation
    init(discussionWithId: String, forMovieWithId movie: String, containingMessages discussionMessages: [String]) {
        self.id = discussionWithId
        self.movieId = movie
        self.messages = discussionMessages
    }
    
    
    // MARK: - Add Message
    func addMessageToDiscussionHavingMessageId(messageId: String) {
        if Int(messageId) > messages.count {
            messages.append(messageId)
        }
    }
}
