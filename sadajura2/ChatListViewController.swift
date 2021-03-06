//
//  FriendTripViewController.swift
//  sadajura
//
//  Created by 佐藤一輝 on 2015/09/19.
//  Copyright © 2015年 whomentors. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {
    
    var requests:[Request] = [Request]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fetchRequests()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchRequests(){
       Request.findByMe{ (requests, error) -> Void in
        
            if error == nil {
                self.requests = requests
                self.tableView.reloadData()
            }
        }
    }
    
    func initNavBar() {
        
        // configure the navigation bar
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationbarColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.title = "Requests"
    }
    
}

extension ChatListViewController :UITableViewDelegate{
    func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ChatView") as! ChatViewController
        vc.request = self.requests[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChatListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatListViewCell", forIndexPath: indexPath) as! ChatListViewCell
        
        let request = self.requests[indexPath.row]
        cell.userImage.layer.cornerRadius = cell.userImage.frame.width / 2
        cell.userImage.layer.masksToBounds = true
        
        // sender
        if User.currentUser()!.objectId == request.sender.objectId {
            cell.userName.text = request.receiver!.username!
            
            request.receiver.profileImage?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil {
                    let image = UIImage(data:data!)
                    cell.userImage.image = image
                }
            })
        } else {
            cell.userName.text = request.sender!.username!
            request.sender.profileImage?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil {
                    let image = UIImage(data:data!)
                    cell.userImage.image = image
                }
            })
        }
        
        cell.travelRegion.text = request.product 
        
        return cell
    }
}
