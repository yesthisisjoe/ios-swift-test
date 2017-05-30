//
//  NoteListViewController.swift
//  TestApp
//
//  Created by Joe Peplowski on 2017-05-29.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import UIKit

class NoteListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)
    var noteModelController = NoteModelController()
    var noteSearchResults = [NoteModel]()
    
    var searchBarIsActive: Bool {
        return searchController.isActive &&
            !searchController.searchBar.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let composeNoteViewController = navigationController.viewControllers.first as? ComposeNoteViewController {
            composeNoteViewController.noteModelController = noteModelController
            
            switch segue.identifier! {
            case "CreateNote":
                composeNoteViewController.composeMode = .create
            case "EditNote":
                let note = getNoteAt(indexPath: tableView.indexPathForSelectedRow!)
                composeNoteViewController.composeMode = .edit
                composeNoteViewController.existingNote = note
            default: break
            }
            
        }
    }
    
    @IBAction func saveNote(_ segue: UIStoryboardSegue) {
        if searchBarIsActive {
            updateSearchResults(for: searchController)
        }
        tableView.reloadData()
    }
    
    @IBAction func cancelComposeNote(_ segue: UIStoryboardSegue) {}
    
    // Helper method for retrieving a note based whether or not we are viewing search results
    func getNoteAt(indexPath: IndexPath) -> NoteModel {
        if searchBarIsActive {
            return noteSearchResults[indexPath.row]
        } else {
            return noteModelController.notes[indexPath.row]
        }
    }
}

extension NoteListViewController: UITableViewDataSource {
    
    // MARK: Table view data source functionality
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarIsActive {
            return noteSearchResults.count
        } else {
            return noteModelController.notes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = getNoteAt(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as! NoteTableViewCell
        cell.model = NoteTableViewCell.Model(note: note)
        return cell
    }
    
    // MARK: Delete note functionality
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        noteModelController.delete(indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: Search functionality
extension NoteListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        noteSearchResults = noteModelController.notes.filter { note in
            let lowerCasedSearchText = searchController.searchBar.text!.lowercased()
            let lowerCasedNoteText = note.text.lowercased()
            
            return lowerCasedNoteText.contains(lowerCasedSearchText)
        }
        
        tableView.reloadData()
    }
    
}
