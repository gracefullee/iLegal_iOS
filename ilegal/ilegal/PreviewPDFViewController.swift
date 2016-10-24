//
//  PreviewPDFViewController.swift
//  ilegal
//
//  Created by ITP on 9/15/16.
//  Copyright © 2016 Jordan. All rights reserved.
//

import UIKit

class PreviewPDFViewController: UIViewController {

    @IBOutlet weak var pdfWebView: UIWebView!
    @IBOutlet weak var fillOutButton: UIButton!
    var destination:EditPDFViewController! = nil
    var currentForm:Form? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        //let path = Bundle.main.path(forResource: "SmallClaims", ofType: "pdf")
        // Do any additional setup after loading the view.
        print(currentForm?.location)
        pdfWebView.loadRequest(URLRequest(url: URL(string: (currentForm?.location)!)!))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fillOutButtonPressed(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        destination = storyboard.instantiateViewController(withIdentifier: "EditPDFViewController") as! EditPDFViewController
        destination.title = self.title
        let backItem = UIBarButtonItem()
        backItem.title = ""
        destination.currentForm = self.currentForm
        destination.navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(destination, animated: true)
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
