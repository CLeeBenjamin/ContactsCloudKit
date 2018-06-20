//
//  ContactViewController.swift
//  ContactsCloudKit
//
//  Created by Caston  Boyd on 6/15/18.
//  Copyright © 2018 Caston  Boyd. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    var contact: Contact?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
   
    
    //MARK: - Update Info
    func updateViews() {
        title = contact == nil ? "Add Contact" : "Edit Contact"
        
        guard let contact = contact else { return }
        nameTextField.text =  contact.name
        emailTextField.text = contact.email
        phoneNumberTextField.text = contact.phoneNumber
        
    }
    
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty, let email = emailTextField.text, let phone = phoneNumberTextField.text else { return }
        
        if let contact = contact {
            ContactController.shared.update(contact: contact, name: name, email: email, phone: phone) { (error) in
                if let error = error {
                    print("There was an error updating the entry: \(error)")
                    // Do something else to notify user
                    return
                }
                else {
                    
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
                    
        ContactController.shared.createContact(name: name, email: email, phoneNumber: phone)
            
        DispatchQueue.main.async {
        self.navigationController?.popViewController(animated: true)
        }
    }
}


