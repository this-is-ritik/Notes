//
//  EditNote.swift
//  Notes
//
//  Created by Ritik Sharma on 10/01/23.
//

import SwiftUI


class NoteData: ObservableObject{
    var title:String = ""{
        didSet{
            self.objectWillChange.send()
        }
    }
    var titleBinding: Binding<String>{
        return Binding<String>(
            get:{
                return self.title
            },
            set:{
                self.title = $0
            }
        )
    }
    var detail:String = ""{
        didSet{
            self.objectWillChange.send()
        }
    }
    var detailBinding: Binding<String>{
        return Binding<String>(
            get:{
                return self.detail
            },
            set:{
                self.detail = $0
            }
        )
    }
}

struct EditNote: View {
    var index:Int = 0
    @State private var showingAlert = false
    var myNote: NoteData = NoteData()
    var body: some View {
        NavigationView{
            GeometryReader{
                geometry in
                Form{
                    TextEditor(text: self.myNote.titleBinding)
                        .lineLimit(1)
                        .disableAutocorrection(true)
                    TextEditor(text: self.myNote.detailBinding)
                        .disableAutocorrection(true)
                        .padding(.horizontal)
                        .frame(height: geometry.size.height)
                }
                .frame(width: geometry.size.width,height: geometry.size.height)
            }
        }
        .navigationTitle(Text("Edit Note"))
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    self.showingAlert = true
                }, label: {
                    Text("Save")
                        .foregroundColor(.black)
                })
                .alert(isPresented: $showingAlert){
                    let saveBtn = Alert.Button.default(Text("Save")){
                        CoreDataManager.shared.updateCoreData(title: self.myNote.titleBinding.wrappedValue, details: self.myNote.detailBinding.wrappedValue, ind: self.index)
                        self.showingAlert = false
                    }
                    let cancelBtn = Alert.Button.default(Text("Cancel")){
                        self.showingAlert = false
                    }
                    return Alert(title: Text("Save Changes?"), primaryButton: saveBtn, secondaryButton: cancelBtn)
                }
            }
        }
    }
}

struct EditNote_Previews: PreviewProvider {
    static var previews: some View {
        EditNote()
    }
}
