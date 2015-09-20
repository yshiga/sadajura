//
//  Request.swift
//  sadajura
//
//  Created by shiga yuichi on 9/20/15.
//  Copyright © 2015 whomentors. All rights reserved.
//
import Parse

class Request: PFObject, PFSubclassing {
    
    // MARK: - Public API
    @NSManaged public var flight: Flight!
    @NSManaged public var sender: User!
    @NSManaged public var receiver: User!
    @NSManaged public var product: String!
    @NSManaged public var desc: String!
    @NSManaged public var image: PFFile!
    
    // MARK: - Initialize
    private override init()
    {
        super.init()
    }
    
    convenience init(flight:Flight, sender:User, receiver:User, product:String, desc:String, image:UIImage?) {
        self.init()
        
        self.flight = flight
        self.sender = sender
        self.receiver = receiver
        self.product = product
        self.desc = desc
        
        if image != nil {
            self.image = createPFFileByUIImage(image!.resizeM())
        }
        
    }
    
    // MARK: - Private
    private func createPFFileByUIImage(image:UIImage)-> PFFile {
        let imageData = UIImageJPEGRepresentation(image, 0.8)!
        let file = PFFile(name: "image.jpg", data: imageData)
        return file
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
        return "Request"
    }
    
    class func findByMe(block:(request:[Request], error:NSError?)-> Void) {
    
        let predicate:NSPredicate = NSPredicate(format: "receiver=%@ OR sender=%@", User.currentUser()!, User.currentUser()!)
        
        let query = PFQuery(className: Request.parseClassName(), predicate:predicate)
        query.cachePolicy = PFCachePolicy.NetworkElseCache
        
        query.includeKey("sender")
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
            var requests = [Request]()
            if error == nil {
                requests = objects as! [Request]
            } else {
                print("\(error?.localizedDescription)", terminator: "")
            }
            block(request: requests, error: error)
        })
    }
    
    
    class func findByRequestToMe(block:(request:[Request], error:NSError?)-> Void) {
    
        let query = PFQuery(className: Request.parseClassName())
        query.cachePolicy = PFCachePolicy.NetworkElseCache
        query.whereKey("receiver", equalTo: User.currentUser()!)
        query.includeKey("sender")
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
            var requests = [Request]()
            if error == nil {
                requests = objects as! [Request]
            } else {
                print("\(error?.localizedDescription)", terminator: "")
            }
            block(request: requests, error: error)
        })
    }
    
    class func findByFlight(flight:Flight, block:(request:[Request], error:NSError?)-> Void) {
        
        let query = PFQuery(className: Request.parseClassName())
        query.cachePolicy = PFCachePolicy.NetworkElseCache
        query.whereKey("flight", equalTo: flight)
        query.includeKey("sender")
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
            var requests = [Request]()
            if error == nil {
                requests = objects as! [Request]
            } else {
                print("\(error?.localizedDescription)", terminator: "")
            }
            block(request: requests, error: error)
        })
        
    }
}
