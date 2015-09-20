//
//  ProfileViewController.swift
//  sadajura
//
//  Created by 佐藤一輝 on 2015/09/20.
//  Copyright © 2015年 whomentors. All rights reserved.
//

import UIKit
import ParseUI

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabe: UILabel!
    @IBOutlet weak var profileImage: PFImageView!
    
    var flights = [Flight]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        profileImage.layer.cornerRadius =  profileImage.frame.width / 2
        profileImage.layer.masksToBounds = true
        
        userNameLabe.text = User.currentUser()!.username
        
        func initNavBar() {
            
            // configure the navigation bar
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.barTintColor = UIColor.navigationbarColor()
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
            self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
            
            self.title = "Profile"
        }
        
        initNavBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        profileImage.file = User.currentUser()!.profileImage
        profileImage.loadInBackground()
        fetchFlights()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchFlights(){
        Flight.findByMe { (flights, error) -> Void in
            if error == nil {
                self.flights = flights
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func didLogoutClick(sender: AnyObject) {
        User.logOut()
    }
    @IBAction func didCreateClick(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterFlightViewController") as! RegisterFlightViewController
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        
    }

}

extension ProfileViewController:UITableViewDelegate{
    func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("FlightDetailViewController") as!
            FlightDetailViewController
        vc.flight = self.flights[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)

    }
}

extension ProfileViewController :UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flights.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FlightCell", forIndexPath: indexPath) as! ProfileViewFlightCell
        let flight = self.flights[indexPath.row]
        cell.titleLabel.text = flight.to! + "  from  " + flight.from!
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        cell.infoLabel.text =  dateFormatter.stringFromDate(flight.date!)
        
        return cell
    }
}

