//
//  ContactTableViewController.swift
//  ContactsCloudKit
//
//  Created by Caston  Boyd on 6/15/18.
//  Copyright © 2018 Caston  Boyd. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController{
    
    // MARK: - Constants

    struct Constants {
         static let contactCellID = "ContactCell"
         static let segueID = "toContact"
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name.contactUpdate, object: nil)
    }
    
    @objc func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    


    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ContactController.shared.contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.contactCellID, for: indexPath)
        let contacts = ContactController.shared.contacts[indexPath.row]
        
        cell.textLabel?.text = contacts.name
        
        print(cell)
        return cell
        
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = ContactController.shared.contacts[indexPath.row]
            ContactController.shared.delete(contact: contact)
            guard let index = ContactController.shared.contacts.index(of: contact) else { return }
            ContactController.shared.contacts.remove(at:index)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
            
            
            
            //MARK: - Remove from tableView of nested arrays//////////
            
//            // this targets the actual row for a particular row on the tablview
//            let contact = ContactController.shared.contacts[indexPath.row]
//            // set value of variable indext to the index selected
////            guard let index = ContactController.shared.contacts.index(of: contact) else { return }
////            /// remove the index from the array
////            ContactController.shared.contacts.remove(at: index)
//
//            //MARK: - Remove from Record from Cloudkit//////
//
////            /// instance of CKReordID
////            guard let recordID = contact.recordID else { return }
//
//            /// cloudkit delete method, defined in contactcontroller
////            ContactController.shared.deleteContact(contact: contact)
////
//            ContactController.shared.delete(recordID: contact) { (error) in
//                if let error = error {
//                    print("Error deleting recordID \(#function) \(error)")
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            
            
            
            
            
////
//            }
//
//
//     }
////        else if editingStyle == .insert {
////            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
////        }
//    }
//
//    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueID {
            
            if let destinationVC = segue.destination as? ContactViewController,
                let selectedRow = tableView.indexPathForSelectedRow?.row {
                
                let contact = ContactController.shared.contacts[selectedRow]
                destinationVC.contact = contact
                
            }
        }
    }
}
  

