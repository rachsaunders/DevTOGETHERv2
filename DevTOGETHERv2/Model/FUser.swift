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
    var dateOfBirth: Date
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
            self.dateOfBirth,
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
        dateOfBirth = _dateOfBirth
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
    
    init(_dictionary: NSDictionary) {
        
        objectId = _dictionary[kOBJECTID] as? String ?? ""
        email = _dictionary[kEMAIL]  as? String ?? ""
        username = _dictionary[kUSERNAME]  as? String ?? ""
        isMale = _dictionary[kISMALE] as? Bool ?? true
        devYears = _dictionary[kDEVYEARS]  as? String ?? ""
        profession = _dictionary[kPROFESSION]  as? String ?? ""
        jobTitle = _dictionary[kJOBTITLE] as? String ?? ""
        about = _dictionary[kABOUT] as? String ?? ""
        skills = _dictionary[kSKILLS] as? String ?? ""
        skillsLookingFor = _dictionary[kSKILLSLOOKINGFOR] as? String ?? ""
        city = _dictionary[kCITY] as? String ?? ""
        country = _dictionary[kCOUNTRY] as? String ?? ""
        lookingFor = _dictionary[kLOOKINGFOR] as? String ?? ""
        avatarLink = _dictionary[kAVATARLINK] as? String ?? ""
        likedIdArray = _dictionary[kLIKEDIDARRAY] as? [String]
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
        pushId = _dictionary[kPUSHID] as? String ?? ""
        
        if let date = _dictionary[kDATEOFBIRTH] as? Timestamp {
            dateOfBirth = date.dateValue()
        } else {
            dateOfBirth = _dictionary[kDATEOFBIRTH] as? Date ?? Date()
        }
        
        let placeHolder = isMale ? "mPlaceholder" : "fPlaceholder"
        
        avatar = UIImage (contentsOfFile: fileInDocumentsDirectory(filename: self.objectId)) ?? UIImage(named: placeHolder)
        
    }
    
    
    //MARK: - RETURNING CURRENT USER
    
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> FUser? {
        
        if Auth.auth().currentUser != nil {
            if let userDictionary = userDefaults.object(forKey: kCURRENTUSER) {
                return FUser(_dictionary: userDictionary as! NSDictionary)
                
            }
        }
        
        return nil
        
    }
    
    
    
    func getUserAvatarFromFirestore(completion: @escaping (_ didSet: Bool) -> Void) {
        
        FileStorage.downloadImage(imageUrl: self.avatarLink) { (avatarImage) in
            
            let placeholder = self.isMale ? "mPlaceholder" : "fPlaceholder"
            self.avatar = avatarImage ?? UIImage(named: placeholder)
            completion(true)
            
            
        }
    }
    
    
    //MARK:- LOGIN
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil {
                if authDataResult!.user.isEmailVerified {
                    
                    FirebaseListener.shared.downloadCurrentUserFromFirebase(userId: authDataResult!.user.uid, email: email)
                    
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
    
    //MARK: - EDIT USER PROFILE
    
    
    func updateUserEmail(newEmail: String, completion: @escaping (_ error: Error?) -> Void) {
        
        
        Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
            
            FUser.resendVerificationEmail(email: newEmail) { (error) in

            }
            completion(error)
        })
        
        
    }
    
    //MARK:- RESEND LINKS
    
    class func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                
                completion(error)
                
            })
            
        })
        
    }
    
    class func resetPassword(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    
    //MARK: - LOGOUT USER
    
    class func logOutCurrentUser(completion: @escaping(_ error: Error?) ->Void) {
        
        do {
            try Auth.auth().signOut()
            
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            completion(nil)

        } catch let error as NSError {
            completion(error)
        }
    }
    
    
    
    //MARK: - SAVE USER FUNCS
    
    func saveUserLocally() {
        
        userDefaults.setValue(self.userDictionary as! [String : Any], forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        
    }
    
    
    func saveUserToFireStore() {
        
        
        FirebaseReference(.User).document(self.objectId).setData(self.userDictionary as! [String : Any]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
        }
        
    }
    
}
