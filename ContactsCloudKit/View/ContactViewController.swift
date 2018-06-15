//
//  ContactViewController.swift
//  ContactsCloudKit
//
//  Created by Caston  Boyd on 6/15/18.
//  Copyright © 2018 Caston  Boyd. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
    
    //MARK: - Properties
    var contact: Contact? {
        didSet {
         if isViewLoaded {
          updateViews()
                }
        }
    }


    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
   
    
    //MARK: - Update Info
    func updateViews() {
        guard let contact = contact else { return }
        nameTextField.text =  contact.name
        emailTextField.text = contact.email
        phoneNumberTextField.text = contact.phoneNumber
        
    }
    
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, name != "" else { return }
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber != "" else { return }
        guard let email = emailTextField.text, email != "" else { return }
        
            if let contact = contact {
                ContactController.shared.updateContact(contact: contact, name: name, email: email, phone: phoneNumber)
            } else {
                ContactController.shared.createContact(name: name, email: email, phoneNumber: phoneNumber)
            }
        
        
      self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }

}

