//
//  FCollectionReference.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 11/11/2020.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Like
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
    
}
