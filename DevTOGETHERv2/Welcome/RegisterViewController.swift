//
//  RegisterViewController.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 06/11/2020.
//

import UIKit
import ProgressHUD

class RegisterViewController: UIViewController {
    
    
    //MARK:- IBOUTLETS
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    
    @IBOutlet weak var yearDevTextField: UITextField!
    
    
    
    @IBOutlet weak var genderSegmentOutlet: UISegmentedControl!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //MARK:- VARIABLES
    
    var isMale = true
 
    
    //MARK:- VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .dark
        setupBackgroundTouch()
    
        
        
    }
    
    //MARK:- IBACTIONS
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if isTextDataImputed() {
            if passwordTextField.text! == confirmPasswordTextField.text! {
                registerUser()
            } else {
                ProgressHUD.showError("Passwords don't match")
            }
            
        } else {
            ProgressHUD.showError("All fields are required!")
        }
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func genderSegmentValueChanged(_ sender: UISegmentedControl) {
        isMale = sender.selectedSegmentIndex == 0
    }
    

    //MARK:- SETUP
        private func setupBackgroundTouch(){
        
        backgroundImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        backgroundImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        dismissKeyboard()
    }

    //MARK:- HELPERS
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
        
    }
    
    
    @objc func doneClicked() {
        
        
    }
    
    private func isTextDataImputed() -> Bool {
        return usernameTextField.text != "" && emailTextField.text != "" && cityTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != "" && yearDevTextField.text != ""
        
        
    }
    
    //MARK: - RegisterUser
    
    private func registerUser() {
     
        ProgressHUD.show()
        
        FUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!, userName: usernameTextField.text!, city: cityTextField.text!, devYears: yearDevTextField.text!, isMale: isMale, dateOfBirth: datePicker.date, completion:  {
            error in
                                
            if error == nil {
                ProgressHUD.showSuccess("Verification email sent!")
                self.dismiss(animated: true, completion: nil)
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }

        })
    }
    
}
