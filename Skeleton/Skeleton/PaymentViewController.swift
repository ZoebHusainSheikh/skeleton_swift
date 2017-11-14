//
//  PaymentViewController.swift
//  SaitamaCycles
//
//  Created by Nilesh K on 03/11/17.
//  Copyright © 2017 www.Systango.Skeleton. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController {
    var placeId:String?

    @IBOutlet weak var cardNoTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    
    func willPerformPayment(){
        view.endEditing(true)
        if areEntriesValid() {
            performAPICall()
        }
    }
    
    private func areEntriesValid() -> Bool {
        var message: String! = ""
        if (cardNoTextField?.text?.trimmed.length)! < 15 ||  (cardNoTextField?.text?.trimmed.length)! > 16{
            message = "Please enter a valid card number"
        } else if nameTextField?.text?.trimmed.length == 0 {
            message = "Please enter name on the card"
        } else if monthTextField?.text?.trimmed.length != 2 {
            message = "Please enter a valid month"
        } else if yearTextField?.text?.trimmed.length != 2 {
            message = "Year must contain 2 characters"
        } else if (cvvTextField?.text?.trimmed.length)! < 3 ||  (cvvTextField?.text?.trimmed.length)! > 4 {
            message = "Please enter a valid CVV"
        }
        
        //Show Banner
        if message.length != 0 {
            BannerManager.showFailureBanner(subtitle: message)
        }
        return message.length == 0
    }
    
    // MARK: - API Calls Methods
    
    func performAPICall(){
        RequestManager().performPaymentCreation(placeId: self.placeId!, creditCard: CreditCardModel(number: self.cardNoTextField.text!, name: self.nameTextField.text!, cvv: self.cvvTextField.text!, expiryMonth: self.monthTextField.text!, expiryYear: self.yearTextField.text!)) { (success, response) in
            print(response ?? Constants.kErrorMessage)
            if success {
                BannerManager.showSuccessBanner(subtitle: "Payment processed successfully")
                self.dismiss(animated: true, completion: nil)
            }
            else{
                let message:String? = response as? String
                BannerManager.showFailureBanner(subtitle: message ?? Constants.kErrorMessage)
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        willPerformPayment()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
