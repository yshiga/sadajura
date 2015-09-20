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
    
    var sender:User?
    var receiver:User?
    
    var request:Request? // set by previous viewcontroller
    
    var imagePicker :UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // properties of super class
        self.collectionView!.collectionViewLayout.springinessEnabled = true

        
        // set MessageBubble
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        self.outgoingBubble = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
        
        // set avators
        self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named:"ichiki"), diameter: AVATOR_DIAMETER)
        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named:"yuichi"), diameter: AVATOR_DIAMETER)
        
        // message data
        // self.messages = [NSMutableArray array];
        
        self.sender = User.currentUser()!
        
        if request!.receiver.objectId ==  User.currentUser()!.objectId {
            self.receiver = request!.sender
        } else {
            self.receiver = request!.receiver
        }
        
        self.senderId = User.currentUser()!.objectId
        self.senderDisplayName = User.currentUser()!.username
        
        resetMessages()
        
//        let timer = NSTimer(timeInterval: 5, target:self , selector: "loadMessages:", userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        loadMessages()
    }

    func resetMessages(){
        
        self.messages.removeAll()
        
        
        let requestSenderId = self.request!.sender.objectId
        let requestSenderName = self.request!.sender.username
        
        let requestProduct = self.request!.product
        let requestText = self.request!.desc
        
        if self.request?.sender.objectId == User.currentUser()!.objectId {
        }
        
        let jsqMessage1 = JSQMessage.init(senderId: requestSenderId, displayName: requestSenderName, text:"Can you buy " + requestProduct)
        self.messages.append(jsqMessage1)

        if requestText != "" {
            let jsqMessage2 = JSQMessage.init(senderId: requestSenderId, displayName: requestSenderName, text:requestText)
            self.messages.append(jsqMessage2)
        }
        
        if self.request!.image != nil {
           
            let mediaItem = JSQPhotoMediaItem(image: nil)
            let isOutgoing = self.senderId == requestSenderId
            mediaItem.appliesMediaViewMaskAsOutgoing = isOutgoing;
            
            let jsqMessage3 = JSQMessage.init(senderId: requestSenderId, displayName: requestSenderName, media: mediaItem)
            
            self.request!.image!.getDataInBackgroundWithBlock({ (data, error) -> Void in
                
                if (error == nil) {
                    mediaItem.image = UIImage(data:data!)
                    self.collectionView?.reloadData()
                }
            })
            
            self.messages.append(jsqMessage3)
        }
    }
    
    func loadMessages(){
        
        Message.findByRequest(self.request!, block:{(messages,error)-> Void in
            self.resetMessages()
            
            for msg in messages {
                var jsqMessage :JSQMessage
                if msg.image == nil {
                    jsqMessage  = JSQMessage.init(senderId: msg.sender.objectId, displayName: msg.sender.username, text:msg.text)
                } else {
            
                    let mediaItem = JSQPhotoMediaItem(image: nil)
                    let isOutgoing = self.senderId == msg.sender.objectId
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
        
        let message = Message(request:self.request!, sender: self.sender!, receiver: self.receiver!, text: text, image: nil)
        
        message.saveInBackgroundWithBlock { (result, error) -> Void in
            self.messages.append(JSQMessage.init(senderId: message.sender.objectId, displayName: message.sender.username, text:message.text))
            self.collectionView?.reloadData()
            self.finishSendingMessageAnimated(true)
        }
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
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
        
        let message = Message(request:self.request!, sender: self.sender!, receiver:self.receiver!, text:"", image: croppedImage)
        message.saveInBackgroundWithBlock { (result, error) -> Void in
            
            
        let mediaItem = JSQPhotoMediaItem(image: croppedImage)
        mediaItem.appliesMediaViewMaskAsOutgoing = true
        self.messages.append(JSQMessage.init(senderId: self.sender!.objectId, displayName: self.sender!.username, media: mediaItem))
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