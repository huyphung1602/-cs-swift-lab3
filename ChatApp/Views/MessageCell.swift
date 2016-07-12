//
//  MessageCell.swift
//  ChatApp
//
//  Created by Chau Vo on 7/12/16.
//  Copyright © 2016 Chau Vo. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!

  var message: Message! {
    didSet {
      if let user = message.user {
        usernameLabel.text = user.username
      } else {
        usernameLabel.text = "<anonymous>"
      }
      timestampLabel.text = message.timestamp
      messageLabel.text = message.text
    }
  }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
