//
//  ACNoteModel.swift
//  TestApp
//
//

import Foundation
import CoreData

struct NoteModel {
    
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

extension NoteModel: Equatable {
    
    static func == (lhs: NoteModel, rhs: NoteModel) -> Bool {
        return
            lhs.text == rhs.text &&
            lhs.dateCreated == rhs.dateCreated
    }
    
}
