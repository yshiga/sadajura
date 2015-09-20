//
//  FlightDetailViewController.swift
//  sadajura
//
//  Created by 佐藤一輝 on 2015/09/20.
//  Copyright © 2015年 whomentors. All rights reserved.
//

import UIKit
import MapKit

class FlightDetailViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 中心点の緯度経度.
        let myLat: CLLocationDegrees = 37.7815907
        let myLon: CLLocationDegrees = -122.405511
        
        let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLat, myLon)
        
        // 縮尺.
        let myLatDist : CLLocationDistance = 100
        let myLonDist : CLLocationDistance = 100
        
        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist);
        
        // MapViewに反映.
        mapView.setRegion(myRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FlightDetailTableViewCell", forIndexPath: indexPath) as! FlightDetailTableViewCell
        
        cell.userImage.image = UIImage(named: "yuichi")
        cell.userName.text = "Yuichiki Shiga "
        cell.travelRegion.text = "Osaka"
        
        return cell
    }
}

extension FlightDetailViewController :MKMapViewDelegate{
    //傾きが変更された時に呼び出されるメソッド.
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //println("regionDidChangeAnimated")
    }
}