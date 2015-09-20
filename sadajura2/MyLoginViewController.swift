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
        
        self.logInView!.usernameField!.placeholder = "email"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //        self.logInView.logInButton.frame = CGRectMake(...) // Set a different frame.
    }
    
}