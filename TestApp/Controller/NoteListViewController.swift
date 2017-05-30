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
    
    fileprivate var noteModelController = NoteModelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "CreateNote":
            if let navigationController = segue.destination as? UINavigationController,
                let composeNoteViewController = navigationController.viewControllers.first as? ComposeNoteViewController {
                composeNoteViewController.noteModelController = noteModelController
            }
        case "EditNote":
            break // TODO: this
        default: break
        }
    }
    
    @IBAction func saveNote(_ segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    
    @IBAction func cancelComposeNote(_ segue: UIStoryboardSegue) {}
}

extension NoteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteModelController.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = noteModelController.notes[indexPath.row]
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
        
        let noteToDelete = noteModelController.notes[indexPath.row]
        noteModelController.delete(noteToDelete)
        tableView.reloadData()
    }
}
