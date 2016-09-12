//
//  ViewController.swift
//  TouchID Example
//
//  Created by Scotty on 12/09/2016.
//  Copyright © 2016 Streambyte Limited. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var touchIDButton: UIButton!
    @IBOutlet weak var touchLabel: UILabel!
    
    var context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfTouchIDIsAvailable()
    }
    
    
    /// Check if Touch ID Is supported by this device
    /// Note: The simulator will always return false
    fileprivate func checkIfTouchIDIsAvailable() {
        let isAvailable = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
        touchIDButton.isHidden = !isAvailable
        touchLabel.isHidden = isAvailable
    }
    
    @IBAction func touchIDButtonPressed(_ sender: AnyObject) {
        
        // Ask Touch ID to authenticate
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Touch the home button to authenticate with Touch ID", reply: { (success: Bool, error: Error? ) -> Void in
            DispatchQueue.main.async(execute: {
                                    
                var message = "Touch ID Sucessfully Authenticated"
                var buttonText = "Cool"
                var title = "Success"
                
                if let error = error {
                    title = "Error"
                    buttonText = "Oh Dear!"
                    
                    switch(error) {
                        case LAError.authenticationFailed:
                            message = "Failed to verify your identity."
                        case LAError.userCancel:
                            message = "Cancel was pressed."
                        case LAError.userFallback:
                            message = "Password was pressed."
                        default:
                            message = "Looks like Touch ID may not be configured"
                    }
                }
                                    
                let alertView = UIAlertController(title: title, message: message, preferredStyle:.alert)
                let okAction = UIAlertAction(title: buttonText, style: .default, handler: nil)
                alertView.addAction(okAction)
                self.present(alertView, animated: true, completion: nil)
            })
        })
    }
    
}

