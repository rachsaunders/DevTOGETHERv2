//
//  UserProfileTableViewController.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 23/11/2020.
//

import UIKit

class UserProfileTableViewController: UITableViewController {

    //MARK:- IBOUTLETS
    
    //SECTION VIEWS
    @IBOutlet weak var sectionOneView: UIView!
    @IBOutlet weak var sectionTwoView: UIView!
    @IBOutlet weak var sectionThreeView: UIView!
    @IBOutlet weak var sectionFourView: UIView!
    @IBOutlet weak var sectionFiveView: UIView!
    @IBOutlet weak var sectionSixView: UIView!
    
    // COLLECTION VIEW
    @IBOutlet weak var collectionView: UICollectionView!
    
    // BUTTONS AND LABELS SECTION ONE
    @IBOutlet weak var dislikeButtonOutlet: UIButton!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // TEXT VIEWS AND LABELS
    @IBOutlet weak var aboutTextView: UITextView!
    
    @IBOutlet weak var professionLabel: UILabel!
    
    @IBOutlet weak var jobLabel: UILabel!
    
    @IBOutlet weak var skillsTextView: UITextView!
    
    @IBOutlet weak var skillsLookingForTextView: UITextView!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var lookingForLabel: UILabel!
    
    
    
    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgrounds()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
    
    
    
    //MARK:- SETUP USER INTERFACE
    
    private func setupBackgrounds() {
        
        sectionOneView.clipsToBounds = true
        sectionOneView.layer.contents = 30
        sectionOneView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        sectionTwoView.layer.cornerRadius = 10
        sectionThreeView.layer.cornerRadius = 10
        sectionFourView.layer.cornerRadius = 10
        sectionFiveView.layer.cornerRadius = 10
        sectionSixView.layer.cornerRadius = 10
        
    }

}
