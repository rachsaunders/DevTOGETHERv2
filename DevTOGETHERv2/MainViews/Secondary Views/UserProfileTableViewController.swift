//
//  UserProfileTableViewController.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 23/11/2020.
//

import UIKit
import SKPhotoBrowser

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
    
    
    
    //MARK:- VARIABLES
    
    
    var userObject: FUser?
    
    var allImages: [UIImage] = []
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 5.0)
    
    
    
    
    //MARK:- VIEW LIFE CYCLE
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageControl.hidesForSinglePage = true
        
        if userObject != nil {
            showUserDetails()
            loadImages()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgrounds()
        hideActivityIndicator()

        
    }
    
    //MARK:- IBACTIONS
    
    @IBAction func dislikeButtonPressed(_ sender: Any) {
        
        
        
        
    }
    
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        
        
    }
    
    
    
    //MARK:- TABLE VIEW DELEGATE
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
    }
    
    
  
    
    


    
    
    //MARK:- SETUP USER INTERFACE
    
    private func setupBackgrounds() {
        
        sectionOneView.clipsToBounds = true
        sectionOneView.layer.cornerRadius = 30
        sectionOneView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        sectionTwoView.layer.cornerRadius = 10
        sectionThreeView.layer.cornerRadius = 10
        sectionFourView.layer.cornerRadius = 10
        sectionFiveView.layer.cornerRadius = 10
        sectionSixView.layer.cornerRadius = 10
        
    }
    
    //MARK:- SHOW USER PROFILE
    
    private func showUserDetails(){
        
        aboutTextView.text = userObject!.about
        professionLabel.text = userObject!.profession
        jobLabel.text = userObject!.jobTitle
        skillsTextView.text = userObject!.skills
        skillsLookingForTextView.text = userObject!.skillsLookingFor
        genderLabel.text = userObject!.isMale ? "Male" : "Female"
        lookingForLabel.text = userObject!.lookingFor
        
    }
    
    //MARK:- ACTIVITY INDICATOR
    
    private func showActivityIndicator() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
    }
    
    private func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        
    }
    
    //MARK:- LOAD IMAGES
    
    private func  loadImages() {
        
        let placeholder = userObject!.isMale ? "mPlaceholder" : "fPlaceholder"
        let avatar = userObject!.avatar ?? UIImage(named: placeholder)
        
        allImages = [avatar!]
        self.setPageControlPages()
        
        self.collectionView.reloadData()
        
        if userObject!.imageLinks != nil && userObject!.imageLinks!.count > 0 {
            
            showActivityIndicator()
            
            FileStorage.downloadImages(imageUrls: userObject!.imageLinks!) { (returnedImages) in
                
                self.allImages += returnedImages as! [UIImage]
                
                
                DispatchQueue.main.async {
                    self.setPageControlPages()
                    self.hideActivityIndicator()
                    self.collectionView.reloadData()
                }
                
            }
            
        } else {
            hideActivityIndicator()
        }
        
    }
    
    
    //MARK:- PAGE CONTROL
    
    private func setPageControlPages() {
        
        self.pageControl.numberOfPages = self.allImages.count
    }
    
    private func setSelectedPageTo(page: Int) {
        self.pageControl.currentPage = page
    }
    
    //MARK:- SKPHOTO BROWSER
    
    private func showImages(_ images: [UIImage], startIndex: Int) {
        
        var SKImages : [SKPhoto] = []
        
        for image in images {
            SKImages.append(SKPhoto.photoWithImage(image))
            
        }
        
        let browser = SKPhotoBrowser(photos: SKImages)
        
        browser.initializePageIndex(startIndex)
        self.present(browser, animated: true, completion: nil)
        
    }
    

}

extension UserProfileTableViewController : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        let countryCity = userObject!.country + "," + userObject!.city
        let nameAge = userObject!.username
        
        cell.setupCell(image: allImages[indexPath.row], country: countryCity, nameAge: nameAge, indexPath: indexPath)
        
        return cell
        
    }
    
    
    
}

extension UserProfileTableViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        showImages(allImages, startIndex: indexPath.row)
    }
    
}


extension UserProfileTableViewController : UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.width, height: 453)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        setSelectedPageTo(page: indexPath.row)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left 
        
    }
    
}
    


