//
//  ViewController.swift
//  Notes
//
//  Created by Ritik Sharma on 09/01/23.
//

import UIKit
import SwiftUI
class ViewController: UIViewController {

    
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Private Variables
    
    private let viewModel:NotesViewModel = NotesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Notes"
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorColor = .black
        self.updateNavigationBar()
        let nib = UINib(nibName: MyNoteTableViewCell.reuseIdentifier, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: MyNoteTableViewCell.reuseIdentifier)
        tableView.backgroundColor = UIColor(red: 0.89, green: 0.97, blue: 0.99, alpha: 1.00)
        self.view.backgroundColor = UIColor(red: 0.89, green: 0.97, blue: 0.99, alpha: 1.00)
        self.viewModel.fetchNotesFromApi(){
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func updateNavigationBar(){
        let rightBarBtnItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        rightBarBtnItem.tintColor = .magenta
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
    }
    @objc func addNote(){
        
        let ac = UIAlertController(title: "Enter Note", message: nil, preferredStyle: .alert)
        ac.addTextField{
            textField in
            textField.placeholder = "Title"
        }
        ac.addTextField{
            textField in
            textField.placeholder = "Description"
        }
        
        let continueAction = UIAlertAction(title: "Add Note", style: .default){
            [weak ac] _ in
            guard let textFields = ac?.textFields else {return}
            
            CoreDataManager.shared.insertCoreData(title: textFields.first?.text ?? "", details: textFields.last?.text)
            self.viewModel.fetchNotesFromCoreData()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        ac.addAction(cancelAction)
        ac.addAction(continueAction)
        present(ac, animated: true)
        
    }
    
    
    @IBAction func saveNotes(_ sender: Any) {
        
        
    }
    
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextualAction = UIContextualAction(style: .normal, title: "Delete"){_,view,_ in
            let ac = UIAlertController(title: "Delete Note?", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "cancel", style: .default){
                _ in
            })
            ac.addAction(UIAlertAction(title: "delete", style: .destructive){_ in
                CoreDataManager.shared.deleteCoreData(myNote: self.viewModel.notes?.notesData?[indexPath.row])
                self.viewModel.fetchNotesFromCoreData() //CoreData
                self.tableView.reloadData()
            })
            self.present(ac, animated: true)
            
            
        }
        contextualAction.backgroundColor = UIColor(red: 0.62, green: 0.83, blue: 0.96, alpha: 1.00)
        let gesture = UISwipeActionsConfiguration(actions: [contextualAction])
        return gesture
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextualAction = UIContextualAction(style: .normal, title: "Update"){_,view,_ in
            let ac = UIAlertController(title: "Enter Note", message: nil, preferredStyle: .alert)
            ac.addTextField{
                textField in
                textField.placeholder = "Title"
            }
            ac.addTextField{
                textField in
                textField.placeholder = "Description"
            }
            
            let continueAction = UIAlertAction(title: "Update Note", style: .default){
                [weak ac] _ in
                guard let textFields = ac?.textFields else {return}
                CoreDataManager.shared.updateCoreData(title: textFields.first?.text ?? "tempTitle\(indexPath.row)", details: textFields.last?.text, ind: indexPath.row)
                self.viewModel.fetchNotesFromCoreData() // CoreData
                self.tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            ac.addAction(cancelAction)
            ac.addAction(continueAction)
            self.present(ac, animated: true)
            
        }
        contextualAction.backgroundColor = UIColor(red: 0.62, green: 0.83, blue: 0.96, alpha: 1.00)
        let gesture = UISwipeActionsConfiguration(actions: [contextualAction])
        return gesture
    }
}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.notes?.notesCount ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MyNoteTableViewCell.reuseIdentifier, for: indexPath) as? MyNoteTableViewCell{
            cell.configure(myNote: self.viewModel.notes?.notesData?[indexPath.row] ?? Note(title: nil, details: nil))
            cell.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 0.99, alpha: 1.00)
            cell.layer.cornerRadius = 8
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteData = NoteData()
        noteData.title = self.viewModel.notes?.notesData?[indexPath.row].title ?? ""
        noteData.detail = self.viewModel.notes?.notesData?[indexPath.row].details ?? ""
        var vc = EditNote()
        vc.myNote = noteData
        vc.index = indexPath.row
        let rootVc = UIHostingController(rootView: vc)
        self.navigationController?.pushViewController(rootVc, animated: true)
    }
}
