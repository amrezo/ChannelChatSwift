//
//  LoginViewController.swift
//  ChannelChat
//
//  Created by Amr Al-Refae on 3/5/18.
//  Copyright © 2018 Amr Al-Refae. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var nickNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
}

