//
//  NotificationsViewController.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 01/12/2020.
//

import UIKit
import ProgressHUD

class NotificationsViewController: UIViewController {
    
    //MARK:- IBOUTLETS
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- VARIABLES
    
    var allLikes : [LikeObject] = []
    var allUsers: [FUser] = []
    
    
    //MARK:- VIEW LIFE CYCLE
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        downloadLikes()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        

        
    }
    
    
    //MARK:- Download Likes
    
    private func downloadLikes() {
        
        
        ProgressHUD.show()
        
        FirebaseListener.shared.downloadUserLikes { (allUserIds) in
            
            if allUserIds.count > 0 {
                

                FirebaseListener.shared.downloadUsersFromFirebase(withIds: allUserIds) { (allUsers) in
                    
                    ProgressHUD.dismiss()
                    
                    self.allUsers = allUsers
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            } else {
                ProgressHUD.dismiss()
            }
            
            
            
        }
        
    }
    
    
    //MARK:- NAVIGATION

        private func showUserProfileFor(user: FUser) {

            let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileTableView") as! UserProfileTableViewController
            
            profileView.userObject = user
            self.navigationController?.pushViewController(profileView, animated: true)
        }
    
    
    
    
    
}


extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LikeTableViewCell
        
        cell.setupCell(user: allUsers[indexPath.row])
        
        return cell

    }
    
    
}


extension NotificationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        showUserProfileFor(user: allUsers[indexPath.row])
    }
    
    
}

