//
//  Person.swift
//  GreenDataTest
//
//  Created by yaruncle on 06.11.2020.
//  Copyright © 2020 yaruncle. All rights reserved.
//

import Foundation

// Класс для загрузки данных с сайта
class Person {
    let name : Name
    
    let gender : Gender
    let location : Location
    let email : String
    
    let dob : DOB
    
    let phoneNo : String
    let cellNo : String
    
    let profilePic : ProfilePicture
    
    init(dict : JsonObj) {
        name = Name(dict: dict["name"] as! StrDict)
        gender = Gender.parse(rawValue: dict["gender"] as! String) ?? Gender.other
        location = Location(dict: dict["location"] as! JsonObj)
        
        email = dict["email"] as? String ?? ""
        
        dob = DOB(dict: dict["dob"] as! JsonObj)
        
        phoneNo = dict["phone"] as? String ?? ""
        cellNo = dict["cell"] as? String ?? ""
        
        profilePic = ProfilePicture(dict: dict["picture"] as! StrDict)
    }
    
    func convertToEntity(context: EPerson) -> EPerson{
        context.lastName = self.name.last
        context.firstName = self.name.first
        context.age = Int16(self.dob.age)
        context.birthday = self.dob.birthDate
        context.email = self.email
        context.locationDescription = self.location.timezone.desc
        context.locationOffset = self.location.timezone.offset
        context.imageURL = self.profilePic.original
        
        if self.gender.rawValue == "MALE" {
            context.sex = true
        }
        else {
            context.sex = false
        }
        return context
    }
}
