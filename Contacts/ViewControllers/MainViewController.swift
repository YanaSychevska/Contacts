//
//  MainViewController.swift
//  Contacts
//
//  Created by Yana on 16.07.2020.
//  Copyright © 2020 YanaInc. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    var contacts: Results<Contact>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contacts = realm.objects(Contact.self)
        
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.isEmpty ? 0 : contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomContactTableViewCell

        let contact = contacts[indexPath.row]
        
        cell.contactNameLabel.text = contact.name
        cell.phoneNumberLabel.text = contact.phoneNumber
        
        cell.contactImage.image = UIImage(data: contact.imageData!)
        cell.contactImage.layer.cornerRadius = cell.contactImage.frame.width/2
        cell.contactImage.clipsToBounds = true

        return cell
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        
        guard let newContactVC = segue.source as? NewContactViewController else { return }
        
        newContactVC.saveNewContact()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    // MARK: -Table view delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contact = contacts[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            
            StorageManager.deleteObject(contact)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeAction
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails"{
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let contact = contacts[indexPath.row]
            let newContactVC = segue.destination as! NewContactViewController
            newContactVC.currentContact = contact
        }
    }
}
