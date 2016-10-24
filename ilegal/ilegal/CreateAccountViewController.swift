//
//  CreateAccountViewController.swift
//  ilegal
//
//  Created by ITP on 9/12/16.
//  Copyright © 2016 Jordan. All rights reserved.
//

import UIKit
import CryptoSwift


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}




class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var middleInitialTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var pwReqLabel: UILabel!
    @IBOutlet weak var pwMatchLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    //Only allow maximum of one character in Middle Initial
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    //Perform information check when next button is clicked
    @IBAction func nextButtonClicked(_ sender: UIBarButtonItem) {
        continueAccount()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        middleInitialTF.delegate = self
        
        if((User.currentUser.active) != nil){
            firstNameTF.text = User.currentUser.firstName
            if(User.currentUser.middleInitial?.characters.count > 0){
                middleInitialTF.text = User.currentUser.middleInitial
            }
            lastNameTF.text = User.currentUser.lastName
            emailTF.text = User.currentUser.email
        }
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueButtonClicked(_ sender: UIButton) {
            continueAccount()
    }
    
    @IBAction func updateLabel(_ sender: AnyObject) {
        if(sender as! NSObject==firstNameTF){
            firstNameLabel.isHidden = true;
        }
        else if(sender as! NSObject == lastNameTF){
            lastNameLabel.isHidden = true;
        }
        else if(sender as! NSObject == emailTF){
            emailLabel.isHidden = true;
        }
        else if(sender as! NSObject == passwordTF){
            pwReqLabel.isHidden = true;
        }
        else if(sender as! NSObject == confirmPasswordTF){
            pwMatchLabel.isHidden = true;
        }
    }

    func validEmail(str: String) -> Bool
    {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        return test.evaluate(with: str)
    }
    
    func continueAccount()
    {
        var emailValid = true
        if(emailTF.text!.isEmpty == false){
            emailValid = validEmail(str: emailTF.text!)
        }
        
        if
            firstNameTF.text!.characters.count < 2 || lastNameTF.text!.characters.count < 2 || emailTF.text!.isEmpty || passwordTF.text!.isEmpty || confirmPasswordTF.text!.isEmpty || (passwordTF.text!.characters.count != 0 && passwordTF.text != confirmPasswordTF.text && confirmPasswordTF.text!.characters.count != 0) || passwordTF.text!.characters.count < 6 || emailValid == false
        {
            if firstNameTF.text!.characters.count < 2
            {
                if firstNameTF.text!.characters.count == 0 {
                    firstNameLabel.text = "Please enter your first name"
                } else {
                    firstNameLabel.text = "First name must be at least 2 characters"
                }
                firstNameLabel.isHidden = false;
            }
            if lastNameTF.text!.characters.count < 2
            {
                if lastNameTF.text!.characters.count == 0 {
                    lastNameLabel.text = "Please enter your last name"
                } else {
                    lastNameLabel.text = "Last name must be at least 2 characters"
                }
                lastNameLabel.isHidden = false;
            }
            if emailTF.text!.isEmpty
            {
                emailLabel.isHidden = false
            } else if emailValid == false {
                emailLabel.isHidden = false
            }
            if passwordTF.text!.isEmpty
            {
                pwReqLabel.text = "Please enter your password";
                pwReqLabel.isHidden = false;
            }
            if confirmPasswordTF.text!.isEmpty
            {
                pwMatchLabel.text = "Please confirm your password";
                pwMatchLabel.isHidden = false;
            }
            if(passwordTF.text!.characters.count < 6)
            {
                pwReqLabel.text = "Password length must be 6 charaters";
                pwReqLabel.isHidden = false;
            }
            if(passwordTF.text!.characters.count > 0 && passwordTF.text != confirmPasswordTF.text && confirmPasswordTF.text!.characters.count > 0)
            {
                pwMatchLabel.text = "Password does not match";
                pwMatchLabel.isHidden = false;
            }
            
        }
        else
        {
            User.currentUser.active = true
            User.currentUser.firstName = firstNameTF.text?.utf8.description
            if(middleInitialTF.text!.characters.count > 0){
                User.currentUser.middleInitial = middleInitialTF.text?.utf8.description
            }
            User.currentUser.lastName = lastNameTF.text?.utf8.description
            User.currentUser.email = emailTF.text?.utf8.description
            User.currentUser.password = passwordTF.text?.sha1().utf8.description
            
            performSegue(withIdentifier: "continueSegue", sender: self)
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
