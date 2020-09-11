//
//  EntriesTableViewController.swift
//  SortListChallenge
//
//  Created by Leonardo Diaz on 9/10/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        setupView()
    }
    
    //MARK: - Properties
    private var rows = [[Entry]]()
    private var labelIds = [Int]()
    private let reuseID = "cellID"
    
    //MARK: - Helper Methods
    func setupView(){
        EntryController.fetchEntries { [weak self] (result) in
            DispatchQueue.main.async {
            switch result {
            case .success(let entries):
                self?.rows = entries
                self?.labelIds = EntryController.sections
                self?.tableView.reloadData()
            case .failure(let error):
                    self?.presentErrorToUser(localizedError: .thrownError(error))
                }
            }
        }
    }
    
    private func style(){
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = #colorLiteral(red: 0.9616786838, green: 0.6801171303, blue: 0.2791105807, alpha: 1)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        title = "Fetch"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return labelIds.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for i in 0..<labelIds.count {
            if i == section {
                return rows[i].count
            }
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let entry = rows[indexPath.section][indexPath.row]
        cell.textLabel?.text = entry.name
        cell.detailTextLabel?.text = "ListID: \(entry.listId)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List ID: \(labelIds[section])"
    }
}
