//
//  User.swift
//  sadajura
//
//  Created by shiga yuichi on 9/19/15.
//  Copyright © 2015 whomentors. All rights reserved.
//

import Parse

public class User: PFUser
{
    
    @NSManaged public var profileImage: PFFile?
    
    override init()
    {
        super.init()
        
    }
    
    func setProfileImageByUIImage(image:UIImage){
        self.profileImage = createPFFileByUIImage(image)
    }
    
    // MARK: - Private
    private func createPFFileByUIImage(image:UIImage)-> PFFile {
        let imageData = UIImageJPEGRepresentation(image, 0.8)!
        let file = PFFile(name: "image.jpg", data: imageData)
        return file
    }
    
    override public class func initialize()
    {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}