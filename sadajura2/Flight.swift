//
//  Flight.swift
//  sadajura
//
//  Created by shiga yuichi on 9/20/15.
//  Copyright © 2015 whomentors. All rights reserved.
//

import Parse

class Flight: PFObject, PFSubclassing {
    
    // MARK: - Public API
    @NSManaged public var user: User!
    @NSManaged public var date: NSDate!
    @NSManaged public var from: String?
    @NSManaged public var to: String?
    
    // MARK: - Initialize
    private override init()
    {
        super.init()
    }
    
    convenience init(user:User, date:NSDate, to:String, from:String) {
        self.init()
        self.user = user
        self.date = date
        self.to = to
        self.from = from
    }
    
    // MARK: - PFSubclassing
    override public class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    public static func parseClassName() -> String {
        return "Flight"
    }
    
    class func findOthers(block:(flights:[Flight], error:NSError?)-> Void) {
        let query = PFQuery(className: Flight.parseClassName())
        query.cachePolicy = PFCachePolicy.NetworkElseCache
        query.includeKey("user")
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
            var flights = [Flight]()
            if error == nil {
                flights = objects as! [Flight]
            } else {
                print("\(error?.localizedDescription)", terminator: "")
            }
            block(flights: flights, error:error)
        })
    }
    
    class func findByMe(block:(flights:[Flight], error:NSError?)-> Void) {
        Flight.findByUser(User.currentUser()!, block: block)
    }
    
    class func findByUser(user:User, block:(flights:[Flight], error:NSError?)-> Void) {
        
        let query = PFQuery(className: Flight.parseClassName())
        query.cachePolicy = PFCachePolicy.NetworkElseCache
        query.whereKey("user", equalTo: user)
        query.includeKey("user")
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
            var flights = [Flight]()
            if error == nil {
                flights = objects as! [Flight]
            } else {
                print("\(error?.localizedDescription)", terminator: "")
            }
            block(flights: flights, error:error)
        })
        
    }
}
