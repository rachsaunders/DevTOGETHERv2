//
//  CardViewController.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 19/11/2020.
//

import UIKit
import Shuffle_iOS
import Firebase

class CardViewController: UIViewController {
    
    
    //MARK: - VARIABLES
    
    private let cardStack = SwipeCardStack()
    private var initialCardModels: [UserCardModel] = []
    
    
    //MARK: - VIEW LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()

        let user = FUser.currentUser()!
        
        let cardModel = UserCardModel(id: user.objectId, name: user.username, occupation: user.profession, image: user.avatar)
        
        initialCardModels.append(cardModel)
        layoutCardStackView()
        
    }
    
   
  
    
    //MARK: - LAYOUT CARDS
    
    private func layoutCardStackView() {
        
        cardStack.delegate = self
        cardStack.dataSource = self
        
        view.addSubview(cardStack)
        
        cardStack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor)
    }


}

extension CardViewController: SwipeCardStackDelegate, SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = UserCard()
        card.footerHeight = 80
        card.swipeDirections = [.left, .right]
        
        for direction in card.swipeDirections {
            
            card.setOverlay(UserCardOverlay(direction: direction), forDirection: direction)
            
        }
        
        card.configure(withModel: initialCardModels[index])
        
        return card
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return initialCardModels.count
    }
    
    
    
}
