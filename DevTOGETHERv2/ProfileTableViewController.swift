//
//  ProfileTableViewController.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 12/11/2020.
//

import UIKit
import Gallery
import ProgressHUD

class ProfileTableViewController: UITableViewController {
    
    //MARK:- IBOUTLETS
    
    @IBOutlet weak var profileCellBackgroundView: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var aboutMeView: UIView!
    
    @IBOutlet weak var nameAgeLabel: UILabel!
    
    @IBOutlet weak var cityCountryLabel: UILabel!
    
    @IBOutlet weak var jobTextField: UITextField!
    
    @IBOutlet weak var professionTextField: UITextField!
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    @IBOutlet weak var skillsIHaveTextView: UITextView!
    
    @IBOutlet weak var skillsLookingForTextView: UITextView!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var lookingForTextField: UITextField!
    
    //MARK: - VARS
    
    var editingMode = false
    var uploadingAvatar = true
    
    var avatarImage: UIImage?
    var gallery: GalleryController!
    
    
    
    
    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        setupBackgrounds()
        
        if FUser.currentUser() != nil {
            loadUserData()
        updateEditingMode()
        }
       
       
    }
    
    // needs editing to add skills sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    //MARK:- IBACTIONS
    
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        showEditOptions()
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        showPictureOptions()
    }
    
  
    @IBAction func editButtonPressed(_ sender: Any) {
        
        editingMode.toggle()
        updateEditingMode()
        
        editingMode ? showKeyboard() : hideKeyboard()
        showSaveButton()
        
    }
    
    @objc func editUserData() {
        
        let user = FUser.currentUser()!
        
        user.about = aboutMeTextView.text
        user.jobTitle = jobTextField.text ?? ""
        user.profession = professionTextField.text ?? ""
        user.skills = skillsIHaveTextView.text
        user.skillsLookingFor = skillsLookingForTextView.text
        user.isMale = genderTextField.text == "Male"
        user.city = cityTextField.text ?? ""
        user.country = countryTextField.text ?? ""
        user.lookingFor = lookingForTextField.text ?? ""
        
        if avatarImage != nil {
            
            uploadAvatar(avatarImage!) { (avatarLink) in
                
                user.avatarLink = avatarLink ?? ""
                user.avatar = self.avatarImage
                
                self.saveUserData(user: user)
                self.loadUserData()
                
                
            }
            
        } else {
            
            saveUserData(user: user)
            loadUserData()
        }
        
        editingMode = false
        updateEditingMode()
        showSaveButton()
       
        
    }
    
    private func saveUserData(user: FUser) {
        
        user.saveUserLocally()
        user.saveUserToFireStore()
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
    
    private func showSaveButton() {
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editUserData))
        
        navigationItem.rightBarButtonItem = editingMode ? saveButton : nil
        
        
    }
    
    //MARK:- LOAD USER DATA
    
    private func loadUserData() {
        
  
        
        let currentUser = FUser.currentUser()!

        // DELETE LINE BELOW IF NOT NEEDED
        
        FileStorage.downloadImage(imageUrl: currentUser.avatarLink) { (image) in

        }
        
     
        nameAgeLabel.text = currentUser.username
        cityCountryLabel.text = currentUser.country + "," + currentUser.city
        aboutMeTextView.text = currentUser.about != "" ? currentUser.about : "A little bit about me..."
        
        skillsIHaveTextView.text = currentUser.skills != "" ? currentUser.skills : "Skills I have..."
        skillsLookingForTextView.text = currentUser.skillsLookingFor != "" ? currentUser.skillsLookingFor : "I'm looking for..."
        
        jobTextField.text = currentUser.jobTitle
        professionTextField.text = currentUser.profession
        genderTextField.text = currentUser.isMale ? "Male" : "Female"
        cityTextField.text = currentUser.city
        countryTextField.text = currentUser.country
        lookingForTextField.text = currentUser.lookingFor
        avatarImageView.image = UIImage(named: "avatar")
        
        avatarImageView.image = currentUser.avatar

        
        
    }
    
   //MARK:- EDITING MODE
    
    func updateEditingMode() {
        
        // add skills ones like the below
        
        aboutMeTextView.isUserInteractionEnabled = editingMode
        jobTextField.isUserInteractionEnabled = editingMode
        professionTextField.isUserInteractionEnabled = editingMode
        genderTextField.isUserInteractionEnabled = editingMode
        cityTextField.isUserInteractionEnabled = editingMode
        countryTextField.isUserInteractionEnabled = editingMode
        lookingForTextField.isUserInteractionEnabled = editingMode
        
    }
    
    //MARK: - HELPERS
    
    //MARK: - Helpers
    private func showKeyboard() {
        
        // add skills?
        self.aboutMeTextView.becomeFirstResponder()
    }

    private func hideKeyboard() {
        self.view.endEditing(false)
    }
    
    
    
    //MARK:- FILE STORAGE
    
    private func uploadAvatar(_ image: UIImage, completion: @escaping (_ avatarLink: String?)-> Void) {
        
        ProgressHUD.show()
        
        let fileDirectory = "Avatars/_" + FUser.currentId() + ".jpg"
        
        FileStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
            
            
            ProgressHUD.dismiss()
        
            FileStorage.saveImageLocally(imageData: image.jpegData(compressionQuality: 0.8)! as NSData, fileName: FUser.currentId())
        
            completion(avatarLink)
        }
        
        
        
    }
    
    private func uploadImages(images: [UIImage?]) {
        
        ProgressHUD.show()
        
        FileStorage.uploadImages(images) { (imageLinks) in
            
            let currentUser = FUser.currentUser()!
            
            currentUser.imageLinks = imageLinks
            
            self.saveUserData(user: currentUser)
            
        }
    }
    
    
    //MARK: - GALLERY
    
    private func showGallery(forAvatar: Bool) {
        
        
        uploadingAvatar = forAvatar
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = forAvatar ? 1 : 10
        Config.initialTab = .imageTab
        
        self.present(gallery, animated: true, completion: nil)
        
    }
    
    //MARK: - ALERTCONTROLLER
    
    private func showPictureOptions() {
        
        let alertController = UIAlertController(title: "Upload Picture", message: "You can change your Avatar or upload more pictures.", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change Avatar", style: .default, handler: { (alert) in
            
            self.showGallery(forAvatar: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Upload Pictures", style: .default, handler: { (alert) in
            
            self.showGallery(forAvatar: false)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func showEditOptions() {
        
        let alertController = UIAlertController(title: "Edit Account", message: "You are about to edit sensitive information about your account.", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change Email", style: .default, handler: { (alert) in
            
      //      self.showChangeField(value: "Email")
        }))
        
        alertController.addAction(UIAlertAction(title: "Change Name", style: .default, handler: { (alert) in
            
     //       self.showChangeField(value: "Name")
        }))
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (alert) in
            
        //    self.logOutUser()
        }))

        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    
    
}


extension ProfileTableViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        
        if images.count > 0 {
            
            if uploadingAvatar {
                images.first!.resolve { (icon) in
                    if icon != nil {
                        self.editingMode = true
                        self.showSaveButton()
                        
                        self.avatarImageView.image = icon
                        self.avatarImage = icon
                        
                    } else {
                        ProgressHUD.showError("Couldn't select image!")
                    }
                }
            } else {
                
                Image.resolve(images: images) { (resolvedImages) in
                    
                    self.uploadImages(images: resolvedImages)
                }
                
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
        
    }
               
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
