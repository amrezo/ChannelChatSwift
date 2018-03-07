//
//  LoginViewController.swift
//  ChannelChat
//
//  Created by Amr Al-Refae on 3/5/18.
//  Copyright © 2018 Amr Al-Refae. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nickNameField.delegate = self
        loginButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginToChat(_ sender: UIButton) {
        
        if nickNameField.text != "" {
            Auth.auth().signInAnonymously(completion: { (user, error) in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                self.performSegue(withIdentifier: "LoginToChat", sender: nil)
            })
        }
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        let navVC = segue.destination as! UINavigationController
        let channelsTVC = navVC.viewControllers.first as! ChannelsTableViewController
        
        channelsTVC.senderDisplayName = nickNameField?.text!
    }
    
    // Hide keyboard when user taps outsides keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide keyboard when user presses on return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nickNameField.resignFirstResponder()
        return true
    }
    
    func checkField(sender: AnyObject) {
        if (nickNameField.text?.isEmpty)! {
            loginButton.isEnabled = false
            
        } else {
            loginButton.isEnabled = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkField(sender: nickNameField)
    }
}

