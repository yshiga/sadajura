//
//  Message.swift
//  sadajura
//
//  Created by shiga yuichi on 9/19/15.
//  Copyright © 2015 whomentors. All rights reserved.
//

import Foundation
import Parse
import JSQMessagesViewController

class Message: PFObject, PFSubclassing {
    
    // MARK: - Public API
    @NSManaged public var text: String!
    @NSManaged public var sender: User!
    @NSManaged public var receiver: User!
    @NSManaged public var image: PFFile
    
    // MARK: - Initialize
    private override init()
    {
        super.init()
    }
    
    convenience init(sender:User, receiver:User, text:String, image:UIImage?) {
        self.init()
        self.sender = sender
        self.receiver = receiver
        self.text = text
        
        if image != nil {
            self.setImageByUIImages(image!)
        }
    }
    
    // must use
    func setImageByUIImages(image:UIImage) {
        self.image = createPFFileByUIImage(image)
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
        return "Message"
    }
    
    class func find(user1:User, user2:User, block:(messages:[Message], error:NSError?)-> Void) {
        
        let query = PFQuery(className: Message.parseClassName())
        query.cachePolicy = PFCachePolicy.NetworkElseCache
        query.includeKey("sender")
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
            var messages = [Message]()
            if error == nil {
                messages = objects as! [Message]
            } else {
                print("\(error?.localizedDescription)", terminator: "")
            }
            block(messages: messages, error:error)
        })
        
    }
    
    public func convert2JSQMessage()->JSQMessage {
        let msg = JSQMessage.init(senderId: self.objectId, displayName:sender.username , text: self.text)
        return msg
    }
    
    // MARK: - Private
    private func createPFFileByUIImage(image:UIImage)-> PFFile {
        let imageData = UIImageJPEGRepresentation(image, 0.8)!
        let file = PFFile(name: "image.jpg", data: imageData)
        return file
    }
}
