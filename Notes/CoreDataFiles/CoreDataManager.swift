//
//  CoreDataManager.swift
//  Notes
//
//  Created by Ritik Sharma on 02/03/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager{
    static let shared = CoreDataManager()
    private let entityName = "MyNote"
    private var savedNotes:[Note] = [Note]()
    //MARK: Variables
    private var delegate:AppDelegate?
    private var persistentContainer:NSPersistentContainer?
    private var managedContext:NSManagedObjectContext?
    private init(){
        self.fetchPreRequisites()
        self.fetchCoreData()
    }
    
    //MARK: Core Data pre-requisites
    private func fetchPreRequisites(){
        print(#function)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        self.delegate = appDelegate
        self.persistentContainer = appDelegate.persistentContainer
        
        self.managedContext = self.persistentContainer!.viewContext
    }
    
    //MARK: Fetching Core Data
    private func fetchCoreData(){
        print(#function)
        self.savedNotes.removeAll()
        // main functioning
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        do{
            let result = try self.managedContext!.fetch(fetchRequest)
            for data in result as! [NSManagedObject]{
                let myNote = Note(title: data.value(forKey: "title") as? String, details: data.value(forKey: "details") as? String)
                self.savedNotes.append(myNote)
            }
        }
        catch{
            print(error)
        }
    }
    //MARK: Save Api Data
    func saveData(_ notes: NotesModel?){
        guard let notes = notes else {return}
        for note in (notes.notesData!){
            self.insertCoreData(title: note.title ?? "", details: note.details)
        }
    }
    //MARK: Get Saved Notes
    func getSavedNotes() -> [Note]{
        print(#function)
        return self.savedNotes
    }
    
    //MARK: Updating Core Data
    func updateCoreData(title:String,details:String?,ind: Int){
        print(#function)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.predicate = NSPredicate(format: "title == %@ ",self.savedNotes[ind].title!)
        do{
            let result = try self.managedContext!.fetch(fetchRequest)
            let data = result.first as! NSManagedObject
            data.setValue(title, forKey: "title")
            data.setValue(details ?? "", forKey: "details")
            try self.managedContext?.save()
            self.fetchCoreData()
        }
        catch{
            print(error)
        }
        
    }
    
    
    //MARK: Delete Core Data
    func deleteCoreData(myNote: Note?){
        guard let myNote = myNote else {return}
        print(#function)
        print("\(myNote.title! + " | " + myNote.details!)")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.predicate = NSPredicate(format: "title == %@",myNote.title!)
        do{
            let result = try self.managedContext!.fetch(fetchRequest)
            let data = result[0] as! NSManagedObject
            self.managedContext?.delete(data)
            try self.managedContext?.save()
            self.fetchCoreData()
        }
        catch{
            print(error)
        }
    }
    
    
    
    //MARK: Insert Core Data
    func insertCoreData(title: String,details: String?){
        print(#function)
        // get entity
        let userEntity = NSEntityDescription.entity(forEntityName: self.entityName, in: self.managedContext!)!
        
        // create an object in entity
        let obj = NSManagedObject(entity: userEntity, insertInto: self.managedContext!)
        obj.setValue(title, forKey: "title")
        obj.setValue(details ?? "", forKey: "details")
        // save changes
        do{
            try self.managedContext?.save()
            self.fetchCoreData()
        }
        catch{
            print(error)
        }
    }
    
}
