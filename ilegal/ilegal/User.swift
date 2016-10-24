//
//  User.swift
//  ilegal
//
//  Created by Yoo Jin Lee on 9/14/16.
//  Copyright © 2016 Yoo Jin. All rights reserved.
//

import UIKit

open class User: NSObject {
    
    static let currentUser = User()
    var email:String!
    var password:String!
    var firstName:String!
    var lastName:String!
    var middleInitial:String?
    var addressOne:String!
    var addressTwo:String!
    var city:String!
    var state:String!
    var zipcode:String!
    var phone:String!
    var license:String!
    var active:Bool!
    var DOB:String!
    var id:String!
    var myFiles = [Form]()
    
    fileprivate override init() {
        email = ""
        password = ""
        firstName = ""
        lastName = ""
        middleInitial = ""
        addressOne = ""
        addressTwo = ""
        city = ""
        state = ""
        zipcode = ""
        phone = ""
        license = ""
        DOB = "0000-00-00"
        active = false;
        id = "777"
    }
    
    func setBirthday(_ month: String, day: String, year: String){
        self.DOB = year + "-" + month + "-" + day
    }
    
    func printUser()
    {
        print(self.firstName)
        print(self.lastName)
        print(self.middleInitial)
        print(self.email)
        print(self.password)
        print(self.addressOne)
        print(self.addressTwo)
        print(self.city)
        print(self.state)
        print(self.zipcode)
        print(self.phone)
        print(self.license)
        print(self.DOB)
    }
}


