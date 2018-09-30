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
import AWSCore
import AWSAPIGateway
import AWSMobileClient


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
    
    func doInvokeAPI() {
        // change the method name, or path or the query string parameters here as desired
        let httpMethodName = "POST"
        // change to any valid path you configured in the API
        let URLString = "/items"
        let queryStringParameters = ["key1":"{value1}"]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let httpBody = "{ \n  " +
            "\"key1\":\"value1\", \n  " +
            "\"key2\":\"value2\", \n  " +
        "\"key3\":\"value3\"\n}"
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: httpBody)
        
        // Create a service configuration
        let serviceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast1,
                                                           credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        // Initialize the API client using the service configuration
        ECHOESRESTAPIEchoesaddcClient.registerClient(withConfiguration: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient = ECHOESRESTAPIEchoesaddcClient.client(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { (task: AWSTask) -> Any? in
            if let error = task.error {
                print("Error occurred: \(error)")
                // Handle error here
                return nil
            }
            
            // Handle successful result here
            let result = task.result!
            let responseString = String(data: result.responseData!, encoding: .utf8)
            
            print(responseString)
            print(result.statusCode)
            
            return nil
        }
    }
    
}

