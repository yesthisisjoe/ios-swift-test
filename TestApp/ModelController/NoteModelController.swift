//
//  NoteModelController.swift
//  TestApp
//
//  Created by Joe Peplowski on 2017-05-29.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import UIKit
import CoreData

class NoteModelController {
    
    fileprivate(set) var notes: [NoteModel] = []
    fileprivate var managedContext: NSManagedObjectContext

    /// Initialize notes from persistent storage
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        
        do {
            let noteManagedObjects = try managedContext.fetch(fetchRequest)
            notes = noteManagedObjects.map { NoteModel(managedObject: $0) }
        } catch let error as NSError {
            print("Could not fetch notes from persistent storage. \(error), \(error.userInfo)")
        }
    }
    
    /// Add a new note to notes & persistent storage
    ///
    /// - Parameter note: The note to be added
    func add(_ note: NoteModel) {
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        let noteManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        noteManagedObject.setValue(note.text, forKey: "text")
        noteManagedObject.setValue(note.dateCreated, forKey: "dateCreated")
        
        do {
            try managedContext.save()
            notes.append(note)
        } catch let error as NSError {
            print("Could not save new note to persistent storage. \(error), \(error.userInfo)")
        }
    }
    
    /// Updates the text of an existing note (doesn't change the created date)
    ///
    /// - Parameters:
    ///   - note: The note to be updated
    ///   - newText: The note's new text
    func update(_ index: Int, newText: String) {
        
    }
    
    /// Deletes the note at the specified index
    ///
    /// - Parameter index: The index of the note to be deleted
    func delete(_ index: Int) {
        let note = notes[index]
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        let predicate = NSPredicate(format: "dateCreated == %@", note.dateCreated as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let managedObjectsToDelete = try managedContext.fetch(fetchRequest)
            
            guard managedObjectsToDelete.count == 1 else {
                print("Error retrieving note to delete.")
                return
            }
            
            managedContext.delete(managedObjectsToDelete[0])
            try managedContext.save()
            
            notes.remove(at: index)
        } catch let error as NSError {
            print("Could not delete note from persistent storage. \(error), \(error.userInfo)")
        }
    }
}
