//
//  FriendTripViewController.swift
//  sadajura
//
//  Created by 佐藤一輝 on 2015/09/19.
//  Copyright © 2015年 whomentors. All rights reserved.
//

import UIKit
import Parse

class FriendTripViewController: UIViewController {
    var flights :[Flight]?
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        
        initNavBar() 
        
        super.viewDidLoad()
        Flight.findOthers { (flights, error) -> Void in
            if error == nil {
                self.flights = flights
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initNavBar() {
        
        // configure the navigation bar
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationbarColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.title = "Friends"
    }
    
}

extension FriendTripViewController :UITableViewDelegate{
    func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("FlightDetailViewController") as!
            FlightDetailViewController
        vc.flight = self.flights![indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FriendTripViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = flights?.count{
            return count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendTripTableViewCell", forIndexPath: indexPath) as! FriendTripTableViewCell
        
        
        cell.userImage.layer.cornerRadius = cell.userImage.frame.width / 2
        cell.userImage.layer.masksToBounds = true

        
        if let flight = self.flights?[indexPath.row] {
            flight.user.profileImage?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil {
                    let img = UIImage(data: data!)
                    cell.userImage.image = img
                }
            })
            
            cell.userName.text = flight.user.username
            cell.from.text = flight.from
            cell.to.text = flight.to
            cell.date.text = NSDate.ISOStringFromDate(flight.date)
        } else {
           print("flight nothing")
        }

        return cell
    }
}
