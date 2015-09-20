//
//  UIImage+Resize.swift
//  sadajura
//
//  Created by shiga yuichi on 9/20/15.
//  Copyright © 2015 whomentors. All rights reserved.
//

extension UIImage {
    
    func resizeS()->UIImage{
        return self.resize(100,height:100)
    }
    
    func resizeM()->UIImage{
        return self.resize(200,height:200)
    }
    
    func resize(width:Int, height:Int)->UIImage {
        
        let origRef = self.CGImage;
        let origWidth  = Int(CGImageGetWidth(origRef))
        let origHeight = Int(CGImageGetHeight(origRef))
        var resizeWidth:Int = 0, resizeHeight:Int = 0
        
        if (origWidth < origHeight) {
            resizeWidth = width
            resizeHeight = origHeight * resizeWidth / origWidth
            
        } else {
            resizeHeight = height
            resizeWidth = origWidth * resizeHeight / origHeight
        }
        
        let resizeSize = CGSizeMake(CGFloat(resizeWidth), CGFloat(resizeHeight))
        UIGraphicsBeginImageContext(resizeSize)
        
        self.drawInRect(CGRectMake(0, 0, CGFloat(resizeWidth), CGFloat(resizeHeight)))
        
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return resizeImage
    }
}