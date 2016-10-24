//
//  Member.swift
//  Movie Club
//
//  Created by Parth Mehta on 7/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import Foundation
import CoreData

class Member {
    
    // MARK: - Properties
    var id: String
    var name: String
    var nickname: String = ""
    var description: String = ""
    var moviesWatched = [String]()
    var moviesWantToWatch = [String]()
    private var updateRequired = false
    
    // MARK: - Initialising
    init(memberWithId: String, havingName memberName: String, addressedFondlyBy nickName: String, describedBy bio: String, havingWatched: [String], wantingToWatch: [String]) {
        self.id = memberWithId
        self.name = memberName
        self.nickname = nickName
        self.description = bio
        
        moviesWatched = havingWatched
        
        moviesWantToWatch = wantingToWatch
    }
    
    func addToWatched(movieId: String) {
        if !moviesWatched.contains(movieId) {
            removeFromWishlist(movieId)
            
            moviesWatched.append(movieId)
            print(moviesWatched)
            
            updateRequired = true
        }
    }
    
    func hasWatchedTheMovie(movieId: String) -> Bool {
        
        if moviesWatched.contains(movieId) {
            return true
        }
        
        return false
    }
    
    func wantsToWatchTheMovie(movieId: String) -> Bool {
        
        if moviesWantToWatch.contains(movieId) {
            return true
        }
        
        return false
    }
    
    func removeFromWatched(movieId: String) {
        if moviesWatched.contains(movieId) {
            let index = moviesWatched.indexOf(movieId)
            
            moviesWatched.removeAtIndex(index!)
            print(moviesWatched)
            
            updateRequired = true
        }
    }
    
    func addToWishlist(movieId: String) {
        // can only add movie to wishlist if not already watched
        if !moviesWantToWatch.contains(movieId) {
            moviesWantToWatch.append(movieId)
            print(moviesWantToWatch)
            updateRequired = true
        }
    }
    
    func removeFromWishlist(movieId: String) {
        if moviesWantToWatch.contains(movieId) {
            let index = moviesWantToWatch.indexOf(movieId)
            
            moviesWantToWatch.removeAtIndex(index!)
            print(moviesWantToWatch)
            updateRequired = true
        }
    }
    
    func needsToUpdatePersonalDetails() -> Bool {
        return updateRequired
    }
    
    func updatesSuccessfullySaved() {
        updateRequired = false
    }
}
