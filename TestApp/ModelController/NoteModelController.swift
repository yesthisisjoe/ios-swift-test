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
    
    func update(_ note: NoteModel, newText: String) {
        
    }
    
    func delete(_ note: NoteModel) {
        
    }
}
