//
//  FUser.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 07/11/2020.
//

import Foundation
import Firebase
import UIKit

class FUser: Equatable {
    static func == (lhs: FUser, rhs: FUser) -> Bool {
        lhs.objectId == rhs.objectId
    }
    
    
    let objectId: String
    var email: String
    var username: String
    var dateofBirth: Date
    var devYears: String
    var isMale: Bool
    var avatar: UIImage?
    var profession: String
    var jobTitle: String
    var about: String
    var skills: String
    var skillsLookingFor: String
    var city: String
    var country: String
    var lookingFor: String
    var avatarLink: String
    
    var likedIdArray: [String]?
    var imageLinks: [String]?
    
    let registeredDate = Date()
    var pushId: String?
    
    
    var userDictionary: NSDictionary {
        
        return NSDictionary(objects: [
            
            self.objectId,
            self.email,
            self.username,
            self.dateofBirth,
            self.devYears,
            self.isMale,
            self.profession,
            self.jobTitle,
            self.about,
            self.skills,
            self.skillsLookingFor,
            self.city,
            self.country,
            self.lookingFor,
            self.avatarLink,
            
            self.likedIdArray ?? [],
            self.imageLinks ?? [],
            self.registeredDate,
            self.pushId ?? ""
            
            
            
        ],
        
        forKeys: [kOBJECTID as NSCopying,
                  kEMAIL as NSCopying,
                  kUSERNAME as NSCopying,
                  kDATEOFBIRTH as NSCopying,
                  kDEVYEARS as NSCopying,
                  kISMALE as NSCopying,
                  kPROFESSION as NSCopying,
                  kJOBTITLE as NSCopying,
                  kABOUT as NSCopying,
                  kSKILLS as NSCopying,
                  kSKILLSLOOKINGFOR as NSCopying,
                  kCITY as NSCopying,
                  kCOUNTRY as NSCopying,
                  kLOOKINGFOR as NSCopying,
                  kAVATARLINK as NSCopying,
                  kLIKEDIDARRAY as NSCopying,
                  kIMAGELINKS as NSCopying,
                  kREGISTEREDDATE as NSCopying,
                  kPUSHID as NSCopying
                  
                  
                  
                  
                  
        ])
        
    }
    
    
    //MARK:- INITIALISERS
    
    
    init(_objectId: String, _email: String, _username: String, _city: String, _dateOfBirth: Date, _devYears: String, _isMale: Bool, _avatarLink: String = "") {
        
        objectId = _objectId
        email = _email
        username = _username
        dateofBirth = _dateOfBirth
        isMale = _isMale
        devYears = _devYears
        profession = ""
        jobTitle = ""
        about = ""
        skills = ""
        skillsLookingFor = ""
        city = _city
        country = ""
        lookingFor = ""
        avatarLink = _avatarLink
        likedIdArray = []
        imageLinks = []
        
        
    }
    
    //MARK:- LOGIN
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil {
                if authDataResult!.user.isEmailVerified {
                    
                    // check if user exists already in firebase
                    completion(error, true)
                } else {
                    print("email isn't verified!")
                    completion(error, false)
                }
            } else {
                completion(error, false)
                
            }
            
        }
        
    }
    
    
    //MARK:- REGISTER
    
    class func registerUserWith(email: String, password: String, userName: String, city: String, devYears: String, isMale: Bool, dateOfBirth: Date, completion: @escaping (_ error: Error?) -> Void) {
        
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            
            completion(error)
            
            if error == nil {
                
                authData!.user.sendEmailVerification { (error) in
                    print("auth email verification sent ", error?.localizedDescription)
                }
                
                if authData?.user != nil {
                    
                    let user = FUser(_objectId: authData!.user.uid, _email: email, _username: userName, _city: city, _dateOfBirth: dateOfBirth, _devYears: devYears, _isMale: isMale)
                    
                    user.saveUserLocally()
                }
            }
        }
    }
    
    func saveUserLocally() {
        
        userDefaults.setValue(self.userDictionary as! [String : Any], forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        
    }
    
    
}
