//
//  FriendTripTableViewCell.swift
//  sadajura
//
//  Created by 佐藤一輝 on 2015/09/19.
//  Copyright © 2015年 whomentors. All rights reserved.
//

import UIKit

class ChatListViewCell: UITableViewCell {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var travelRegion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
