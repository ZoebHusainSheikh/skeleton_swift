//
//  AuthenticationViewController.swift
//  SaitamaCycles
//
//  Created by Nilesh K on 03/11/17.
//  Copyright © 2017 www.Systango.Skeleton. All rights reserved.
//

import UIKit

enum AuthType {
    case LoginType
    case SignupType
    
    func isLoginViewActivated() -> Bool {
        return self == .LoginType
    }
}

class AuthenticationViewController: BaseViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var otherAuthButton: UIButton!
    @IBOutlet weak var otherLabel: UILabel!
    
    var authType:AuthType = .LoginType
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    
    func initialSetup(){
        let title:String = authType.isLoginViewActivated() ? "Sign up" : "Sign in"
        let otherTitle:String = authType.isLoginViewActivated() ? "Sign in" : "Sign up"
        let otherLabelText:String = authType.isLoginViewActivated() ? "Don’t have an account?" : "Already have an account?"
        otherAuthButton.setTitle(title, for: .normal)
        otherLabel.text = otherLabelText
        authButton.setTitle(otherTitle, for: .normal)
        
    }
    
    private func areEntriesValid(forSignup:Bool) -> Bool {
        var message: String! = ""
        if emailTextField?.text?.trimmed.length == 0 {
            message = "Please enter email"
        } else if !(emailTextField?.text?.trimmed.isEmail)! {
            message = "Please enter a valid email"
        } else if forSignup && (passwordTextField?.text?.length)! < 6 {
            message = "Password must contain at least 6 characters"
        } else if !forSignup && (passwordTextField?.text?.length)! == 0 {
            message = "Please enter password"
        }
        
        //Show Banner
        if message.length != 0 {
            BannerManager.showFailureBanner(subtitle: message)
        }
        return message.length == 0
    }
    
    func willPerformAuthentication(){
        view.endEditing(true)
        if authType.isLoginViewActivated() ? areEntriesValid(forSignup: false) : areEntriesValid(forSignup: true) {
            performAPICall()
        }
    }
    
    func performNavigation(){
        if authType.isLoginViewActivated() {
            let authViewController: AuthenticationViewController = self.storyboard!.instantiateViewController(withIdentifier: "AuthenticationViewController") as! AuthenticationViewController
            authViewController.authType = .SignupType
            self.navigationController?.pushViewController(authViewController, animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func didAuthenticationSuccessfull(){
        let mapViewController: MapViewController = self.storyboard!.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let navController:UINavigationController = UINavigationController(rootViewController: mapViewController)
        ApplicationDelegate.window?.rootViewController = navController
    }
    
    // MARK: - API Calls Methods
    
    func performAPICall(){
        RequestManager().performAuthentication(email: emailTextField.text!, password: passwordTextField.text!, authType: authType) { (success, response) in
            print(response ?? Constants.kErrorMessage)
            if success {
                self.didAuthenticationSuccessfull()
            }
            else{
                let message:String? = response as? String
                BannerManager.showFailureBanner(subtitle: message ?? Constants.kErrorMessage)
            }
        }
    }
    
    // MARK: - TextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else{
            willPerformAuthentication()
        }
        
        return true
    }
    
    // MARK: - IBActions

    @IBAction func authButtonTapped(_ sender: UIButton) {
        willPerformAuthentication()
    }
    
    @IBAction func otherAuthButtonTapped(_ sender: UIButton) {
        performNavigation()
    }
}
