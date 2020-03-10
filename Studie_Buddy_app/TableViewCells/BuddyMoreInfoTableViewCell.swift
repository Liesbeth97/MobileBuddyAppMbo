//
//  BuddyMoreInfoTableViewCell.swift
//  Studie_Buddy_app
//
//  Created by Liesbeth on 03/01/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import UIKit

protocol BuddyMoreInfoCellDelegate {
    func clicked_less_info(buddy_info: String)
    func clicked_choose_buddy(buddy_info: String)
}

class BuddyMoreInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var img_profiel_foto: UIImageView!
    @IBOutlet weak var lbl_buddy_info: UILabel!
    @IBOutlet weak var btn_minder_info: UIButton!
    @IBOutlet weak var btn_kies_buddy: UIButton!
    let InhollandPink = UIColor(red: 235.0/255.0, green: 0.0/255.0, blue: 145.0/255.0, alpha: 1.0)
    
    var delegate: BuddyMoreInfoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btn_kies_buddy.backgroundColor = InhollandPink
        btn_kies_buddy.tintColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btn_click_less_info(_ sender: Any) {
        delegate?.clicked_less_info(buddy_info: "Test")
    }
    
    @IBAction func btn_click_choose_buddy(_ sender: Any) {
        delegate?.clicked_choose_buddy(buddy_id: 5, buddy_name: "Test")
    }
}
