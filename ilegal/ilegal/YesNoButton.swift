//
//  YesNoButton.swift
//  ilegal
//
//  Created by Yoo Jin Lee on 9/12/16.
//  Copyright © 2016 Yoo Jin. All rights reserved.
//

import UIKit

class YesNoButton: UIButton {
    
    var alternateButton = [YesNoButton]()
    var value:String = "no"
    var title:String = ""
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.masksToBounds = true
    }
    
    func unselectAlternateButtons(){
        self.isSelected = true
        for i in 0...alternateButton.count-1 {
            alternateButton[i].isSelected = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton() {
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = UIColor.blue.cgColor
            } else {
                self.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
