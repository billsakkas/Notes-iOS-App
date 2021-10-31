//
//  ViewController.swift
//  Notes
//
//  Created by Vasilis Sakkas on 27/03/2019.
//  Copyright © 2019 Vasilis Sakkas. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {
    
    var notes: [Note] = []
    var toolbarStatusLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.reuse_id)
        tableView.rowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notes = NoteCoreDataController.retrieveData()!
        notes.sort { $0.title! < $1.title! }
        toolbarStatusLabel.text = notes.count > 0 ? "\(notes.count) Notes" : ""
        tableView.reloadData()
    }
    
    private func setNavigationController() {
        // Add UIToolBar to the View.
        let toolbarStatusLabelButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        toolbarStatusLabelButton.customView = toolbarStatusLabel
        toolbarStatusLabelButton.isEnabled = false
        navigationController?.setToolbarHidden(false, animated: false)
        setToolbarItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            toolbarStatusLabelButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            ], animated: false)
        
        // Add buttons to NavBar.
        let navBar = navigationController?.navigationBar
        navBar?.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(deleteNotesMode))
        navBar?.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newNote))
        navBar?.topItem?.title = "Personal notes"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.reuse_id) as! NotesTableViewCell
        cell.note = notes[indexPath.row]
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(NotesViewController(note: notes[indexPath.row]), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(at: indexPath)
        }
    }
    
    private func deleteNote(at indexPath: IndexPath) {
        let note = notes.remove(at: indexPath.row)
        NoteCoreDataController.deleteData(note: note)
        tableView.deleteRows(at: [indexPath], with: .left)
        toolbarStatusLabel.text = notes.count > 0 ? "\(notes.count) notes" : ""
    }
    
    @objc private func newNote(sender: UIButton) {
        navigationController?.pushViewController(NotesViewController(note: nil), animated: true)
    }
    
    @objc private func doneDeletingNotes() {
        let navBar = navigationController?.navigationBar
        navBar?.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(deleteNotesMode))
        tableView.setEditing(false, animated: true)
    }
    
    @objc private func deleteNotesMode(sender: UIButton) {
        let navBar = navigationController?.navigationBar
        navBar?.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDeletingNotes))
        tableView.setEditing(true, animated: true)
    }

}

