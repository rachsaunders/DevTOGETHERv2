//
//  CardViewController.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 19/11/2020.
//

import UIKit
import Shuffle_iOS
import Firebase
import ProgressHUD

class CardViewController: UIViewController {
    
    
    //MARK: - VARIABLES
    
    private let cardStack = SwipeCardStack()
    private var initialCardModels: [UserCardModel] = []
    private var secondCardModel: [UserCardModel] = []
    private var userObjects: [FUser] = []
    
    var lastDocumentSnapshot: DocumentSnapshot?
    var isInitialLoad = true
    var showReserve = false
    
    var numberOfCardsAdded = 0
    var initialLoadNumber = 3
    
    //MARK: - VIEW LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // only comment out the below to make dummy users!!
 //       createUsers()
        
        downloadInitialUsers()

        
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
    
    //MARK:- DOWNLOAD USERS
    
    private func downloadInitialUsers() {
        
        ProgressHUD.show()
        
        FirebaseListener.shared.downloadUsersFromFirebase(isInitialLoad: isInitialLoad, limit: initialLoadNumber, lastDocumentSnapshot: lastDocumentSnapshot) { (allUsers, snapshot) in
            
            if allUsers.count == 0 {
                ProgressHUD.dismiss()
            }
            
            self.lastDocumentSnapshot = snapshot
            self.isInitialLoad = false
            self.initialCardModels = []
            
            self.userObjects = allUsers
            
            for user in allUsers {
                user.getUserAvatarFromFirestore { (didSet) in
                    
                    let cardModel = UserCardModel(id: user.objectId,
                                                  name: user.username,
                                                  occupation: user.profession,
                                                  image: user.avatar)
                    
                    self.initialCardModels.append(cardModel)
                    self.numberOfCardsAdded += 1
                    
                    if self.numberOfCardsAdded == allUsers.count {
                        print("reload")
                        
                        DispatchQueue.main.async {
                            
                            ProgressHUD.dismiss()
                            self.layoutCardStackView()
                        }
                    }
                }
            }
            
            print("initial \(allUsers.count) recieved yay")
            self.downloadMoreUsersInBackground()
            
        }
        
        
    }
    
    private func downloadMoreUsersInBackground() {
        
        FirebaseListener.shared.downloadUsersFromFirebase(isInitialLoad: isInitialLoad, limit: 1000, lastDocumentSnapshot: lastDocumentSnapshot) { (allUsers, snapshot) in
            
            self.lastDocumentSnapshot = snapshot
            self.secondCardModel = []
            
            self.userObjects += allUsers
            
            for user in allUsers {
                user.getUserAvatarFromFirestore { (didSet) in
                    
                    let cardModel = UserCardModel(id: user.objectId,
                                                  name: user.username,
                                                  occupation: user.profession,
                                                  image: user.avatar)
                    
                    self.secondCardModel.append(cardModel)
                }
            }
            
        }
        
    }
    
    
    
    
//MARK:- NAVIGATION

    private func showUserProfileFor(userId: String) {

        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileTableView") as! UserProfileTableViewController

        self.present(profileView, animated: true, completion: nil)

    }


}

extension CardViewController: SwipeCardStackDelegate, SwipeCardStackDataSource {
    
    //MARK:- DATASOURCE
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = UserCard()
        card.footerHeight = 80
        card.swipeDirections = [.left, .right]
        
        for direction in card.swipeDirections {
            
            card.setOverlay(UserCardOverlay(direction: direction), forDirection: direction)
            
        }
        
        card.configure(withModel: showReserve ? secondCardModel[index] : initialCardModels[index])
        
        return card
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return showReserve ? secondCardModel.count : initialCardModels.count
    }
    
    //MARK: - Delegates
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        
        initialCardModels = []
        
        if showReserve {
            secondCardModel = []
        }
        
        showReserve = true
        layoutCardStackView()
        
        print("finished with cards")

    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        
        print("test yo")
    }
    
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {

        
        
        showUserProfileFor(userId: showReserve ? secondCardModel[index].id : initialCardModels[index].id)
        
        
    }
    
    
    
    
    
}
