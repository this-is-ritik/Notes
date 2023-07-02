//
//  MyNoteTableViewCell.swift
//  Notes
//
//  Created by Ritik Sharma on 09/01/23.
//

import UIKit

class MyNoteTableViewCell: UITableViewCell {

    
    
    
    static let reuseIdentifier = "MyNoteTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var detailLabel: UILabel!
    
    
    
    
    var notes:Note?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.detailLabel.layer.cornerRadius = 8
        self.titleLabel.layer.cornerRadius = 8
        self.detailLabel.textColor = .black
        self.titleLabel.textColor = .black
        self.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 0.99, alpha: 1.00)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateCell()
    }
    
    override func prepareForReuse() {
        self.updateCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    func configure(myNote: Note){
        self.notes = myNote
    }
    private func updateCell(){
//        print(#function)
//        print(self.notes?.title)
//        print(self.notes?.detail)
        self.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 0.99, alpha: 1.00)
        if let notes = self.notes {
            self.titleLabel.text = notes.title
            self.detailLabel.text = notes.details
        }
    }
}
