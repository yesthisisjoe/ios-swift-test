//
//  ACNoteModel.swift
//  TestApp
//
//

import Foundation

class NoteModel {
    
    var text: String
    var dateCreated: Date
    
    init(text: String) {
        self.text = text
        self.dateCreated = Date()
    }
    
}
