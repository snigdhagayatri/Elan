//
//  LoginViewController.swift
//  Elan
//
//  Created by Snigdha Gayatri on 25/04/15.
//  Copyright (c) 2015 Snigdha Gayatri. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var squareFeet: Int = Int()
    var price: Int = Int()
    var sellerVerified: String = String()
    var startRating: Float?
    var soil: String?
    var proneToCalamity: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        if userNameTextField.text == "abc" && passwordTextField.text == "abc"
        {
            var detailViewController:DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detail") as DetailViewController
            detailViewController.isSignedIn = true
            detailViewController.squareFeet = squareFeet
            detailViewController.price = price
            detailViewController.sellerVerified = sellerVerified
            detailViewController.startRating = startRating
            detailViewController.soil = soil
            detailViewController.proneToCalamity = proneToCalamity
            self.presentViewController(detailViewController, animated: true, completion: nil)
        }
        else
        {
            let alert: UIAlertView = UIAlertView(title: "Warning", message: "Invalid id or password", delegate: self, cancelButtonTitle: "OK")
            alert.show()

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
