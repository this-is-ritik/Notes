//
//  NotesViewModel.swift
//  Notes
//
//  Created by Ritik Sharma on 02/03/23.
//

import Foundation


class NotesViewModel{
    public var notes:NotesModel?
    
    private func storeInCoreData(){
        CoreDataManager.shared.saveData(self.notes)
    }
    public func fetchNotesFromApi(_ success:@escaping ()->()){
        guard let url = URL(string: NotesUrlBuilder.notesApiUrl) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request){
            data,response,error in
            if let data{
                do{
                    let model = try JSONDecoder().decode(NotesModel.self, from: data)
                    self.notes = model
                    DispatchQueue.main.async {
                        self.storeInCoreData()
                        success()
                    }
                }
                catch{
                    print(error)
                }
            }
        }.resume()
    }
    public func fetchNotesFromCoreData(){
        self.notes?.notesData = CoreDataManager.shared.getSavedNotes()
        self.notes?.notesCount = self.notes?.notesData?.count ?? 0
    }
}
