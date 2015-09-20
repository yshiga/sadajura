//
//  MyAlertView.swift
//  sadajura
//
//  Created by shiga yuichi on 9/20/15.
//  Copyright © 2015 whomentors. All rights reserved.
//

import SIAlertView

class MyAlertView {
    
    static func showErrorAlert(message:String){
        
        let alertView = SIAlertView(title: "Error", andMessage: message)
        alertView.addButtonWithTitle("OK", type: SIAlertViewButtonType.Default, handler:nil)
        alertView.buttonColor = UIColor.alertOKButtonColor()
        alertView.show()
    }
    
    static func showOKButtonAlert(title:String, message:String){
        let alertView = SIAlertView(title: title, andMessage: message)
        alertView.addButtonWithTitle("OK", type: SIAlertViewButtonType.Default, handler:nil)
        alertView.buttonColor = UIColor.alertOKButtonColor()
        alertView.show()
    }
    
    
    static func showOKCancelButtonAlert(title:String, message:String, okBlock:()->Void, cancelBlock:()->Void) {
        let alertView = SIAlertView(title: title, andMessage: message)
        alertView.addButtonWithTitle("OK", type: SIAlertViewButtonType.Default, handler:{(view)->Void in
            okBlock()
        })
        alertView.addButtonWithTitle("Cancel", type: SIAlertViewButtonType.Default, handler:{(view)->Void in
            cancelBlock()
        })
        alertView.buttonColor = UIColor.alertOKButtonColor()
        alertView.show()
    }
    
}