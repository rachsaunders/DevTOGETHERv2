//
//  FirebaseListener.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 11/11/2020.
//

import Foundation
import Firebase

class FirebaseListener {
    
    static let shared = FirebaseListener()
    
    private init() {}
    
    //MARK:- FUSER
    
    func downloadCurrentUserFromFirebase(userId: String, email: String) {
        
        FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if snapshot.exists {
                
                // see note 20
                FUser(_dictionary: snapshot.data() as! NSDictionary).saveUserLocally()
                
            } else {
                
                if let user = userDefaults.object(forKey: kCURRENTUSER) {
                    FUser(_dictionary: user as! NSDictionary).saveUserToFireStore()
                }
                
            }
            
        }
        
        
    }
    
}
