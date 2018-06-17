//
//  CloudKitManager.swift
//  ContactsCloudKit
//
//  Created by Caston  Boyd on 6/15/18.
//  Copyright © 2018 Caston  Boyd. All rights reserved.
//

import Foundation
import CloudKit


class CloudKitManager {
    
    //MARK: - Setup Container
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - Save to Cloudkit
    func save(record: CKRecord, completion: @escaping((CKRecord?, Error?)-> Void )){
        publicDB.save(record, completionHandler: completion)
        
    }
    
    //MARK: - Load From CloudKit
    
    func load(completion: @escaping(([CKRecord]?, Error?)-> Void)){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Contact.TypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil, completionHandler: completion)
        
    }
    
    //MARK: - Update a Record From Cloudkit
    
    func update(record: CKRecord, completion: @escaping((CKRecord?, Error?) -> Void)) {
        publicDB.fetch(withRecordID: record.recordID, completionHandler: completion)
        
    }
    //MARK: - Delete Records
    func delete(record: CKRecord, completion: @escaping((CKRecordID?, Error?) -> Void)){
        publicDB.delete(withRecordID: record.recordID, completionHandler: completion)
        
    }
    
} /// End of Class Scope
