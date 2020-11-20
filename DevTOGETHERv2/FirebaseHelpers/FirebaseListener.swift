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
                let user = FUser(_dictionary: snapshot.data() as! NSDictionary)
                user.saveUserLocally()
                
                user.getUserAvatarFromFirestore { (didSet) in
                    
                }
                
            } else {
                
                if let user = userDefaults.object(forKey: kCURRENTUSER) {
                    FUser(_dictionary: user as! NSDictionary).saveUserToFireStore()
                }
                
            }
            
        }
        
    }
        func downloadUsersFromFirebase(isInitialLoad: Bool, limit: Int, lastDocumentSnapshot: DocumentSnapshot?, completion: @escaping (_ users: [FUser], _ snapshot: DocumentSnapshot?) -> Void) {
            
            var query: Query!
            var users: [FUser] = []
            
            if isInitialLoad {
                
                query = FirebaseReference(.User).order(by: kREGISTEREDDATE, descending: false).limit(to: limit)
                
                print("first \(limit) users loading")
                
            } else {
                
                
                if lastDocumentSnapshot != nil {
                    query = FirebaseReference(.User).order(by: kREGISTEREDDATE, descending: false).limit(to: limit).start(afterDocument: lastDocumentSnapshot!)
                    
                    print("im so tired who can see this? Oh yeah, just me")
                } else {
                    print("what the actual hell last snapshot is nil")
                }
                
            }
            
            if query != nil {
                
                query.getDocuments { (snapshot, error) in
                    
                    guard let snapshot = snapshot else { return }
                    
                    if !snapshot.isEmpty {
                        
                        for userData in snapshot.documents {
                            
                            let userObject = userData.data() as NSDictionary
                            
                            if !(FUser.currentUser()?.likedIdArray?.contains(userObject[kOBJECTID] as! String) ?? false) && FUser.currentId() != userObject[kOBJECTID] as! String {
                                
                                users.append(FUser(_dictionary: userObject))
                                
                            }
                            
                        }
                        
                        completion(users, snapshot.documents.last!)
                        
                    } else {
                        print("no more users to fetch")
                        
                        completion(users, nil)
                    }
                    
                }
                
                
            } else {
                completion(users, nil)
            }
            
            
            
        }
        
    }

