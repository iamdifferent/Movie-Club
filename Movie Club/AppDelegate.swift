//
//  AppDelegate.swift
//  Movie Club
//
//  Created by Parth Mehta on 16/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit
import CoreData

var members = [Member]()
var memberObjects = [NSManagedObject]()
var movies = [Movie]()
var discussions = [Discussion]()
var discussionObjects = [NSManagedObject]()
var messages = [Message]()
var messagesObjects = [NSManagedObject]()

// Global Constants
let movieIdKey = "id"
let movieNameKey = "name"
let movieDirectoryKey = "director"
let movieStoryKey = "story"
let movieActorsKey = "actors"
let moviePosterKey = "poster"
let movieReleaseYearKey = "year"

let memberIdKey = "id"
let memberNameKey = "name"
let memberDescriptionKey = "about"
let memberNicknameKey = "nickname"
let memberMoviesWatchedKey = "watched"
let memberMoviesWantToWatchKey = "wishlist"

let messageIdKey = "id"
let messageTypeKey = "type"
let messageContentKey = "content"
let messageSenderKey = "sender"

let discussionIdKey = "id"
let discussionMovieKey = "movie"
let discussionMessagesKey = "messages"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        PlistManager.sharedInstance.startPlistManager()
        
        let membersLoaded = PlistManager.sharedInstance.getValueForKey("Members Loaded") as! Bool
        if !membersLoaded {
            loadMembersFromSource()
        } else {
            loadMembersFromDatabase()
        }
        
        
        let moviesLoaded = PlistManager.sharedInstance.getValueForKey("Movies Loaded") as! Bool
        if !moviesLoaded {
            loadMoviesFromSource()
        } else {
            loadMoviesFromDatabase()
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "uk.co.plymouthsoftware.core_data" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Movie Club Data", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("MovieClub.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
        
        
        // MARK: - Loading Members
        
        func loadMembersFromSource() {
            let memberDetails = getDataFromCSV("Members Data")
            
            if memberDetails != [] {
                
                print("No of members: \(memberDetails.count)")
                for memberIndex in 0 ..< memberDetails.count - 1 {
                    let components = memberDetails[memberIndex].componentsSeparatedByString(",--")
                    
                    // format nickname
                    var nickname = components[0]
                    if nickname.rangeOfString("\n") != nil {
                        nickname = nickname.substringWithRange(nickname.rangeOfString("\n")!.startIndex.advancedBy(1) ..< nickname.rangeOfString("\n")!.endIndex)
                        //substring(with: (nickname.range(of: "\n")?.index(nickname.range(of: "\n")?.startIndex, offsetBy: 1))! ..< nickname.endIndex)
                    }
                    
                    var name = components[1]
                    if name.rangeOfString("\n") != nil {
                        name = name.substringWithRange(name.rangeOfString("\n")!.startIndex.advancedBy(1) ..< name.rangeOfString("\n")!.endIndex)
                    }
                    
                    let about = components[2]
                    let id = "000" + String(memberIndex + 1)
                    
                    print("\(id), \(name), \(nickname), \(about)")
                    
                    saveMemberWithName(name, havingNickName: nickname, havingDescription: about, andId: id)
                    
                    if memberIndex == memberDetails.count - 2 {
                        PlistManager.sharedInstance.saveValue(true, forKey: "Members Loaded")
                    }
                }
            }
        }
        
        func getDataFromCSV(fileName: String) -> [String] {
            if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: ".csv") {
                do {
                    let contents = try NSString(contentsOfFile: filePath, usedEncoding: nil) as String
                    let rows = contents.componentsSeparatedByString("\r")
                    
                    print("No of Members in CSV : \(rows.count)")
                    return rows
                } catch {
                    // contents couldn't be loaded
                    print("Could not load right now")
                    return []
                }
            } else {
                // file not found
                print("File not found")
                return []
            }
        }
        
        func saveMemberWithName(name: String, havingNickName nickName: String, havingDescription description: String, andId id: String) {
            
            let memberExists = checkForExistingMember(name)
            
            if !memberExists {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                
                let entity = NSEntityDescription.entityForName("Members", inManagedObjectContext: managedContext)
                let memberObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                
                // set values
                memberObject.setValue(name, forKey: memberNameKey)
                memberObject.setValue(nickName, forKey: memberNicknameKey)
                memberObject.setValue(description, forKey: memberDescriptionKey)
                memberObject.setValue(id, forKey: memberIdKey)
                memberObject.setValue("", forKey: memberMoviesWatchedKey)
                memberObject.setValue("", forKey: memberMoviesWantToWatchKey)
                
                // create Member object
                let memberEntity = Member(memberWithId: id, havingName: name, addressedFondlyBy: "", describedBy: description, havingWatched: [], wantingToWatch: [])
                
                // try to save
                do {
                    try managedContext.save()
                    members.append(memberEntity)
                    memberObjects.append(memberObject)
                    print("\(name) saved")
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        
        func checkForExistingMember(memberName: String) -> Bool {
            print("Checking : \(memberName)")
            for index in 0 ..< members.count {
                if members[index].name == memberName {
                    return true
                }
            }
            
            return false
        }
        
        func loadMembersFromDatabase() {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let fetchRequest = NSFetchRequest(entityName: "Members")
            
            do {
                let results = try managedContext.executeFetchRequest(fetchRequest)
                memberObjects = results as! [NSManagedObject]
                for index in 0 ..< memberObjects.count {
                    let id = memberObjects[index].valueForKey(memberIdKey) as? String
                    let name = memberObjects[index].valueForKey(memberNameKey) as? String
                    let description = memberObjects[index].valueForKey(memberDescriptionKey) as? String
                    let nickname = memberObjects[index].valueForKey(memberNicknameKey) as? String
                    
                    let watched = memberObjects[index].valueForKey(memberMoviesWatchedKey) as? String
                    var watchedMovies = [String]()
                    if watched != nil {
                        watchedMovies = watched!.componentsSeparatedByString("---")
                    }
                    
                    let wishlist = memberObjects[index].valueForKey(memberMoviesWantToWatchKey) as? String
                    var wishListMovies = [String]()
                    if wishlist != nil {
                        wishListMovies = wishlist!.componentsSeparatedByString("---")
                    }
                    
                    members.append(Member(memberWithId: id!, havingName: name!, addressedFondlyBy: nickname!, describedBy: description!, havingWatched: watchedMovies, wantingToWatch: wishListMovies))
                }
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        // MARK: - Load Movies
        func loadMoviesFromSource() {
            let movieDetails = getDataFromCSV("Movie Details")
            
            if movieDetails != [] {
                // get all details and add to database
                
                print("No of Movies : \(movieDetails.count)")
                for movieIndex in 0 ... movieDetails.count - 1 {
                    let components = movieDetails[movieIndex].componentsSeparatedByString("--;,")
                    print(components)
                    
                    // Helper variable
                    var index: Int
                    
                    // format name
                    var name = components[0]
                    if name != "" {
                        
                        // check first character
                        if let range = name.rangeOfString("\"") {
                            index = name.startIndex.distanceTo(range.startIndex)
                            
                            if index == 0 {
                                name = name.substringWithRange(name.startIndex.advancedBy(1) ..< name.endIndex)
                            }
                        }
                        
                        // check for last character
                        if let range = name.rangeOfString("\"", options: NSStringCompareOptions.BackwardsSearch) {
                            index = name.endIndex.distanceTo(range.endIndex)
                            
                            if index == 0 {
                                name = name.substringWithRange(name.startIndex ..< name.endIndex.advancedBy(-1))
                            }
                        }
                        
                        // Check for new line character
                        if let range = name.rangeOfString("\n") {
                            index = name.startIndex.distanceTo(range.startIndex)
                            
                            if index == 0 {
                                name = name.substringWithRange(name.startIndex.advancedBy(1) ..< name.endIndex)
                            }
                        }
                    }
                    print(name)
                    
                    // format director
                    var director = components[1]
                    if director != "" {
                        
                        // check first character
                        if let range = director.rangeOfString("\"") {
                            index = director.startIndex.distanceTo(range.startIndex)
                            
                            if index == 0 {
                                director = director.substringWithRange(director.startIndex.advancedBy(1) ..< director.endIndex)
                            }
                        }
                        
                        // check for last character
                        if let range = director.rangeOfString("\"", options: NSStringCompareOptions.BackwardsSearch) {
                            index = director.endIndex.distanceTo(range.endIndex)
                            
                            if index == 0 {
                                director = director.substringWithRange(director.startIndex ..< director.endIndex.advancedBy(-1))
                            }
                        }
                        
                        // Check for new line character
                        if let range = director.rangeOfString("\n") {
                            index = director.startIndex.distanceTo(range.startIndex)
                            
                            if index == 0 {
                                director = director.substringWithRange(director.startIndex.advancedBy(1) ..< director.endIndex)
                            }
                        }
                    }
                    
                    
                    let year = components[2] // no need to format year
                    
                    
                    // format story
                    var story = components[3]
                    if story != "" {
                        
                        // check first character
                        if let range = story.rangeOfString("\"") {
                            index = story.startIndex.distanceTo(range.startIndex)
                            
                            if index == 0 {
                                story = story.substringWithRange(story.startIndex.advancedBy(1) ..< story.endIndex)
                            }
                        }
                        
                        // check for last character
                        if let range = story.rangeOfString("\"", options: NSStringCompareOptions.BackwardsSearch) {
                            index = story.endIndex.distanceTo(range.endIndex)
                            
                            if index == 0 {
                                story = story.substringWithRange(story.startIndex ..< story.endIndex.advancedBy(-1))
                            }
                        }
                        
                        // Check for new line character
                        if let range = story.rangeOfString("\n") {
                            index = story.startIndex.distanceTo(range.startIndex)
                            
                            if index == 0 {
                                story = story.substringWithRange(story.startIndex.advancedBy(1) ..< story.endIndex)
                            }
                        }
                    }
                    
                    
                    // format actors
                    var actors = components[4]
                    if actors != "" {
                        
                        // check first character
                        if let range = actors.rangeOfString("\"") {
                            index = actors.startIndex.distanceTo(range.startIndex)
                            
                            if index == 0 {
                                actors = actors.substringWithRange(actors.startIndex.advancedBy(1) ..< actors.endIndex)
                            }
                        }
                        
                        // check for last character
                        if let range = actors.rangeOfString("\"", options: NSStringCompareOptions.BackwardsSearch) {
                            index = actors.endIndex.distanceTo(range.endIndex)
                            
                            if index == 0 {
                                actors = actors.substringWithRange(actors.startIndex ..< actors.endIndex.advancedBy(-1))
                            }
                        }
                        
                        // Check for new line character
                        if let range = actors.rangeOfString("\n") {
                            index = actors.startIndex.distanceTo(range.startIndex)
                            
                            if index == 0 {
                                actors = actors.substringWithRange(actors.startIndex.advancedBy(1) ..< actors.endIndex)
                            }
                        }
                    }
                    
                    
                    // format poster url
                    var poster = components[5]
                    if poster != "" {
                        
                        // check first character
                        if let range = poster.rangeOfString("\"") {
                            index = poster.startIndex.distanceTo(range.startIndex)
                            
                            if index == 0 {
                                poster = poster.substringWithRange(poster.startIndex.advancedBy(1) ..< poster.endIndex)
                            }
                        }
                        
                        // check for last character
                        if let range = poster.rangeOfString("\"", options: NSStringCompareOptions.BackwardsSearch) {
                            index = poster.endIndex.distanceTo(range.endIndex)
                            
                            if index == 0 {
                                poster = poster.substringWithRange(poster.startIndex ..< poster.endIndex.advancedBy(-1))
                            }
                        }
                        
                        // Check for new line character
                        if let range = poster.rangeOfString("\n") {
                            index = poster.startIndex.distanceTo(range.startIndex)
                            
                            if index == 0 {
                                poster = poster.substringWithRange(poster.startIndex.advancedBy(1) ..< poster.endIndex)
                            }
                        }
                        
                        // replace http with https for App Transport Security
                        if let range = poster.rangeOfString("http") {
                            poster = poster.substringWithRange(range.endIndex.advancedBy(1) ..< poster.endIndex)
                            
                            poster = "https:" + poster
                        }
                    }
                    
                    
                    let id = "000" + String(movieIndex)
                    saveMovie(id, Title: name, withDirector: director, releasedIn: year, withStory: story, havingPoster: poster, andPerformedBy: actors)
                    
                    if movieIndex == movies.count - 1 {
                        PlistManager.sharedInstance.saveValue(true, forKey: "Movies Loaded")
                    }
                }
            }
        }
        
        func saveMovie(withId: String, Title title: String, withDirector director: String, releasedIn year: String, withStory story: String, havingPoster poster: String, andPerformedBy actors: String) {
            
            let movieExists = checkForExistingMovie(title)
            
            if !movieExists {
                // write movie to database
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                
                let entity = NSEntityDescription.entityForName("Movies", inManagedObjectContext: managedContext)
                let movieEntity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                
                // set values
                movieEntity.setValue(withId, forKey: movieIdKey)
                movieEntity.setValue(title, forKey: movieNameKey)
                movieEntity.setValue(director, forKey: movieDirectoryKey)
                movieEntity.setValue(year, forKey: movieReleaseYearKey)
                movieEntity.setValue(poster, forKey: moviePosterKey)
                movieEntity.setValue(story, forKey: movieStoryKey)
                movieEntity.setValue(actors, forKey: movieActorsKey)
                
                // create movie object
                let movieObject = Movie(movieWithId: withId, Title: title, directedBy: director, performedBy: actors, releasedIn: year, tellingTheStory: story, havingThePosterAs: poster)
                
                // try to save
                do {
                    try managedContext.save()
                    movies.append(movieObject)
                    print("\(title) saved")
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        
        func checkForExistingMovie(movieName: String) -> Bool {
            print("Checking \(movieName)")
            for index in 0 ..< movies.count {
                if movies[index].name == movieName {
                    return true
                }
            }
            
            return false
        }
        
        func loadMoviesFromDatabase() {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let fetchRequest = NSFetchRequest(entityName: "Movies")
            
            do {
                let results = try managedContext.executeFetchRequest(fetchRequest)
                let movieCollection = results as! [NSManagedObject]
                for index in 0 ..< movieCollection.count {
                    let id = movieCollection[index].valueForKey(movieIdKey) as? String
                    let name = movieCollection[index].valueForKey(movieNameKey) as? String
                    let director = movieCollection[index].valueForKey(movieDirectoryKey) as? String
                    let story = movieCollection[index].valueForKey(movieStoryKey) as? String
                    let year = movieCollection[index].valueForKey(movieReleaseYearKey) as? String
                    let poster = movieCollection[index].valueForKey(moviePosterKey) as? String
                    let actors = movieCollection[index].valueForKey(movieActorsKey) as? String
                    
                    movies.append(Movie(movieWithId: id!, Title: name!, directedBy: director!, performedBy: actors!, releasedIn: year!, tellingTheStory: story!, havingThePosterAs: poster!))
                }
                
                print("No of Movies : \(movies.count)")
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        func loadDiscussionsFromDatabase() {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let fetchRequest = NSFetchRequest(entityName: "Discussions")
            
            do {
                let results = try managedContext.executeFetchRequest(fetchRequest)
                discussionObjects = results as! [NSManagedObject]
                
                for index in 0 ..< discussionObjects.count {
                    let id = discussionObjects[index].valueForKey(discussionIdKey) as? String
                    let movieId = discussionObjects[index].valueForKey(discussionMovieKey) as? String
                    let messageString = discussionObjects[index].valueForKey(discussionMessagesKey) as? String
                    let messages = messageString?.componentsSeparatedByString("---")
                    discussions.append(Discussion(discussionWithId: id!, forMovieWithId: movieId!, containingMessages: messages!))
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        func loadMessagesFromDatabase() {
            
        }
        
}