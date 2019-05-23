//
//  UIViewController.swift
//  Notes
//
//  Created by Vasilis Sakkas on 03/04/2019.
//  Copyright © 2019 Vasilis Sakkas. All rights reserved.
//

import UIKit
import CoreData

class NoteCoreDataController: NoteCoreDataDelegate {
    
    static var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static func retrieveData() -> [Note]? {
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            let res = try managedContext.fetch(Note.fetchRequest()) as! [Note]
            return res
        } catch  {
            print("Fail")
            return nil
        }
    }
    
    static func createData(title: String, text: String, created_at: Date?, last_update: Date?) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let newNote = Note(context: managedContext)
        newNote.setData(title: title, text: text, created_at: created_at, id: nil)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func updateData(title: String, text: String, id: UUID) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = Note.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        do {
            let res = try managedContext.fetch(fetchReq)
            let note = res[0] as! Note
            note.setData(title: title, text: text, created_at: note.created_at! as Date, id: id)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
    }
    
    static func deleteData(note: Note) {
        let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(note)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
    }
}
