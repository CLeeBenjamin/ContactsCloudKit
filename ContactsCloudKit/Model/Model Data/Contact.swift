//
//  Contact.swift
//  ContactsCloudKit
//
//  Created by Caston  Boyd on 6/15/18.
//  Copyright © 2018 Caston  Boyd. All rights reserved.
//

import Foundation
import CloudKit

class Contact: Equatable {
    //MARK: - Create Keys
    static let TypeKey = "Contacts"
    fileprivate let NameKey = "Name"
    fileprivate let PhoneKey = "PhoneNumber"
    fileprivate let EmailAddressKey = "EmailAddress"
    
//    fileprivate let appleUserRefKey = "appleUserRef"

//MARK: - Create Properties
    var name: String
    var email: String
    var phoneNumber: String
//MARK: - AppleUserID
//    let appleUserRef: CKReference
    var recordID: CKRecordID?
    
    
//MARK: - Initialize Properties
    init(name: String, email: String, phoneNumber: String, recordID: CKRecordID = CKRecordID(recordName: UUID().uuidString)) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
//        self.appleUserRef = appleUserRef
        
    }
    
//MARK: - Create CKRecord (computed property)with TypeKey and add properties: Post
    var ckRecord: CKRecord {
        
        let record = CKRecord(recordType: Contact.TypeKey)
        record.setValue(name, forKey: NameKey)
        record.setValue(email, forKey: EmailAddressKey)
        record.setValue(phoneNumber, forKey: PhoneKey)
        
       return record
    }
    
//MARK: - Create Falliable Initializers: Fetch, if there is no data
    
    init?(cloudKitRecord: CKRecord){
        
        guard let name = cloudKitRecord[NameKey] as? String,
        let email = cloudKitRecord[EmailAddressKey] as? String,
        let phoneNumber = cloudKitRecord[PhoneKey] as? String else { return nil }
//        let appleUserRef = cloudKitRecord[appleUserRefKey] as? CKReference else { return nil }
        
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
//        self.appleUserRef = appleUserRef
        self.recordID = cloudKitRecord.recordID
    }
}

    func ==(lhs: Contact, rhs: Contact) -> Bool {
        if lhs.name != rhs.name { return false }
        if lhs.email != rhs.email { return false }
        if lhs.phoneNumber != rhs.phoneNumber { return false }
        
        return true
    
    
}


//MARK: - Add properties to CKReference

extension CKRecord {
    
    convenience init(contact: Contact) {
        let recordID = contact.recordID ?? CKRecordID(recordName: UUID().uuidString)
        
        //MARK: - Initialize RecordID
             self.init(recordType: Contact.TypeKey, recordID: recordID)
             self.setValue(contact.name, forKey: contact.NameKey)
             self.setValue(contact.email, forKey: contact.EmailAddressKey)
             self.setValue(contact.phoneNumber, forKey: contact.PhoneKey)
//             self.setValue(contact.appleUserRef, forKey: contact.appleUserRefKey)
        
    }
}







