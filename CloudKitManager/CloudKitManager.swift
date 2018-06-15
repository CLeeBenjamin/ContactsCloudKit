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
    
    //MARK: - Make General Function
    
    func modify(records: [CKRecord], eachRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)? ){
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        operation.perRecordCompletionBlock = eachRecordCompletion
        operation.modifyRecordsCompletionBlock = { (records, _, error) in completion?(records, error) }
        
        publicDB.add(operation)
        
    }
    
    //MARK: - Save Records
    
    func save(records: [CKRecord], eachRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)? ) {
        
        modify(records: records, eachRecordCompletion: eachRecordCompletion, completion: completion)
        
    }
    
    
    
    //MARK: - Fetch
    func fetchRecordsWith(type: String, completion: @escaping ((_ records: [CKRecord]?, _ error: Error?) -> Void)){
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: type, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil, completionHandler: completion)
        
        
    }
    
    
    
    
} /// End of Class Scope