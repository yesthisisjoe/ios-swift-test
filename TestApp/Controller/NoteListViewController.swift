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
    
    fileprivate var searchController = UISearchController(searchResultsController: nil)
    fileprivate var noteModelController = NoteModelController()
    fileprivate var noteSearchResults = [NoteModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
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
        tableView.reloadData()
    }
    
    @IBAction func cancelComposeNote(_ segue: UIStoryboardSegue) {}
    
    func getNoteAt(indexPath: IndexPath) -> NoteModel {
        if searchController.isActive &&
            !searchController.searchBar.text!.isEmpty {
            return noteModelController.notes[indexPath.row]
        } else {
            return noteSearchResults[indexPath.row]
        }
    }
}

extension NoteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive &&
            !searchController.searchBar.text!.isEmpty {
            return noteSearchResults.count
        } else {
            return noteModelController.notes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = getNoteAt(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as! NoteTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let dateString = dateFormatter.string(from: note.dateCreated)
        
        cell.dateLabel?.text = dateString
        cell.noteTextLabel?.text = note.text
        
        return cell
    }
    
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
