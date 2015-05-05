//
//  LoginControllerViewController.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/24/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit
import CoreData

let LOGIN_URL: String = BASE_URL + "/account/signin"

class LoginController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    
    let shxKeychainWrapper = KeychainWrapper()
    
    @IBOutlet weak var loginButton: UIButton!
        
    
    @IBAction func emailField(sender: UITextField) {
        // disable login button until this has stuff
    }
    
    
    @IBAction func pwField(sender: UITextField) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // check for stored login
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        // set the username field to what is saved in NSUserDefaults
        let storedEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String
        let storedPW = NSUserDefaults.standardUserDefaults().valueForKey(kSecValueData as String) as? String
        
        if (hasLogin && storedEmail != nil && storedPW != nil) {
            
            // authenticate with stored login
            self.checkLogin(storedEmail!, pw: storedPW!) { (succeeded: Bool, msg: String) -> () in
                if(succeeded) {
                    self.performSegueWithIdentifier("gotoDash", sender: self)
                } else {
                    self.emailField.text = storedEmail
                }
            }
        }
        
    }
    
    
    func checkLogin(email: String, pw: String, postCompleted : (succeeded: Bool, msg: String) -> () ) {
        
        var err: NSError?
        var params = ["email":email, "password":pw] as Dictionary<String, String>
        
        
        var url = NSURL(string: LOGIN_URL)
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request) {
            data, response, error in
            var ok = false
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    var status = parseJSON["status"] as? String
                    if (status=="ok") {
                        // save password
                        let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
                        if hasLoginKey == false {
                            NSUserDefaults.standardUserDefaults().setValue(email, forKey: "email")
                        }
                        
                        // save password
                        self.shxKeychainWrapper.mySetObject(pw, forKey:kSecValueData)
                        self.shxKeychainWrapper.writeToKeychain()
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        postCompleted(succeeded: true, msg: "ok")
                    }
                }
                else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
            postCompleted(succeeded: false, msg: "Error")
        }
        
        task.resume()
        
    }

    
    
    // MARK: - Action for checking username/password
    @IBAction func loginBtn(sender: AnyObject) {
        
        // 1.
        if (emailField.text == "" || pwField.text == "") {
            var alert = UIAlertView()
            alert.title = "You must enter both a username and password!"
            alert.addButtonWithTitle("Oops!")
            alert.show()
            return;
        }
        
        // dismiss keyboard
        emailField.resignFirstResponder()
        pwField.resignFirstResponder()
        
        self.checkLogin(emailField.text, pw: pwField.text) { (succeeded: Bool, msg: String) -> () in
            println(succeeded)
            println(msg)
            if(succeeded) {
                self.performSegueWithIdentifier("gotoDash", sender: self)
            } else {
                var alert = UIAlertView()
                alert.title = "Login Problem"
                alert.message = "Wrong username or password."
                alert.addButtonWithTitle("Sucks")
                alert.show()
                self.pwField.text = ""
            }
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
