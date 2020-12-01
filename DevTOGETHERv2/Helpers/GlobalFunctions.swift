//
//  GlobalFunctions.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 27/11/2020.
//

import Foundation


//MARK:- SAVE LIKE
func saveLikeToUser(userId: String) {
    
    let like = LikeObject(id: UUID().uuidString, userId: FUser.currentId(), likedUserId: userId, date: Date())
    
    like.saveToFireStore()
    
    if let currentUser = FUser.currentUser() {
    
        if !didLikeUserWith(userId: userId) {
            
            currentUser.likedIdArray!.append(userId)
            
            currentUser.updateCurrentUserInFireStore(withValues: [kLIKEDIDARRAY: currentUser.likedIdArray]) { (error) in
                print("updated current user with error", error?.localizedDescription)
                
            }
        }
    }
}

func didLikeUserWith(userId: String) -> Bool {
    
    return FUser.currentUser()?.likedIdArray?.contains(userId) ?? false
    
}
