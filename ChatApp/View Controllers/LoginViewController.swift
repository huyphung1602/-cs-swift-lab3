//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Chau Vo on 7/11/16.
//  Copyright © 2016 Chau Vo. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  @IBAction func onSubmitButtonTapped(sender: UIButton) {
    let username = usernameTextField.text ?? ""
    let password = passwordTextField.text ?? ""

    let query = PFUser.query()
    query?.whereKey("username", equalTo: username)
    query?.findObjectsInBackgroundWithBlock({ (results, error) in
      if let results = results {
        if results.count > 0 {
          // Sign in
          PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
              print("Login!")
              self.performSegueWithIdentifier("LoginToChat", sender: self)
            } else {
              self.showAlert(title: "Error", content: error!.localizedDescription)
            }
          }
        } else {
          // Sign up
          let user = PFUser()
          user.username = username
          user.password = password

          user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
              self.showAlert(title: "Error", content: error.localizedDescription)
            } else {
              print("sign up")
              self.performSegueWithIdentifier("LoginToChat", sender: self)
            }
          }
        }
      } else {
        self.showAlert(title: "Error", content: error!.localizedDescription)
      }
    })
  }

}
