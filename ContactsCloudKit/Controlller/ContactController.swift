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
    
    //MARK: - CloudKitManager
    let cloudKitManager = CloudKitManager()
    //MARK: - Shared Instance
    static let shared = ContactController()
    
    //MARK: - Source of Truth: Property
    var contacts = [Contact]() {
        didSet {
            DispatchQueue.main.async {
            NotificationCenter.default.post(name: .contactUpdate, object: self)
                
            }
        }
    }

    init() {
       loadFromCloud()
    }
    
    //MARK: - CRUD
    func createContact(name: String, email: String, phoneNumber: String){
        ///Create contact
        let createdContact = Contact(name: name, email: email, phoneNumber: phoneNumber)
        contacts.append(createdContact)
        print(createdContact)
        
        ///Turn contact to CKRecord
        let contactBeRecord = CKRecord(contact: createdContact)
        
        print(contactBeRecord)
        
        // Save to cloud
        cloudKitManager.save(record: contactBeRecord) { (record, error) in
            if let error = error {
                print("Error saving record \(#function) \(error) \(error.localizedDescription)")
        }
            // Assign recordID of CKrecord to created object
            guard let record = record else { return }
            createdContact.ckRecordID = record.recordID
            self.contacts.append(createdContact)
        }
        
        print(contacts)
//        saveToStorageContainer()
        
    }
    
    
    func updateContact(contact: Contact, name: String, email: String, phone: String){
        /// assign new info to object
        contact.name = name
        contact.email = email
        contact.phoneNumber = phone
        ///save as a CKRecord
        let record = CKRecord(contact: contact)
        
        /// update CKRecord in the cloud
        //ckmanager.update fetches a record
        cloudKitManager.update(record: record) { (record, error) in
            if let error = error {
                print("Error ... \(#function) \(error) \(error.localizedDescription)")
            }
            guard let record = record else { return }
            /// right here you are setting your new name, email, phone
            record.setObject(name as CKRecordValue, forKey: contact.name )
            record.setObject(email as CKRecordValue, forKey: contact.email)
            record.setObject(phone as CKRecordValue, forKey: contact.phoneNumber)
            
            ///Save to the cloud
            self.cloudKitManager.save(record: record, completion: { ( _, error) in
                if let error = error {
                    print("Error saving recordID \(#function) \(error) \(error.localizedDescription)")
                }
            })
        }
    }
    
    
    func update(contact: Contact, name: String, email: String, phone: String, completion: @escaping (Error?) -> Void) {
       
        contact.name = name
        contact.email = email
        contact.phoneNumber = phone
        
     
        let recordToModify = CKRecord(contact: contact)
        // May or may not cover
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToModify], recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        operation.perRecordCompletionBlock = nil
        // The completion block that happens after the modify records operation
        operation.modifyRecordsCompletionBlock = { (_, _, error) in
            completion(error)
        }
        cloudKitManager.publicDB.add(operation)
    }
    
    
    
    func delete(contact: Contact){
        let record = CKRecord(contact: contact)
        cloudKitManager.delete(record: record) { (record, error) in
            if let error = error {
                print("Error deleting recordID \(#function) \(error) \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Storage Methods
    
    func loadFromCloud() {
        cloudKitManager.load { (record, error) in
            if let error = error {
                print("Error deleting recordID \(#function) \(error) \(error.localizedDescription)")
            }
            var fetchRecords = [Contact]()
            guard let record = record else { return }
            for records in record {
                let newContact = Contact(cloudKitRecord: records)
                guard let contact = newContact else { continue }
                fetchRecords.append(contact)
            }
            self.contacts = fetchRecords
            
        }
        
    }
}

