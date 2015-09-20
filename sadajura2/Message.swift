//
//  Message.swift
//  sadajura
//
//  Created by shiga yuichi on 9/19/15.
//  Copyright © 2015 whomentors. All rights reserved.
//

import Foundation
import Parse

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
    
    // MARK: - Private
    private func createPFFileByUIImage(image:UIImage)-> PFFile {
        let imageData = UIImageJPEGRepresentation(image, 0.8)!
        let file = PFFile(name: "image.jpg", data: imageData)
        return file
    }
}
