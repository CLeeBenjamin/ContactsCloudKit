//
//  ContactController.swift
//  ContactsCloudKit
//
//  Created by Caston  Boyd on 6/15/18.
//  Copyright © 2018 Caston  Boyd. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    
    
    //MARK: - Source of Truth: Property
    var contacts = [Contact]() {
        didSet {
            NotificationCenter.default.post(name: .contactUpdate, object: self)
            
        }
    }
    
    //MARK: - Shared Instance
    static let shared = ContactController()
    //MARK: - CloudKitManager
    let cloudKitManager = CloudKitManager()
    
    init() {
        loadFromStorageContainer()
    }
    
    //MARK: - CRUD
    func createContact(name: String, email: String, phoneNumber: String){
        
        let contact = Contact(name: name, email: email, phoneNumber: phoneNumber)
        contacts.append(contact)
        
        saveToStorageContainer()
        
    }
    
    func retrieveContact(){
        
        
    }
    
    
    func updateContact(contact: Contact, name: String, email: String, phone: String){
        contact.name = name
        contact.email = email
        contact.phoneNumber = phone
        
        saveToStorageContainer()
        
    }
    
    func deleteContact(){
       
        
               
    }
    
    //MARK: - Storage Methods
    
    
    private func loadFromStorageContainer(){
        cloudKitManager.fetchRecordsWith(type: Contact.TypeKey) { (records, error) in
            if let error = error {
                print("Error loading \(#function) \(error) \(error.localizedDescription)")
            }
            
            //MARK: - Load Recent Record
            guard let records = records else { return }
            
            let contacts = records.compactMap({Contact(cloudKitRecord: $0)})
            self.contacts = contacts
            
        }
        
    }
    
    private func saveToStorageContainer(){
        
        let contactRecords = self.contacts.map({$0.ckRecord})
        
        cloudKitManager.save(records: contactRecords, eachRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error ... \(#function) \(error) \(error.localizedDescription)")
                return
                
            } else {
                
                print("It's saved")
            }
        }
        
    }
    
}


