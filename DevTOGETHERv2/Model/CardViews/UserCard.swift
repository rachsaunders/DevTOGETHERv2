//
//  UserCard.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 19/11/2020.
//

import Foundation
import Shuffle_iOS

class UserCard: SwipeCard {
        
    func configure(withModel model: UserCardModel) {
        content = UserCardContentView(withImage: model.image)
        footer = UserCardFooterView(withTitle: "\(model.name)", subTitle: model.occupation)
    }
}
