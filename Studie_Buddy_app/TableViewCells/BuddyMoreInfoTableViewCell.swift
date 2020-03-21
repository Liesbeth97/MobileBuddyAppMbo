//
//  BuddyMoreInfoTableViewCell.swift
//  Studie_Buddy_app
//
//  Created by Liesbeth on 03/01/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import UIKit

protocol BuddyMoreInfoCellDelegate {
    func clicked_less_info(student_number: Int)
    func clicked_choose_buddy(student_number: Int)
}

class BuddyMoreInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var img_profile_picture: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_study: UILabel!
    @IBOutlet weak var lbl_studyyear: UILabel!
    @IBOutlet weak var lbl_interests: UILabel!
    @IBOutlet weak var btn_less_info: UIButton!
    @IBOutlet weak var btn_choose_buddy: UIButton!
    let InhollandPink = UIColor(red: 235.0/255.0, green: 0.0/255.0, blue: 145.0/255.0, alpha: 1.0)
    
    var delegate: BuddyMoreInfoCellDelegate?
    var student_number: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btn_less_info.setTitle(NSLocalizedString("lessInfo", comment: ""), for: .normal)
        btn_choose_buddy.backgroundColor = InhollandPink
        btn_choose_buddy.tintColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btn_click_less_info(_ sender: Any) {
        delegate?.clicked_less_info(student_number: student_number!)
    }
    
    @IBAction func btn_click_choose_buddy(_ sender: Any) {
        delegate?.clicked_choose_buddy(student_number: student_number!)
    }
}
