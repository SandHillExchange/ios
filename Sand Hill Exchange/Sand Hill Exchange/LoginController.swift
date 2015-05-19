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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    @IBAction func emailField(sender: UITextField) {
        // disable login button until this has stuff
    }
    
    
    @IBAction func pwField(sender: UITextField) {
    }
    
    var storedKey : String = ""
    var hasLogin : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.attributedPlaceholder = NSAttributedString(string:"email",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        pwField.attributedPlaceholder = NSAttributedString(string:"password",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        loginButton.layer.cornerRadius = 3.0;
        self.navigationController!.navigationBar.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object: nil);
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

        
        // check for stored login
        hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        // set the username field to what is saved in NSUserDefaults
        let storedEmail: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("email")
        let storedPW = shxKeychainWrapper.myObjectForKey(kSecValueData) as? String
        var tempKey: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("userkey")
        if (tempKey != nil) { storedKey = tempKey as! String}
        
        if (hasLogin && storedEmail != nil && storedPW != nil) {
            
            // authenticate with stored login
            self.checkLogin(storedEmail! as! String, pw: storedPW!) { (succeeded: Bool, msg: String) -> () in
                if(succeeded) {
                    println("logging in...")
                    dispatch_async(dispatch_get_main_queue(),{
                        self.performSegueWithIdentifier("gotoDash", sender: self)
                    })

                } else {
                    self.emailField.text = storedEmail as! String
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasLoginKey")
                }
            }
        } else {
            //wait
        }
        
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: { () -> Void in
            if let temp = self.bottomConstraint {
                temp.constant = keyboardFrame.size.height + 20
            }
        }, completion: nil)
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
                        
                        var userkey = parseJSON["userkey"] as? String
                        
                        if !self.hasLogin {
                            println("saving pw for first time")
                            // save password if not done before
                            self.shxKeychainWrapper.mySetObject(pw, forKey:kSecValueData)
                            self.shxKeychainWrapper.writeToKeychain()
                            NSUserDefaults.standardUserDefaults().setValue(email, forKey: "email")
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                            NSUserDefaults.standardUserDefaults().setValue(userkey, forKey: "userkey")
                            NSUserDefaults.standardUserDefaults().synchronize()
                        }
                        postCompleted(succeeded: true, msg: "ok")
                        return
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
