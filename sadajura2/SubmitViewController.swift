//
//  SubmitViewController.swift
//  sadajura
//
//  Created by 佐藤一輝 on 2015/09/20.
//  Copyright © 2015年 whomentors. All rights reserved.
//

import UIKit
import ParseUI
import PhotoTweaks

class SubmitViewController: UIViewController {
    
    var flight:Flight?

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDescTextView: UITextView!
    
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var requstToUserImage: PFImageView!
    @IBOutlet weak var requestToUserName: UILabel!
    
    var imagePicker :UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestToUserName.text = flight!.user.username
        
       // configure the navigation bar
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.barTintColor = UIColor.navigationbarColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        
        flight!.user.profileImage?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                let image = UIImage(data:data!)
               self.requstToUserImage.image = image
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func didCancelClick(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func didSubmitClick(sender: AnyObject) {
        let newRequest = Request(flight: flight!, sender: User.currentUser()!, receiver:flight!.user, product: productNameTextField.text!, desc: productDescTextView.text, image: productImageView.image)
        
        newRequest.saveInBackgroundWithBlock { (result, error) -> Void in
            if error == nil {
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                MyAlertView.showErrorAlert(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func didChangeImageClick(sender: AnyObject) {
        presentCamera()
    }
    @IBAction func didImageClick(sender: AnyObject) {
        presentCamera()
    }
    
    func presentCamera() {
        self.imagePicker = UIImagePickerController()
//        self.imagePicker!.allowsEditing = true
        self.imagePicker!.delegate = self
        self.imagePicker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(self.imagePicker!, animated: true, completion: nil)
    }
}

extension SubmitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        let photoTweaksViewController = PhotoTweaksViewController(image: image)
        photoTweaksViewController.delegate = self
        picker.presentViewController(photoTweaksViewController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SubmitViewController: PhotoTweaksViewControllerDelegate {
    func photoTweaksController(controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        
        self.productImageView.image = croppedImage
        controller.dismissViewControllerAnimated(true, completion:{
                self.imagePicker!.dismissViewControllerAnimated(false, completion: nil)
        })
    }
    
    func photoTweaksControllerDidCancel(controller: PhotoTweaksViewController!) {
    controller.dismissViewControllerAnimated(true, completion: {
            self.imagePicker!.dismissViewControllerAnimated(false, completion: nil)
    });
}
}

