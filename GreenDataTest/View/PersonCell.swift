//
//  PersonCell.swift
//  GreenDataTest
//
//  Created by yaruncle on 06.11.2020.
//  Copyright © 2020 yaruncle. All rights reserved.
//

import UIKit
import Nuke

// View для ячейки
class PersonCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var personImage: UIImageView!
    
    var items:[EPerson]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(user : EPerson) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        // Reset Profile picture (Prevent showing up prev profile image when loading)
        self.personImage.image = UIImage(named: "image_person")
        
        // Make profile picture circle
        self.personImage.layer.cornerRadius = self.personImage.frame.width / 2.0
        self.personImage.layer.masksToBounds = true
        
        // Set text data
        self.titleLabel.text = "\(user.firstName!.makeFirstCharUpper()) \(user.lastName!.makeFirstCharUpper())"
        
        // And set image
        Nuke.loadImage(with: user.imageURL!, into: self.personImage)        
    }
}
