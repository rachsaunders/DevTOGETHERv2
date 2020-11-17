//
//  ProfileTableViewController.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 12/11/2020.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //MARK:- IBOUTLETS
    
    @IBOutlet weak var profileCellBackgroundView: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var aboutMeView: UIView!
    
    @IBOutlet weak var nameAgeLabel: UILabel!
    
    @IBOutlet weak var cityCountryLabel: UILabel!
    
    @IBOutlet weak var jobTextField: UITextField!
    
    @IBOutlet weak var educationTextField: UITextField!
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    @IBOutlet weak var skillsIHaveTextView: UITextView!
    
    @IBOutlet weak var skillsLookingForTextView: UITextView!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var lookingForTextField: UITextField!
    
    //MARK: - VARS
    
    var editingMode = false
    
    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgrounds()
        updateEditingMode()

       
    }
    
    // needs editing to add skills sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    //MARK:- IBACTIONS
    
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
    }
    
  
    @IBAction func editButtonPressed(_ sender: Any) {
        
        editingMode.toggle()
        updateEditingMode()
        
    }
    
    //MARK:- SETUP
    
    private func setupBackgrounds() {
        
        profileCellBackgroundView.clipsToBounds = true
        profileCellBackgroundView.layer.cornerRadius = 100
        profileCellBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        // add the skills one like this below
        // set background of text fields to clear colour as well
        
        aboutMeView.layer.cornerRadius = 10
    
    }
    
   //MARK:- EDITING MODE
    
    func updateEditingMode() {
        
        // add skills ones like the below
        
        aboutMeTextView.isUserInteractionEnabled = editingMode
        jobTextField.isUserInteractionEnabled = editingMode
        educationTextField.isUserInteractionEnabled = editingMode
        genderTextField.isUserInteractionEnabled = editingMode
        cityTextField.isUserInteractionEnabled = editingMode
        countryTextField.isUserInteractionEnabled = editingMode
        lookingForTextField.isUserInteractionEnabled = editingMode
        
    }
    
    
    
    
    
}
