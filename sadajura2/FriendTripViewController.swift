//
//  FriendTripViewController.swift
//  sadajura
//
//  Created by 佐藤一輝 on 2015/09/19.
//  Copyright © 2015年 whomentors. All rights reserved.
//

import UIKit

class FriendTripViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension FriendTripViewController :UITableViewDelegate{
    func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
}

extension FriendTripViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendTripTableViewCell", forIndexPath: indexPath) as! FriendTripTableViewCell
        
        cell.userImage.image = UIImage(named: "imageTest")
        cell.userName.text = "Yuichiki Shiga "
        cell.travelRegion.text = "Osaka"
        
        return cell
    }
}
