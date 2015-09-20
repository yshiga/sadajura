//
//  InitialViewController.swift
//  sadajura
//
//  Created by shiga yuichi on 9/20/15.
//  Copyright © 2015 whomentors. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if User.currentUser() == nil {
            openLoginView()
            
        } else {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TabberController") as! MyTabberViewController
            self.navigationController?.presentViewController(vc, animated: false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func openSignupView(){
        
        let signUpController = MySignUpViewController()
        signUpController.delegate = self
        signUpController.fields = ([PFSignUpFields.UsernameAndPassword, PFSignUpFields.SignUpButton, PFSignUpFields.Email, PFSignUpFields.DismissButton])
       
        self.presentViewController(signUpController, animated: true, completion: nil)
        
    }
    
    func openLoginView(){
        
        logInController = MyLogInViewController()
        logInController!.delegate = self
        logInController!.fields = ([PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton])
        
        let signUpController = MySignUpViewController()
        signUpController.delegate = self
        signUpController.fields = ([PFSignUpFields.UsernameAndPassword, PFSignUpFields.SignUpButton, PFSignUpFields.Email, PFSignUpFields.DismissButton])
        
        logInController!.signUpController = signUpController
        
        self.presentViewController(logInController!, animated:true, completion: nil)
        
    }
    
    var logInController:MyLogInViewController?

}

extension InitialViewController: PFSignUpViewControllerDelegate {
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        signUpController.dismissViewControllerAnimated(true, completion: {()->Void in
            self.logInController!.dismissViewControllerAnimated(true, completion: nil)
        })
        
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        signUpController.dismissViewControllerAnimated(true, completion: nil)
        print(error?.localizedDescription)
        MyAlertView.showErrorAlert(error!.localizedDescription)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
    }
}

extension InitialViewController: PFLogInViewControllerDelegate  {
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        return true
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        logInController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print(error?.localizedDescription, terminator: "")
        MyAlertView.showErrorAlert(error!.localizedDescription)
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        // do nothing
    }
}