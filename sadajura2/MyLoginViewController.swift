//
//  MyLoginViewController.swift
//  sadajura
//
//  Created by shiga yuichi on 9/19/15.
//  Copyright © 2015 whomentors. All rights reserved.
//

import Foundation

import Parse
import ParseUI

class MyLogInViewController : PFLogInViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoView = UIImageView(image: UIImage(named: "logo"))
        self.logInView!.logo = logoView // 'logo' can be any UIView
        
        self.logInView!.usernameField!.placeholder = "user name"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //        self.logInView.logInButton.frame = CGRectMake(...) // Set a different frame.
    }
    
}