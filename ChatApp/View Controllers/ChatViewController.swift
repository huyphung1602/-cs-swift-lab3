//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Chau Vo on 7/11/16.
//  Copyright © 2016 Chau Vo. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {

  @IBOutlet weak var chatTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!

  var currentUser: PFUser?
  var messages = [Message]()

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.estimatedRowHeight = 80
    tableView.rowHeight = UITableViewAutomaticDimension

    NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
  }

  @IBAction func onSignOutButtonTapped(sender: UIBarButtonItem) {
    PFUser.logOutInBackground()
    dismissViewControllerAnimated(true, completion: nil)
  }

  func onTimer() {
    queryMessages()
  }

  func queryMessages() {
    let query = PFQuery(className: "Message_Swift_032016")
    query.orderByDescending("createdAt")
    query.whereKey("text", notEqualTo: "")
    query.includeKey("user")

    query.findObjectsInBackgroundWithBlock { (objects, error) in
      if let objects = objects {
        self.messages = Message.messagesFromObjects(objects)
        self.tableView.reloadData()
      } else {
        self.showAlert(title: "Error", content: error!.localizedDescription)
      }
    }
  }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessageCell
    cell.message = messages[indexPath.row]
    return cell
  }

}
