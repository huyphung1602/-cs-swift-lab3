//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Chau Vo on 7/11/16.
//  Copyright © 2016 Chau Vo. All rights reserved.
//

import UIKit
import Parse

let messageClassName = "Message_Swift_102016"

class ChatViewController: UIViewController {

  @IBOutlet weak var chatTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!

  var currentUser: PFUser?
  var messages = [Message]()

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.estimatedRowHeight = 80
    tableView.rowHeight = UITableViewAutomaticDimension

    chatTextField.layer.borderColor = UIColor.white.cgColor
    chatTextField.layer.borderWidth = 1
    chatTextField.layer.cornerRadius = 5

    Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.endEditting))
    tableView.addGestureRecognizer(tapGesture)
  }

  func endEditting() {
    view.endEditing(true)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }

  @IBAction func onSignOutButtonTapped(_ sender: UIBarButtonItem) {
    PFUser.logOutInBackground()
    dismiss(animated: true, completion: nil)
  }

  func onTimer() {
    queryMessages()
  }

  func queryMessages() {
    let query = PFQuery(className: messageClassName)
    query.order(byDescending: "createdAt")
    query.whereKey("text", notEqualTo: "")
    query.includeKey("user")

    query.findObjectsInBackground { (objects, error) in
      if let objects = objects {
        self.messages = Message.messagesFromObjects(objects)
        self.tableView.reloadData()
      } else {
        self.showAlert(title: "Error", content: error!.localizedDescription)
      }
    }
  }

  @IBAction func onSendButtonTapped(_ sender: UIButton) {
    if let text = chatTextField.text , text.trim().characters.count > 0 {
      let message = Message.createPFObject(text)
      message.saveInBackground(block: { (success, error) in
        if success {
          self.chatTextField.text = ""
          self.queryMessages()
        } else {
          self.showAlert(title: "Error", content: error!.localizedDescription)
        }
      })
    }
  }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
    cell.message = messages[(indexPath as NSIndexPath).row]
    return cell
  }

}

