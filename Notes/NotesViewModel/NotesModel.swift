//
//  NotesModel.swift
//  Notes
//
//  Created by Ritik Sharma on 02/03/23.
//

import Foundation

class Note:Codable{
    var title:String?
    var details:String?
    init(title: String?, details: String?) {
        self.title = title
        self.details = details
    }
}

class NotesModel:Codable{
    var notesCount:Int?
    var notesData:[Note]?
    
    
}
