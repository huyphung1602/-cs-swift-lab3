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
  @IBOutlet weak var submitButton: UIButton!

  var currentUser: PFUser?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    currentUser = PFUser.currentUser()
    if currentUser != nil {
      performSegueWithIdentifier("LoginToChat", sender: nil)
    }
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesBegan(touches, withEvent: event)
    view.endEditing(true)
  }

  @IBAction func onSubmitButtonTapped(sender: UIButton) {
    let username = usernameTextField.text ?? ""
    let password = passwordTextField.text ?? ""

    if username.trim().characters.count == 0 || password.trim().characters.count == 0 {
      return
    }

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
              self.currentUser = user
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
              self.currentUser = user
              self.performSegueWithIdentifier("LoginToChat", sender: self)
            }
          }
        }
      } else {
        self.showAlert(title: "Error", content: error!.localizedDescription)
      }
    })
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let nvc = segue.destinationViewController as? UINavigationController, vc = nvc.topViewController as? ChatViewController {
      if let currentUser = currentUser {
        vc.currentUser = currentUser
      }
    }
  }

}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == usernameTextField {
      passwordTextField?.becomeFirstResponder()
    } else {
      view.endEditing(true)
      onSubmitButtonTapped(submitButton)
    }
    return true
  }
}
