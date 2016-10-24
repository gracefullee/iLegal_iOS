//
//  DonePDFViewController.swift
//  ilegal
//
//  Created by Tae Ha Lee on 10/16/16.
//  Copyright © 2016 Jordan. All rights reserved.
//

import UIKit

class DonePDFViewController: UIViewController {


    @IBOutlet weak var webView: UIWebView!
    var currentForm:Form? = nil
    var fileURL:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fileURL = fileURL?.replacingOccurrences(of: "/var/www/html", with: "http://159.203.67.188")
        webView.loadRequest(URLRequest(url: URL(string: (fileURL!))!))
        // Do any additional setup after loading the view.
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePressed))
        self.navigationItem.rightBarButtonItem = saveButton
    }

    func savePressed(sender: UIBarButtonItem){
        let alert = UIAlertController(title: "Save PDF", message: "Save " + (currentForm?.title)! + "?", preferredStyle: .actionSheet)
        
        let SaveAction = UIAlertAction(title: "Save", style: .default, handler: handleSave)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelSave)
        
        alert.addAction(SaveAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func handleSave(alertAction: UIAlertAction!) -> Void {
        //Save to Database
        
        let alertController = UIAlertController(title: "Saved", message: (currentForm?.title)! + " has been saved!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated:true, completion:nil)
        
    }
    
    func cancelSave(alertAction: UIAlertAction!) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
