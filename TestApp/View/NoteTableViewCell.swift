//
//  NoteTableViewCell.swift
//  TestApp
//
//  Created by Joe Peplowski on 2017-05-29.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var model: Model? {
        didSet {
            guard let model = model else {
                return
            }
            noteTextLabel.text = model.text
            dateLabel.text = model.dateCreatedString
        }
    }
    
}

extension NoteTableViewCell {
    
    struct Model {
        let text, dateCreatedString: String
        
        init(note: NoteModel) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: note.dateCreated)
            
            self.text = note.text
            self.dateCreatedString = dateString
        }
    }
    
}
