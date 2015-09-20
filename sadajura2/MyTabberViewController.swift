//
//  MyTabberViewController.swift
//  sadajura
//
//  Created by shiga yuichi on 9/20/15.
//  Copyright © 2015 whomentors. All rights reserved.
//

import Foundation

class MyTabberViewController: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
