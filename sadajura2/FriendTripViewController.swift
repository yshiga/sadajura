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
        
        cell.userImage.image = UIImage(named: "yuichi")
        
        if let flight = self.flights?[indexPath.row] {
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
