//
//  WelcomeViewController.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 06/11/2020.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {
    
    //MARK:- IBOUTLETS
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //MARK:- VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        setupBackgroundTouch()

    }
    
    
    

    //MARK:- IBACTIONS
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
        if emailTextField.text != "" {

            FUser.resetPassword(email: emailTextField.text!) { (error) in
                
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                } else {
                    ProgressHUD.showSuccess("Please check your email!")
                }
            }
            
        } else {
            ProgressHUD.showError("Please insert your email address.")
        }
    }
    
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            ProgressHUD.show()
            
            FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
                
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                } else if isEmailVerified {
                    ProgressHUD.dismiss()
                    self.goToApp()
                    
                } else {
                    ProgressHUD.showError("Please verify your email!")
                    
                }
                
            }
            
            
        } else {
            ProgressHUD.showError("All fields are required.")
        }
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
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    
    //MARK:- NAVIGATION
    
    private func goToApp() {
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
        
        
    }
}
