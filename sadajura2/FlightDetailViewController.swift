//
//  FlightDetailViewController.swift
//  sadajura
//
//  Created by 佐藤一輝 on 2015/09/20.
//  Copyright © 2015年 whomentors. All rights reserved.
//

import UIKit

class FlightDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Identifier生成.
        let myAnnotationIdentifier: NSString = "myAnnotation"
        
        // アノテーション生成.
        var myAnnotationView: MKAnnotationView!
        
        if myAnnotationView == nil {
            
            myAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: myAnnotationIdentifier as String)
            
            // アノテーションに画像を追加.
            myAnnotationView.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "gruMap-pin-icon.png"))
            
            //画面遷移用ボタン
            let btn = UIButton(type: .DetailDisclosure)
            myAnnotationView.rightCalloutAccessoryView = btn
            
            // アノテーションのコールアウトを許可.
            myAnnotationView.canShowCallout = true
        }
        
        // 画像を選択.
        myAnnotationView.image = UIImage(named: "gruMap-pin-icon.png")!
        myAnnotationView.annotation = annotation
        
        return myAnnotationView
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //get tag here
        if(annotationView.tag == 0){
            //Do for 0 pin
        }
        
        if control == annotationView.rightCalloutAccessoryView {
            performSegueWithIdentifier("mapToShopDetail", sender: self)
        }
    }
    
    //傾きが変更された時に呼び出されるメソッド.
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //println("regionDidChangeAnimated")
    }
}