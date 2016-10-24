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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    currentUser = PFUser.current()
    if currentUser != nil {
      performSegue(withIdentifier: "LoginToChat", sender: nil)
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }

  @IBAction func onSubmitButtonTapped(_ sender: UIButton) {
    let username = usernameTextField.text ?? ""
    let password = passwordTextField.text ?? ""

    if username.trim().characters.count == 0 || password.trim().characters.count == 0 {
      return
    }

    let query = PFUser.query()
    query?.whereKey("username", equalTo: username)
    query?.findObjectsInBackground(block: { (results, error) in
      if let results = results {
        if results.count > 0 {
          // Sign in
          PFUser.logInWithUsername(inBackground: username, password: password) {
            (user: PFUser?, error: Error?) -> Void in
            if user != nil {
              print("Login!")
              self.currentUser = user
              self.performSegue(withIdentifier: "LoginToChat", sender: self)
            } else {
              self.showAlert(title: "Error", content: error!.localizedDescription)
            }
          }
        } else {
          // Sign up
          let user = PFUser()
          user.username = username
          user.password = password

          user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
              self.showAlert(title: "Error", content: error.localizedDescription)
            } else {
              print("sign up")
              self.currentUser = user
              self.performSegue(withIdentifier: "LoginToChat", sender: self)
            }
          }
        }
      } else {
        self.showAlert(title: "Error", content: error!.localizedDescription)
      }
    })
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let nvc = segue.destination as? UINavigationController, let vc = nvc.topViewController as? ChatViewController {
      if let currentUser = currentUser {
        vc.currentUser = currentUser
      }
    }
  }

}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == usernameTextField {
      passwordTextField?.becomeFirstResponder()
    } else {
      view.endEditing(true)
      onSubmitButtonTapped(submitButton)
    }
    return true
  }
}
