//
//  BuddyChooseTableViewCell.swift
//  Studie_Buddy_app
//
//  Created by Liesbeth on 01/01/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import UIKit

protocol BuddyChooseCellDelegate {
    func clicked_more_info(buddy_name: String)
}

class BuddyChooseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_profile_picture: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_interests: UILabel!
    @IBOutlet weak var btn_more_info: UIButton!
    
    var delegate: BuddyChooseCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn_more_info.setTitle(NSLocalizedString("moreInfo", comment: ""), for: .normal)
        
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
        let name = lbl_name.text!
        delegate?.clicked_more_info(buddy_name: name)
    }
}
