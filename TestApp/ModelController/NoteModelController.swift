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

    
    /// Initialize notes in chronological order from persistent storage
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let noteManagedObjects = try managedContext.fetch(fetchRequest)
            notes = noteManagedObjects.map { NoteModel(managedObject: $0) }
        } catch let error as NSError {
            print("Could not fetch notes from persistent storage. \(error), \(error.userInfo)")
        }
    }
    
    
    /// Add a new note
    ///
    /// - Parameter note: The note to be added
    func add(_ note: NoteModel) {
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        let noteManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        noteManagedObject.setValue(note.text, forKey: "text")
        noteManagedObject.setValue(note.dateCreated, forKey: "dateCreated")
        
        do {
            try managedContext.save()
            notes.insert(note, at: 0)
        } catch let error as NSError {
            print("Could not save new note to persistent storage. \(error), \(error.userInfo)")
        }
    }
    
    
    /// Update the text of an existing note (without changing the created date)
    ///
    /// - Parameters:
    ///   - index: The index of the note to be updated
    ///   - newText: The note's new text
    func update(_ index: Int, newText: String) {
        guard let managedObjectToUpdate = getManagedObjectForNoteAt(index) else {
            print("Could not retrieve managed object to update.")
            return
        }
        
        do {
            managedObjectToUpdate.setValue(newText, forKey: "text")
            try managedContext.save()
            
            notes[index].text = newText
        } catch let error as NSError {
            print("Could not update note from persistent storage. \(error), \(error.userInfo)")
        }
    }
    
    
    /// Delete the note at the specified index
    ///
    /// - Parameter index: The index of the note to be deleted
    func delete(_ index: Int) {
        guard let managedObjectToDelete = getManagedObjectForNoteAt(index) else {
            print("Could not retrieve managed object to delete.")
            return
        }
        
        do {
            managedContext.delete(managedObjectToDelete)
            try managedContext.save()
            
            notes.remove(at: index)
        } catch let error as NSError {
            print("Could not delete note from persistent storage. \(error), \(error.userInfo)")
        }
    }
    
    
    /// Retrieve the managed object for the note at the given index from persistent storage
    ///
    /// - Parameter index: Index of the note to retrieve
    /// - Returns: The managed object for the note at the given index
    fileprivate func getManagedObjectForNoteAt(_ index: Int) -> NSManagedObject? {
        let note = notes[index]
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        let predicate = NSPredicate(format: "dateCreated == %@", note.dateCreated as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let managedObjects = try managedContext.fetch(fetchRequest)
            
            guard managedObjects.count == 1 else {
                return nil
            }
            
            return managedObjects[0]
        } catch let error as NSError {
            print("Error retrieving . \(error), \(error.userInfo)")
            return nil
        }
    }
}
