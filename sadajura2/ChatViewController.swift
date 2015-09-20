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

class ChatViewController: JSQMessagesViewController{
    
    var messages = [JSQMessage]()
    var incomingBubble :JSQMessagesBubbleImage?
    var outgoingBubble :JSQMessagesBubbleImage?
    var incomingAvatar :JSQMessagesAvatarImage?
    var outgoingAvatar :JSQMessagesAvatarImage?
    
    let AVATOR_DIAMETER:UInt = 64
    
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
        setDummyData()
    }
    
    private func setDummyData(){
        
        let msg1 = JSQMessage.init(senderId: "1", displayName: "Yuichi", text: "text text text1")
        messages.append(msg1)
        
        let msg2 = JSQMessage.init(senderId: "2", displayName: "Ichiki", text: "text text text2")
        messages.append(msg2)
        
        let msg3 = JSQMessage.init(senderId: "2", displayName: "Ichiki", text: "text text text3")
        messages.append(msg3)
        
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = self.messages[indexPath.item]
        if (message.senderId  == self.senderId) {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = self.messages[indexPath.item]
        if (message.senderId  == self.senderId) {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        return self.messages[indexPath.item]
        
    }
    
    // called when send button is clicked
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    }
    
}
