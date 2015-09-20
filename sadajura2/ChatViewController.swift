//
//  ChatViewController.swift
//  sadajura
//
//  Created by shiga yuichi on 9/19/15.
//  Copyright © 2015 whomentors. All rights reserved.
//

import Foundation
import UIKit
import JSQMessagesViewController
import Parse
import ParseUI
import PhotoTweaks

class ChatViewController: JSQMessagesViewController{
    
    
    let AVATOR_DIAMETER:UInt = 64
    
    var messages = [JSQMessage]()
    var incomingBubble :JSQMessagesBubbleImage?
    var outgoingBubble :JSQMessagesBubbleImage?
    var incomingAvatar :JSQMessagesAvatarImage?
    var outgoingAvatar :JSQMessagesAvatarImage?
    
    var receiver:User? // set by previous viewcontroller
    
    var imagePicker :UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // properties of super class
        self.collectionView!.collectionViewLayout.springinessEnabled = true
        self.senderId = "1"
        self.senderDisplayName = "classmethod"
        
        // set MessageBubble
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        self.outgoingBubble = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
        
        // set avators
        self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named:"ichiki"), diameter: AVATOR_DIAMETER)
        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named:"yuichi"), diameter: AVATOR_DIAMETER)
        
        // message data
        // self.messages = [NSMutableArray array];
        
        
        // debug
       
    }
    
    override func viewDidAppear(animated: Bool) {
        if User.currentUser() == nil {
            openLoginView()
        } else {
            self.senderId = User.currentUser()!.objectId
            receiver = User.currentUser()!
            loadMessages()
        }
    }
    
    func loadMessages(){
        
        Message.find(User.currentUser()!, user2:receiver!, block:{(messages,error)-> Void in
            
            
            self.messages.removeAll()
            for msg in messages {
                var jsqMessage :JSQMessage
                if msg.image == nil {
                    jsqMessage  = JSQMessage.init(senderId: msg.sender.objectId, displayName: msg.sender.username, text:msg.text)
                } else {
            
                    var mediaItem = JSQPhotoMediaItem(image: nil)
                    var isOutgoing = self.senderId == msg.sender.objectId
                    mediaItem.appliesMediaViewMaskAsOutgoing = isOutgoing;
                    
                    jsqMessage = JSQMessage.init(senderId: msg.sender.objectId, displayName: msg.sender.username, media: mediaItem)
                    
                    msg.image?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                        
                        if (error == nil) {
                            mediaItem.image = UIImage(data:data!)
                            self.collectionView?.reloadData()
                            
                        }
                    })
                }
                
                self.messages.append(jsqMessage)
            }
            
            self.collectionView?.reloadData()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let jsqMessage = self.messages[indexPath.item]
        if (jsqMessage.senderId  == self.senderId) {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let jsqMessage = self.messages[indexPath.item]
        if (jsqMessage.senderId  == self.senderId) {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        if indexPath.item < self.messages.count {
            return self.messages[indexPath.item]
        }
        return nil
    }
    
    // called when send button is clicked
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        let user = User.currentUser()!
        let message = Message(sender: user, receiver: receiver!, text: text, image: nil)
        
        message.saveInBackgroundWithBlock { (result, error) -> Void in
            self.messages.append(JSQMessage.init(senderId: message.sender.objectId, displayName: message.sender.username, text:message.text))
            self.collectionView?.reloadData()
            self.finishSendingMessageAnimated(true)
        }
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        presentCamera()
    }
    
    func openSignupView(){
        
        let signUpController = MySignUpViewController()
        signUpController.delegate = self
        signUpController.fields = ([PFSignUpFields.UsernameAndPassword, PFSignUpFields.SignUpButton, PFSignUpFields.Email, PFSignUpFields.DismissButton])
       
        self.navigationController?.presentViewController(signUpController, animated: true, completion: nil)
        
    }
    
    func openLoginView(){
        
        let logInController = MyLogInViewController()
        logInController.delegate = self
        logInController.fields = ([PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton])
        
        self.navigationController?.presentViewController(logInController, animated:true, completion: nil)
        
    }
    
    
    func presentCamera() {
        self.imagePicker = UIImagePickerController()
//        self.imagePicker!.allowsEditing = true
        self.imagePicker!.delegate = self
        self.imagePicker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(self.imagePicker!, animated: true, completion: nil)
    }
    
}

extension ChatViewController : PFSignUpViewControllerDelegate {
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        signUpController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        signUpController.dismissViewControllerAnimated(true, completion: nil)
        print(error?.localizedDescription)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
    }
}

extension ChatViewController : PFLogInViewControllerDelegate  {
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        return true
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        logInController.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print(error?.localizedDescription, terminator: "")
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        // do nothing
    }
}


extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
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

extension ChatViewController : PhotoTweaksViewControllerDelegate {
    func photoTweaksController(controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        
        let message = Message(sender: User.currentUser()!, receiver:receiver!, text:"", image: croppedImage)
        message.saveInBackgroundWithBlock { (result, error) -> Void in
            
            
        let mediaItem = JSQPhotoMediaItem(image: croppedImage)
        mediaItem.appliesMediaViewMaskAsOutgoing = true
        self.messages.append(JSQMessage.init(senderId: User.currentUser()?.objectId, displayName: User.currentUser()?.username, media: mediaItem))
        self.collectionView?.reloadData()
            controller.dismissViewControllerAnimated(true, completion:{
                self.imagePicker!.dismissViewControllerAnimated(false, completion: nil)
            })
        }

        

}

func photoTweaksControllerDidCancel(controller: PhotoTweaksViewController!) {
    controller.dismissViewControllerAnimated(true, completion: {
            self.imagePicker!.dismissViewControllerAnimated(false, completion: nil)
        });
    }
}