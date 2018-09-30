//
//  ViewController.swift
//  echoes
//
//  Created by AJ Green on 9/30/18.
//  Copyright © 2018 AJ Green. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        showSignIn()
    }

    func showSignIn() {
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController
                .presentViewController(with: self.navigationController!,
                                       configuration: nil,
                                       completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                                        if error != nil {
                                            print("Error occurred: \(String(describing: error))")
                                        } else {
                                            // Sign in successful.
                                        }
                })
        }
    }
    
    @IBAction func handleSignOutTapped(_ sender: Any) {
        
        // This call should be invoked on a UI activity like a button press triggered by the end user. E.g. `onSignOutButtonClicked` action of sign out button in your app.
        AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
            
            // Note: The showSignIn() method used below was added by us previously while integrating the sign-in UI.
            self.showSignIn()
        })
    }
    
}

