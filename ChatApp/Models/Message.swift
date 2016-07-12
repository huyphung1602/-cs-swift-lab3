//
//  Message.swift
//  ChatApp
//
//  Created by Chau Vo on 7/12/16.
//  Copyright © 2016 Chau Vo. All rights reserved.
//

import Foundation
import Parse
import NSDate_TimeAgo

class Message {
  var text = ""
  var createdAt: NSDate?
  var user: PFUser?

  init(object: PFObject) {
    text = object["text"] as? String ?? ""
    createdAt = object.createdAt
    user = object["user"] as? PFUser
  }

  var timestamp: String {
    return createdAt?.timeAgo() ?? ""
  }

  static func createPFObject(text: String) -> PFObject {
    let message = PFObject(className: messageClassName)
    message["text"] = text
    message["user"] = PFUser.currentUser()
    return message
  }

  static func messagesFromObjects(objects: [PFObject]) -> [Message] {
    var messages = [Message]()
    objects.forEach { object in
      messages.append(Message(object: object))
    }
    return messages
  }
}
