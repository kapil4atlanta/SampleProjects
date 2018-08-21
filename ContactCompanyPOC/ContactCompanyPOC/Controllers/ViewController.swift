//
//  ViewController.swift
//  ContactCompanyPOC
//
//  Created by Kapil Rathan on 6/19/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var filteredContacts = [ContactCompanyList.Contact]()
    fileprivate var filterring = false
    var contactsList: ContactCompanyList?
    
    @IBOutlet weak var contactsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        title = "Search or View Entities"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
        contactsTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        contactsTable.register(ContactsCell.self, forCellReuseIdentifier: "CellIdentifier")
        
        ContactsDataManager.shared.getContactsData { (isAvailable) in
            if !isAvailable{
                self.displayNoDataAlert()
            }else{
                self.contactsList = ContactsDataManager.shared.getContactsObject()
                self.contactsTable.reloadData()
            }
        }
    }

    private func displayNoDataAlert(){
        let alert = UIAlertController.init(title: "No Contacts Available", message: "Please Try Again", preferredStyle: .alert)
        navigationController?.present(alert, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let list = self.contactsList else {
            return
        }
        if  segue.identifier == "sgIdentifier",
            let destination = segue.destination as? DetailViewController,
            let blogIndex = self.contactsTable.indexPathForSelectedRow?.row
        {
            if filterring{
                destination.currentContact =  self.filteredContacts[blogIndex]
            }else{
                 destination.currentContact =  list.contacts[blogIndex]
            }
        }
    }

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let contacts = contactsList?.contacts{
             return self.filterring ? self.filteredContacts.count : contacts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! ContactsCell
        var cellText = ""
        guard let list = self.contactsList else {
            return cell
        }
        
        if filterring{
            if let companyName = self.filteredContacts[indexPath.row].companyName{
                 cellText = companyName
            }else if let name = self.filteredContacts[indexPath.row].name{
                cellText = name
            }
        }else{
            if let companyName = list.contacts[indexPath.row].companyName{
                cellText = companyName
            }else if let name = list.contacts[indexPath.row].name{
                cellText = name
            }
        }

        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = cellText
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "sgIdentifier", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty, let contacts = self.contactsList {
            self.filteredContacts = contacts.searchEntities(name: text)
            self.filterring = true
        }
        else {
            self.filterring = false
            self.filteredContacts = [ContactCompanyList.Contact]()
        }
        self.contactsTable.reloadData()
    }
}


