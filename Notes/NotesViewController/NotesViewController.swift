//
//  NotesViewController.swift
//  Notes
//
//  Created by Vasilis Sakkas on 28/03/2019.
//  Copyright © 2019 Vasilis Sakkas. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    private var note : Note?
    
    init(note: Note?) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        backButtonPressed()
    }
    
    override func loadView() {
        self.view = NotesView(note: note)
    }
    
    private func updateNavBar() {
        title = (note != nil ? note!.title : "New note")
    }
    
    private func backButtonPressed() {
        let notesView = view as! NotesView
        if notesView.textView.text.isEmpty {
            if note != nil {
                // TextView was empty and we were editing an existing note, so the note must be deleted.
                NoteCoreDataController.deleteData(note: note!)
            }
            // In case we weren't been editing a note, we don't have to do anything other than returning to the notes TableView.
        } else {
            if note != nil {
                // The TextView wasn't empty and we were editing an existing note, so the note must be updated.
                NoteCoreDataController.updateData(title: notesView.textView.text, text: notesView.textView.text, id: note!.id!)
            } else {
                // The TextView wasn't empty and we were creating a new note, so the note must be saved.
                NoteCoreDataController.createData(title: notesView.textView.text, text: notesView.textView.text, created_at: nil, last_update: nil)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
