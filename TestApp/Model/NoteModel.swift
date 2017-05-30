//
//  ACNoteModel.swift
//  TestApp
//
//

import Foundation
import CoreData

class NoteModel {
    var text: String
    var dateCreated: Date
    
    init(text: String) {
        self.text = text
        self.dateCreated = Date()
    }
    
    init(managedObject: NSManagedObject) {
        self.text = managedObject.value(forKeyPath: "text") as! String
        self.dateCreated = managedObject.value(forKeyPath: "dateCreated") as! Date
    }
}
