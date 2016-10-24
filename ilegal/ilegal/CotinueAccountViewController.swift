//
//  CotinueAccountViewController.swift
//  ilegal
//
//  Created by ITP on 9/12/16.
//  Copyright © 2016 Jordan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
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


class CotinueAccountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var addressOneTF: UITextField!
    @IBOutlet weak var addressTwoTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var zipcodeTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var licenseTF: UITextField!
    @IBOutlet weak var birthdayMTF: UITextField!
    @IBOutlet weak var birthdayDTF: UITextField!
    @IBOutlet weak var birthdayYTF: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    var stateData = ["Alabama - AL","Alaska - AK","Arizona - AZ","Arkansas - AR","California - CA","Colorado - CO","Connecticut - CT","Delaware - DE","Florida - FL","Georgia - GA","Hawaii - HI","Idaho - ID","Illinois - IL","Indiana - IN","Iowa - IA","Kansas - KS","Kentucky - KY","Louisiana - LA","Maine - ME","Maryland - MD","Massachusetts - MA","Michigan - MI","Minnesota - MN","Mississippi - MS","Missouri - MO","Montana - MT","Nebraska - NE","Nevada - NV","New Hampshire - NH", "New Jersey - NJ", "New Mexico - NM", "New York - NY", "North Carolina - NC", "North Dakota - ND", "Ohio - OH", "Oklahoma - OK", "Oregon - OR", "Pennsylvania - PA", "Rhode Island - RI", "South Carolina - SC", "South Dakota - SD", "Tennessee - TN", "Texas - TX", "Utah - UT", "Vermont - VT", "Virginia - VA", "Washington - WA", "West Virginia - WV", "Wisconsin - WI", "Wyoming - WY"]
    var monthData = [String]()
    var dayData = [String]()
    var yearData = [Int]()
    
    var statePicker = UIPickerView()
    var monthPicker = UIPickerView()
    var dayPicker = UIPickerView()
    var yearPicker = UIPickerView()
    
    
    func donePicker(){
        stateTF.resignFirstResponder()
        birthdayMTF.resignFirstResponder()
        birthdayDTF.resignFirstResponder()
        birthdayYTF.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statePicker.delegate = self
        statePicker.dataSource = self
        statePicker.tag = 1
        stateTF.inputView = statePicker
        
        monthPicker.delegate = self
        monthPicker.dataSource = self
        monthPicker.tag = 2
        birthdayMTF.inputView = monthPicker
        for i in 1...12{
            if(i < 10){
                let temp = "0" + String(i)
                monthData.append(temp)
            } else {
                monthData.append(String(i))
            }
        }
        
        dayPicker.delegate = self
        dayPicker.dataSource = self
        dayPicker.tag = 3
        birthdayDTF.inputView = dayPicker
        for i in 1...31{
            if(i < 10){
                let temp = "0" + String(i)
                dayData.append(temp)
            } else {
                dayData.append(String(i))
            }
        }
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.tag = 4
        birthdayYTF.inputView = yearPicker
        
        //get current year
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day, .month,.year], from:date)
        let year:Int = components.year!
        for i in 1900 ... year{
                yearData.append(i)
        }
        
        //Add Done Button to UIPickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red :76/255, green: 17/225, blue: 100/225, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title:"Done", style:UIBarButtonItemStyle.plain, target:self, action:#selector(CotinueAccountViewController.donePicker))
        let flexibleSpaceLeft = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexibleSpaceLeft, doneButton],animated:false)
        toolBar.isUserInteractionEnabled = true
        stateTF.inputAccessoryView = toolBar
        birthdayYTF.inputAccessoryView = toolBar
        birthdayMTF.inputAccessoryView = toolBar
        birthdayDTF.inputAccessoryView = toolBar
        
        // Do any additional setup after loading the view.
        if((User.currentUser.active) != nil){
            addressOneTF.text = User.currentUser.addressOne
            if(User.currentUser.addressTwo?.characters.count > 0){
                addressTwoTF.text = User.currentUser.addressTwo
            }
            cityTF.text = User.currentUser.city
            stateTF.text = User.currentUser.state
            zipcodeTF.text = User.currentUser.zipcode
            phoneTF.text = User.currentUser.phone
            licenseTF.text = User.currentUser.license
            
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView.tag == 1){
            return stateData.count
        }
        else if(pickerView.tag == 2){
            return monthData.count
        }
        else if(pickerView.tag == 3){
            return dayData.count
        }
        else {
            return yearData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView.tag == 1){
            var stateString = stateData[row]
            stateString = String(stateString.characters.suffix(2))
            stateTF.text = stateString
        } else if(pickerView.tag == 2){
            birthdayMTF.text = monthData[row]
        } else if(pickerView.tag == 3){
            birthdayDTF.text = dayData[row]
        } else{
            birthdayYTF.text = String(yearData[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(pickerView.tag == 1){
            return stateData[row]
        } else if(pickerView.tag == 2){
            return monthData[row]
        } else if(pickerView.tag == 3){
            return dayData[row]
        } else{
            return String(yearData[row])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateLabel(_ sender: AnyObject) {
        if(sender as! NSObject==addressOneTF){
            addressLabel.isHidden = true
        }
        else if(sender as! NSObject == cityTF){
            cityLabel.isHidden = true;
        }
        else if(sender as! NSObject == stateTF){
            stateLabel.isHidden = true
        }
        else if(sender as! NSObject == zipcodeTF){
            zipcodeLabel.isHidden = true
        }
        else if(sender as! NSObject == birthdayDTF || sender as! NSObject == birthdayMTF || sender as! NSObject == birthdayYTF){
            birthdayLabel.isHidden = true
        }
        else if(sender as! NSObject == phoneTF){
            phoneLabel.isHidden = true
        }
        else if(sender as! NSObject == licenseTF){
            licenseTF.isHidden = true
        }
    }
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
        createAccount()
    }
    
    @IBAction func createButtonClicked(_ sender: UIButton) {
        createAccount()
    }

    func createAccount() {
        if
            addressOneTF.text!.isEmpty || cityTF.text!.isEmpty || stateTF.text!.isEmpty || zipcodeTF.text!.isEmpty || phoneTF.text!.isEmpty || licenseTF.text!.isEmpty
        {
            if addressOneTF.text!.isEmpty
            {
                addressLabel.isHidden = false;
            }
            if cityTF.text!.isEmpty
            {
                cityLabel.isHidden = false;
            }
            if stateTF.text!.isEmpty
            {
                stateLabel.isHidden = false;
            }
            if zipcodeTF.text!.isEmpty
            {
                zipcodeLabel.isHidden = false;
            }
            if phoneTF.text!.isEmpty
            {
                phoneLabel.isHidden = false;
            }
            if licenseTF.text!.isEmpty
            {
                licenseLabel.isHidden = false;
            }
            if birthdayDTF.text!.isEmpty && birthdayMTF.text!.isEmpty && birthdayYTF.text!.isEmpty {
                birthdayLabel.isHidden = false;
            }
        }
        else
        {
            User.currentUser.addressOne = String(describing: addressOneTF.text?.utf8)
            if(addressTwoTF.text!.characters.count > 0){
                User.currentUser.addressTwo = String(describing: addressTwoTF.text?.utf8)
            }
            
            
            User.currentUser.city =  cityTF.text?.utf8.description
            User.currentUser.state = stateTF.text?.utf8.description
            User.currentUser.zipcode = zipcodeTF.text?.utf8.description
            User.currentUser.phone = phoneTF.text?.utf8.description
            User.currentUser.license = licenseTF.text?.utf8.description
            User.currentUser.setBirthday(birthdayMTF.text!, day: birthdayDTF.text!, year: birthdayYTF.text!)
            User.currentUser.DOB = User.currentUser.DOB?.utf8.description
            
            
            var parameters: Parameters = [
                "FirstName":User.currentUser.firstName,
                "LastName":User.currentUser.lastName,
                "DOB":User.currentUser.DOB,
                "Address1":User.currentUser.addressOne,
                "City":User.currentUser.city,
                "State":User.currentUser.state,
                "PostalCode":User.currentUser.zipcode,
                "PhoneNumber":User.currentUser.phone,
                "LicenseNumber":User.currentUser.license,
                "EmailAddress":User.currentUser.email,
                "Password":User.currentUser.password
            ]
            
            if(!addressTwoTF.text!.isEmpty){
                parameters["Address2"] = User.currentUser.addressTwo?.utf8.description
            }
            
            if(User.currentUser.middleInitial!.characters.count > 0){
                parameters["MiddleName"] = User.currentUser.middleInitial?.utf8.description
            }
            
            Alamofire.request("http://159.203.67.188:8080/Dev/SignUp?", method: .post, parameters: parameters).responseJSON { response in
                switch response.result{
                case .success(let value):
                    let outcome = JSON(value)
                    if(outcome["Success"].intValue == 1){
                        let alertController = UIAlertController(title: "Success", message: "Account has been successfully created. Please log in.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: {
                            [unowned self] (action) -> Void in
                            self.performSegue(withIdentifier: "createSegue", sender: self)
                            }))
                        self.present(alertController, animated:true, completion:nil)
                    } else{
                        let alertController = UIAlertController(title: "Error", message: "Account could not be created. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alertController, animated:true, completion:nil)
                    }
                case .failure:
                    let alertController = UIAlertController(title: "Error", message: "Account could not be created. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated:true, completion:nil)
                }
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
