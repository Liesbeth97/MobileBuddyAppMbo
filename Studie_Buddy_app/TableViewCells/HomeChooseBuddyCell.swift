//
//  HomeChooseBuddyCell.swift
//  Studie_Buddy_app
//
//  Created by Informatica Haarlem on 22-03-20.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import UIKit

protocol HomeBuddyChooseCellDelegate {
    func clicked_start_match()
}

class HomeChooseBuddyCell: UITableViewCell {

    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var img_settings_icon: UIImageView!
    @IBOutlet weak var btn_choose_buddy: UIButton!
    
    var delegate: HomeBuddyChooseCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        lbl_description.text = NSLocalizedString("clickChooseBuddyDescription", comment: "")
        lbl_date.text = result
        img_settings_icon.image = #imageLiteral(resourceName: "settings_icon")
        btn_choose_buddy.setTitle(NSLocalizedString("clickChooseBuddy", comment: ""), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clicked_choose_buddy(_ sender: Any)
    {
        print("button clicked choose buddy")
        delegate?.clicked_start_match()
    }
}
