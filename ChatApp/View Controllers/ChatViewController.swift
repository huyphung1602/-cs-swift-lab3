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

  var currentUser: PFUser?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  @IBAction func onSignOutButtonTapped(sender: UIBarButtonItem) {
    PFUser.logOutInBackground()
    dismissViewControllerAnimated(true, completion: nil)
  }
}
