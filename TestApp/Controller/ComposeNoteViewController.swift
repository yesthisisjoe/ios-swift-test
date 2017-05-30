//
//  ComposeNoteViewController.swift
//  TestApp
//
//  Created by Joe Peplowski on 2017-05-29.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import UIKit

class ComposeNoteViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    var noteModelController: NoteModelController!
    var composeMode: ComposeMode!
    var existingNote: NoteModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if composeMode == .edit,
            let existingNote = existingNote {
            textView.text = existingNote.text
            title = "Edit Note"
        } else {
            saveButton.isEnabled = false
            title = "Create Note"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveNote" else {
            return
        }
        
        switch composeMode! {
        case .create:
            let note = NoteModel(text: textView.text)
            noteModelController.add(note)
        case .edit:
            existingNote!.text = textView.text
            let existingNoteIndex = noteModelController.notes.index(of: existingNote!)!
            noteModelController.update(existingNoteIndex, newText: textView.text)
        }
    }
}

extension ComposeNoteViewController: UITextViewDelegate {
    
    // Disallow saving an empty note
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isEnabled = !textView.text.isEmpty
    }
    
}

enum ComposeMode {
    case create
    case edit
}
