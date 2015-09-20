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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    @IBAction func didCreateClick(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterFlightViewController") as! RegisterFlightViewController
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        
    }
}

extension ProfileViewController:UITableViewDelegate{
    func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {

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
        cell.titleLabel.text = flight.to!
        cell.infoLabel.text = "from " + flight.from!
        
        return cell
    }
}

