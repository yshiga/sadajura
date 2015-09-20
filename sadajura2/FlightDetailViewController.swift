//
//  FlightDetailViewController.swift
//  sadajura
//
//  Created by 佐藤一輝 on 2015/09/20.
//  Copyright © 2015年 whomentors. All rights reserved.
//

import UIKit
import MapKit
import ParseUI
import DZNEmptyDataSet

class FlightDetailViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var flight:Flight?
    var requests:[Request] = [Request]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.tableFooterView = UIView()
    }
    
    
    func fetchRequests() {
        
        Request.findByFlight(self.flight!, block:{(requests, error)->Void in
            if error != nil {
                self.requests = requests
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        userNameLabel.text = flight!.user!.username
        flight!.user!.profileImage?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                let image = UIImage(data: data!)
                self.profileImage.image = image
            }
        })
        

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var myLat: CLLocationDegrees = 37.7815907
        var myLon: CLLocationDegrees = -122.405511
        
        switch flight!.to! {
            case "Tokyo":
                myLat = 35.6833
                myLon = 139.6833
            case "Seoul":
                myLat = 37.5667
                myLon = 126.9667
            default:
                break
        }

        let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLat, myLon)
        let myLatDist : CLLocationDistance = 1000000
        let myLonDist : CLLocationDistance = 1000000
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist);
        mapView.setRegion(myRegion, animated: true)
        
        self.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didRequestClick(sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SubmitViewController") as! SubmitViewController
        
        vc.flight = self.flight!
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        
    }
}

extension FlightDetailViewController :UITableViewDelegate{
    func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = SubmitViewController()
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
extension FlightDetailViewController :UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FlightDetailTableViewCell", forIndexPath: indexPath) as! FlightDetailTableViewCell
        
        let request = self.requests[indexPath.row]
        
        request.sender.profileImage?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                let image = UIImage(data: data!)
                cell.userImage.image = image
                cell.userImage.layer.cornerRadius = 25
            }
        })
        
        cell.userName.text = request.sender!.username!
        cell.travelRegion.text = request.product
        return cell
    }
}

extension FlightDetailViewController :MKMapViewDelegate{
    //傾きが変更された時に呼び出されるメソッド.
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //println("regionDidChangeAnimated")
    }
}

extension FlightDetailViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "no one has requested yet"
        return NSAttributedString(string: text)
    }
}