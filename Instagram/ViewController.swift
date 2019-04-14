//
//  ViewController.swift
//  Instagram
//
//  Created by 加加林 on 2019/4/8.
//  Copyright © 2019 mumu2plus. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
     var signupModeActive = true

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupOrLoginButton: UIButton!
    @IBOutlet weak var switchLoginModelButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "showUserTable", sender: self)
        }
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func signupOrLogin(_ sender: UIButton) {
        
        if email.text == "" || password.text == "" {
            displayAlert(title: "Error in form", message: "Please enter an email and password")
        } else {
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = .gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            
            if signupModeActive {
                print("Signing up...")
                
                let user = PFUser()
                user.username = email.text
                user.password = password.text
                user.email = email.text
                
                user.signUpInBackground { (success: Bool, error: Error?) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if let error = error {
                        self.displayAlert(title: "Could not sign you up", message: error.localizedDescription)
                        //let errorString = error.userInfo["error"] as? NSString
                        // Show the errorString somewhere and let the user try again.
                        print(error)
                    } else {
                        // Hooray! Let them use the app now.
                        print("signed up!")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                }
            } else {
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!) { (user, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if user != nil {
                        print("Login successful")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    } else {
                        var errorText = "Unknown error: please try again"
                        if let myerror = error {
                            errorText = myerror.localizedDescription
                        }
                        self.displayAlert(title: "Could not sign you up", message: errorText)
                    }
                }
            }
            
        }
        
    }
    
    @IBAction func switchLoginMode(_ sender: UIButton) {
        
        if signupModeActive {
            signupModeActive = false
            signupOrLoginButton.setTitle("Log In", for: [])
            switchLoginModelButton.setTitle("Sign Up", for: [])
        } else {
            signupModeActive = true
            signupOrLoginButton.setTitle("Sign Up", for: [])
            switchLoginModelButton.setTitle("Log In", for: [])
        }
        
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

