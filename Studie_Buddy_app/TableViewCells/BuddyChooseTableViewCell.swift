//
//  BuddyChooseTableViewCell.swift
//  Studie_Buddy_app
//
//  Created by Liesbeth on 01/01/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import UIKit

protocol BuddyChooseCellDelegate {
    func clicked_more_info(buddy_info: String)
}

class BuddyChooseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_profiel_foto: UIImageView!
    @IBOutlet weak var lbl_buddy_info: UILabel!
    @IBOutlet weak var btn_meer_info: UIButton!
    
    var delegate: BuddyChooseCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
            //HeaderImage.image = ...
            // Initialization code
        
       /* img_profiel_foto.translatesAutoresizingMaskIntoConstraints = false
        img_profiel_foto.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        img_profiel_foto.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        img_profiel_foto.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        img_profiel_foto.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btn_click_more_info(_ sender: Any) {
        delegate?.clicked_more_info(buddy_info: "Test")
    }
}
