//
//  ViewController.swift
//  ilegal
//
//  Created by Yoo Jin Lee on 9/12/16.
//  Copyright © 2016 Yoo Jin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {

        if(usernameTF.text!.isEmpty || passwordTF.text!.isEmpty)
        {
            //If Password/Username is empty, display alert
            let alertController = UIAlertController(title: "Sorry", message: "Please enter the Username and/or Password. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated:true, completion:nil)
        } else{
            //CHECK IF USER CREDENTIALS ARE CORRECT AND EXISTS IN DATABASE (ELSE-IF)
            
            Alamofire.request("http://159.203.67.188:8080/Dev/SignIn?Username=" + usernameTF.text! + "&Password=" + passwordTF.text!).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let outcome = JSON(value)
                    if(outcome["Success"].intValue == 1){
                        //Log-In and go to CategoriesViewController
                        User.currentUser.firstName = outcome["FirstName"].stringValue
                        if(!outcome["MiddleInitial"].stringValue.isEmpty){
                            User.currentUser.middleInitial = outcome["MiddleInitial"].stringValue
                        } else{
                            User.currentUser.middleInitial = ""
                        }
                        User.currentUser.lastName = outcome["LastName"].stringValue
                        User.currentUser.email = outcome["EmailAddress"].stringValue
                        User.currentUser.password = outcome["Password"].stringValue
                        User.currentUser.addressOne = outcome["Address1"].stringValue
                        if(!outcome["Address2"].stringValue.isEmpty){
                            User.currentUser.addressTwo = outcome["Address2"].stringValue
                        } else {
                            User.currentUser.addressTwo = ""
                        }
                        User.currentUser.city = outcome["City"].stringValue
                        User.currentUser.state = outcome["State"].stringValue
                        User.currentUser.zipcode = outcome["PostalCode"].stringValue
                        User.currentUser.phone = outcome["PhoneNumber"].stringValue
                        User.currentUser.license = outcome["LicenseNumber"].stringValue
                        User.currentUser.DOB = outcome["DOB"].stringValue
                        
                        //pull User's Saved Files
                        Alamofire.request("http://159.203.67.188:8080/Dev/ListPDF?Type=4&UserUniqueID=" + User.currentUser.id).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                let outcome = JSON(value)
                                let temp = outcome["UserDocs"].count
                                for i in 0...temp-1 {
                                    let tempForm:Form = Form()
                                    tempForm.id = outcome["UserDocs"][i][0].string
                                    tempForm.location = outcome["UserDocs"][i][1].string
                                    tempForm.title = outcome["UserDocs"][i][2].string
                                    User.currentUser.myFiles.append(tempForm)
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                        
                        self.performSegue(withIdentifier: "mainSegue", sender: self)
                    } else{
                        //If Password/Username is incorrect, display alert
                        self.passwordTF.text = ""
                        let alertController = UIAlertController(title: "Sorry", message: "The Username and/or Password does not match our records, or you are not registered. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alertController, animated:true, completion:nil)
                    }
                case .failure:
                    //If Password/Username is incorrect, display alert
                    self.passwordTF.text = ""
                    let alertController = UIAlertController(title: "Sorry", message: "The Username and/or Password does not match our records, or you are not registered. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated:true, completion:nil)
                }

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

