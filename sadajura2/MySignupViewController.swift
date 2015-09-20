//
//  MySignupViewController.swift
//  sadajura
//
//  Created by shiga yuichi on 9/19/15.
//  Copyright © 2015 whomentors. All rights reserved.
//

import Foundation
import Parse
import ParseUI

// custmize sign up view
// @see https://parse.com/docs/ios/guide#user-interface-pfsignupviewcontroller
class MySignUpViewController : PFSignUpViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let logoView = UIImageView(image: UIImage(named: "logo.png"))
//        self.signUpView.logo = logoView // 'logo' can be any UIView
        
        //        self.view.backgroundColor = UIColor.darkGrayColor()

    }
}