//
//  SIMProductViewController.swift
//  sadajura
//
//  Created by 佐藤一輝 on 2015/09/20.
//  Copyright © 2015年 whomentors. All rights reserved.
//

import UIKit

class SIMProductViewController: UIViewController, SIMChargeCardViewControllerDelegate{
    var chargeVC :SIMChargeCardViewController = SIMChargeCardViewController(publicKey: "asld;fjas:dfjaep:o")
    
    override func viewDidAppear(animated: Bool) {
        chargeVC.delegate = self
        self.navigationController?.presentViewController(chargeVC, animated: true, completion: nil)
    }
    
   
    func creditCardTokenProcessed(token: SIMCreditCardToken!) {
    }
    
    func creditCardTokenFailedWithError(error: NSError!) {
    }
    
    func chargeCardCancelled() {
    }
    
}
