//
//  EditPDFViewController.swift
//  ilegal
//
//  Created by Yoo Jin Lee on 9/12/16.
//  Copyright © 2016 Yoo Jin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class EditPDFViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var currentForm:Form? = nil
    var json:JSON = []
    
    //Store all fields in its corresponding type array
    var TFArray = [PDFTextField]()
    var YesNoArray = [YesNoButton]()
    var OptionArray = [CheckBoxGroup]()
    var ChArray = [UIPickerView]()
    var ChData = Dictionary<Int,Array<String>>()
    var ChTF = Dictionary<Int,UITextField>()
    var ChTag = Dictionary<Int,String>()
    var PVTAG:Int = 1;

    @IBOutlet weak var scrollView: UIScrollView!
    var textFieldDict:[String:UITextField] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let doneItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem = doneItem
        // Do any additional setup after loading the view.
        
        parseJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePressed(sender: UIBarButtonItem){
        //Send POST Request to server
        //updateJSON()
        //let parameters:Parameters = self.json.dictionaryObject!
        let parameters: Parameters = ["PDFKEY":"test.pdf","PDFID":"1","USERID":"7","Field1":"CSCI 401", "Field2":"iLegal", "Field3":"USC"]
         Alamofire.request("http://159.203.67.188:8080/Dev/FinPDF?", method: .post, parameters: parameters).responseJSON { response in
            switch response.result{
            case .success(let value):
            let outcome = JSON(value)
            print("RESULT: \(outcome)")
            if(outcome["Message"].stringValue == "None"){
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let destination = storyboard.instantiateViewController(withIdentifier: "DonePDFViewController") as! DonePDFViewController
                destination.title = self.title
                destination.currentForm = self.currentForm
                destination.fileURL = outcome["FileURL"].string!
                let backItem = UIBarButtonItem()
                backItem.title = ""
                destination.navigationItem.backBarButtonItem = backItem
                self.navigationController?.pushViewController(destination, animated: true)

            } else{
                let alertController = UIAlertController(title: "Error", message: "Completed form could not be created. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated:true, completion:nil)
            }
            case .failure:
            let alertController = UIAlertController(title: "Error", message: "Completed form could not be created. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated:true, completion:nil)
            }
        }
    }
    
    func parseJSON() {
        //Load json file in path
         

            var yAxis = 0;
            Alamofire.request("http://159.203.67.188:8080/Dev/FillPDF?PdfID=" + (currentForm?.id)!).responseJSON { response in
                switch response.result {
                case .success(let value):
                    self.json = JSON(value)
                    self.json["Field1"] = ["type":"Tx", "value":""]
                    self.json["Field2"] = ["type":"Tx", "value":""]
                    self.json["Field3"] = ["type":"Tx", "value":""]
                    self.json["Language"] = ["type":"Btn", "value":["English","Espanol"]]
                    self.json["Countries"] = ["type":"Ch", "value":["US","FR","UK"]]
                    for (key,subJson):(String, JSON) in self.json {
                        if(subJson["type"].exists()){
                            //Create Label
                            let tempLabel = UILabel(frame: CGRect(x: 20, y: yAxis, width: 350, height: 40))
                            tempLabel.font = UIFont.systemFont(ofSize:15)
                            tempLabel.text = key
                            self.scrollView.addSubview(tempLabel)
                            yAxis += 40
                            if subJson["type"] == "Tx" {
                                //Create TextField
                                let tempTF = PDFTextField(frame: CGRect(x: 40, y: yAxis, width: 300, height: 40))
                                tempTF.font = UIFont.systemFont(ofSize: 14)
                                tempTF.borderStyle = UITextBorderStyle.roundedRect
                                tempTF.text = subJson["value"].string
                                tempTF.title = key
                                self.textFieldDict[key] = tempTF
                                self.scrollView.addSubview(tempTF)
                                self.TFArray.append(tempTF)
                                yAxis += 40
                            } else if subJson["type"] == "Btn" {
                                //Create List of Switch
                                let buttonTitle = subJson["value"].array
                                var buttonGroup = CheckBoxGroup()
                                for option in buttonTitle! {
                                    let checkBox = CheckBox(frame: CGRect(x: 40, y: yAxis, width: 70, height:40))
                                    checkBox.label = option.string!
                                    let checkBoxLabel = UILabel(frame: CGRect(x: 105, y: yAxis-5, width: 150, height: 40))
                                    checkBoxLabel.text = option.string!
                                    buttonGroup.buttons.append(checkBox)
                                    buttonGroup.title = key
                                    self.scrollView.addSubview(checkBox)
                                    self.scrollView.addSubview(checkBoxLabel);
                                    
                                    yAxis += 40
                                }
                                
                                for i in 0...buttonGroup.buttons.count-1{
                                    for j in 0...buttonGroup.buttons.count-1{
                                        if (buttonGroup.buttons[i] != buttonGroup.buttons[j]){
                                            buttonGroup.buttons[i].alternateOptions.append(buttonGroup.buttons[j])
                                        }
                                    }
                                }
                                self.OptionArray.append(buttonGroup)
                                
                            } else if subJson["type"] == "Ch" {
                                let tempPicker = UIPickerView()
                                tempPicker.delegate = self
                                tempPicker.dataSource = self
                                tempPicker.tag = self.PVTAG
                                self.ChTag[tempPicker.tag] = key
                                self.PVTAG += 1
                                let tempTF = UITextField(frame: CGRect(x: 40, y: yAxis, width: 300, height: 40))
                                tempTF.inputView = tempPicker
                                tempTF.font = UIFont.systemFont(ofSize: 14)
                                tempTF.borderStyle = UITextBorderStyle.roundedRect
                                self.ChArray.append(tempPicker)
                                //Parse Values from subJson["value"]
                                let pValues = subJson["value"].array
                                var pickerValues = [String]()
                                for temp in pValues!{
                                    pickerValues.append(temp.string!)
                                }
                                //Add Done Button to UIPickerView
                                let toolBar = UIToolbar()
                                toolBar.barStyle = UIBarStyle.default
                                toolBar.isTranslucent = true
                                toolBar.tintColor = UIColor(red :76/255, green: 17/225, blue: 100/225, alpha: 1)
                                toolBar.sizeToFit()
                                
                                let doneButton = UIBarButtonItem(title:"Done", style:UIBarButtonItemStyle.plain, target:self, action:#selector(self.donePicker))
                                let flexibleSpaceLeft = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
                                toolBar.setItems([flexibleSpaceLeft, doneButton],animated:false)
                                toolBar.isUserInteractionEnabled = true
                                tempTF.inputAccessoryView = toolBar
                                self.ChData[tempPicker.tag] = pickerValues
                                self.ChTF[tempPicker.tag] = tempTF
                                self.scrollView.addSubview(tempTF)
                                yAxis += 40
                            } else if subJson["type"] == "yesNo" {
                                let yesButton = YesNoButton(frame: CGRect(x: 40, y: yAxis, width: 150, height: 30))
                                let noButton = YesNoButton(frame: CGRect(x:200, y: yAxis, width:150, height: 30))
                                yesButton.backgroundColor = UIColor.lightGray
                                yesButton.setTitle("Yes", for: UIControlState.normal)
                                yesButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                                yesButton.addTarget(self, action: #selector(self.yesNoButtonSelected), for: .touchUpInside)
                                yesButton.title = key
                                noButton.backgroundColor = UIColor.lightGray
                                noButton.setTitle("No", for: UIControlState.normal)
                                noButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                                noButton.addTarget(self, action: #selector(self.yesNoButtonSelected), for: .touchUpInside)
                                noButton.title = key
                                yesButton.alternateButton.append(noButton)
                                noButton.alternateButton.append(yesButton)
                                self.scrollView.addSubview(yesButton)
                                self.scrollView.addSubview(noButton)
                                yAxis += 40
                                self.YesNoArray.append(yesButton)
                            }

                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        //Loop through each object in JSON
        scrollView.contentSize = CGSize(width: self.view.intrinsicContentSize.width, height: CGFloat(yAxis+20))
    }
    
    //Create JSON with updated values
    func updateJSON(){
        
/*        //Text Fields (Tx)
        for field:PDFTextField in self.TFArray {
            print(field.text)
            self.json[field.title].dictionaryObject = ["type":"Tx","value":field.text!]
            print(field.title + ": \(self.json[field.title])")
        }
        
        //Check Box (Btn)
        for buttonGroup:CheckBoxGroup in self.OptionArray {
            var checkedButtons = [String]()
            for button:CheckBox in buttonGroup.buttons{
                if button.isOn {
                    checkedButtons.append(button.label)
                }
            }
            self.json[buttonGroup.title].dictionaryObject = ["type":"Btn","value":checkedButtons]
            print(buttonGroup.title + ": \(self.json[buttonGroup.title])")
        }
        
        //Dropdown Menu
        for picker in ChArray {
            let title = ChTag[picker.tag]
            var output = [String]()
            output.append((ChTF[picker.tag]?.text!)!)
            self.json[title!].dictionaryObject = ["type":"Ch","value":output]
        }
        
        //YesNo Button
        for button:YesNoButton in self.YesNoArray{
            self.json[button.title].dictionaryObject = ["type":"yesNo","value":button.value]
            print(button.title + ": \(self.json[button.title])")
        }
*/
        print("JSON: \(self.json)")
    }
    
    func yesNoButtonSelected(sender:YesNoButton){
        if(sender.value == "yes"){
            sender.value = "no"
            for i in 0...sender.alternateButton.count-1 {
                sender.alternateButton[i].value = "no"
            }
        } else {
            sender.value = "yes"
            for i in 0...sender.alternateButton.count-1 {
                sender.alternateButton[i].value = "yes"
            }
        }
        if(sender.backgroundColor == UIColor.blue){
            sender.backgroundColor = UIColor.lightGray
            for i in 0...sender.alternateButton.count-1 {
                sender.alternateButton[i].backgroundColor = UIColor.blue
            }
            sender.isSelected = false
            for i in 0...sender.alternateButton.count-1 {
                sender.alternateButton[i].isSelected = true
            }
        } else{
            sender.backgroundColor = UIColor.blue
            for i in 0...sender.alternateButton.count-1 {
                sender.alternateButton[i].backgroundColor = UIColor.lightGray
            }
            sender.isSelected = true
            for i in 0...sender.alternateButton.count-1 {
                sender.alternateButton[i].isSelected = false
            }
        }
    }

    
    //PICKER VIEW
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return ChData[pickerView.tag]!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        ChTF[pickerView.tag]?.text = String(describing: (ChData[pickerView.tag]?[row])!)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return ChData[pickerView.tag]?[row]
    }
    
    func donePicker(){
        for picker in ChArray {
            ChTF[picker.tag]?.resignFirstResponder()
        }
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
