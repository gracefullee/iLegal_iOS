//
//  ForgotPasswordViewController.swift
//  ilegal
//
//  Created by Yoo Jin Lee on 9/12/16.
//  Copyright © 2016 Yoo Jin. All rights reserved.
//

import UIKit
import MessageUI

class ForgotPasswordViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var recoverPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recoverPasswordButtonClicked(_ sender: UIButton) {
        if(firstNameTF.text!.isEmpty || lastNameTF.text!.isEmpty || emailTF.text!.isEmpty)
        {
            //If first name/last name/email is empty, display alert
            let alertController = UIAlertController(title: "Sorry", message: "Please enter the First Name, Last Name and/or Email Address associated with your account. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated:true, completion:nil)
        } else{
            
            
            let userFound = false
            
            //CHECK IF USER INFORMATION ARE CORRECT AND EXISTS IN DATABASE (ELSE-IF)
            //Assign result to userFound
            
            if !userFound
            {
                //If inputted user information is incorrect, display alert
                let alertController = UIAlertController(title: "Sorry", message: "The First Name, Last Name and/or Email Address does not match our records, or you are not registered. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated:true, completion:nil)
            }
            else {
                //Send user the password to their email
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail()
                {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else
                {
                    self.showSendMailErrorAlert()
                }
            }

            
        }
        

    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([emailTF.text!])
        mailComposerVC.setSubject("Forgot Your Password?")
        //DRAFT FORGOT PASSWORD MESSAGE IN HTML
        mailComposerVC.setMessageBody("", isHTML: true)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert(){
        let sendMailErrorAlert = UIAlertController(title: "Email Could Not Be Sent", message: "Your device could not send email. Please check email and/or network configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        sendMailErrorAlert.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(sendMailErrorAlert, animated:true, completion:nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
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
