//
//  Movie.swift
//  Movie Club
//
//  Created by Parth Mehta on 7/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import Foundation

class Movie {
    
    // MARK: Properties
    var id: String
    var name: String
    var director: String
    var actors: String
    var poster: String
    var story: String
    var year: String
    
    
    // MARK: Initialisation
    init(movieWithId: String, Title title: String, directedBy director: String, performedBy actors: String, releasedIn year: String, tellingTheStory story: String, havingThePosterAs poster: String) {
        self.id = movieWithId
        self.name = title
        self.director = director
        self.actors = actors
        self.poster = poster
        self.story = story
        self.year = year
    }
}