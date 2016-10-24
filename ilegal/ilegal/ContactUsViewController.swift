//
//  ContactUsViewController.swift
//  ilegal
//
//  Created by Yoo Jin Lee on 9/12/16.
//  Copyright © 2016 Yoo Jin. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var subjectTF: UITextField!
    @IBOutlet weak var messageBodyTF: UITextView!
    var fileData:Data!
    var fileTitle:NSString!
    var fileAttached:Bool!
    
    var contactEmail = "yoojin.lee1220@gmail.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Open up mail compose View Controller
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else
        {
            self.showSendMailErrorAlert()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        /*
        if(subjectTF.text!.isEmpty || messageBodyTF.text!.isEmpty)
        {
            //If first name/last name/email is empty, display alert
            let alertController = UIAlertController(title: "Sorry", message: "Please enter the First Name, Last Name and/or Email Address associated with your account. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated:true, completion:nil)
        } else{
            
          

            
        }
        */
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([contactEmail])
        //mailComposerVC.setSubject(subjectTF.text!)
        //mailComposerVC.setMessageBody(messageBodyTF.text!, isHTML: false)
        if (fileAttached != nil)
        {
            mailComposerVC.addAttachmentData(fileData, mimeType: "application/pdf", fileName: fileTitle as String)
        }
        
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
