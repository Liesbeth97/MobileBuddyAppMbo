//
//  ChooseBuddyViewController.swift
//  Studie_Buddy_app
//
//  Created by Liesbeth on 01/01/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import Alamofire
import SwiftKeychainWrapper

class ChooseBuddyViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var ChooseBuddyTableView: UITableView!
    @IBOutlet weak var LoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var NavigationBar: UINavigationItem!
    
    var arrayOfBuddies = [Student]()
    let moreInfo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ChooseBuddyTableView.dataSource = self
        self.ChooseBuddyTableView.register(UINib(nibName: "BuddyChooseTableViewCell",   bundle: nil), forCellReuseIdentifier: "BuddyChooseTableViewCell")
        self.ChooseBuddyTableView.register(UINib(nibName: "BuddyMoreInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "BuddyMoreInfoTableViewCell")
        ChooseBuddyTableView.separatorStyle = .none
        
        NavigationBar.title = NSLocalizedString("chooseBuddyHeader", comment: "")
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        
        LoadingIndicator.startAnimating()
        LoadingIndicator.isHidden = false
        
        ChooseBuddyTableView.reloadData()
        _ = Timer.scheduledTimer(timeInterval: 5.0,target: self,selector: #selector(execute),userInfo: nil,repeats: true)
    }
    
    @objc func execute()
    {
        ApiManager.getAllCoachProfiles().responseData(completionHandler: { [weak self] (response) in
            let jsonData = response.data!
            let decoder = JSONDecoder()
            let NewBuddyList = try? decoder.decode([Student].self, from: jsonData)
            if NewBuddyList != nil
            {
                self?.arrayOfBuddies = [] //
                for item in NewBuddyList!
                {
                    self?.arrayOfBuddies.append(item)
                }
                self!.LoadingIndicator.stopAnimating()
                self!.LoadingIndicator.isHidden = true
                self!.ChooseBuddyTableView.reloadData()
                
                let lastRow: Int = self!.ChooseBuddyTableView.numberOfRows(inSection: 0) - 1
                self!.ChooseBuddyTableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: false)
            }
            self.ChooseBuddyTableView.reloadData()
        })
    }
}

extension ChooseBuddyViewController//: UITableViewDelegate, UITableViewDataSource
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfBuddies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let buddy = arrayOfBuddies[indexPath.row]
        if(buddy.more_info == true)
        {
            let cell_more_info = tableView.dequeueReusableCell(withIdentifier: "BuddyMoreInfoTableViewCell", for: indexPath) as! BuddyMoreInfoTableViewCell
            cell_more_info.lbl_name.text = String(format: NSLocalizedString("name", comment: ""), buddy.firstname, buddy.surname)
            cell_more_info.lbl_studyyear.text = String(format: NSLocalizedString("studyyear", comment: ""), buddy.studyyear)
            cell_more_info.lbl_study.text = String(format: NSLocalizedString("study", comment: ""), buddy.study)
            cell_more_info.lbl_interests.text = String(format: NSLocalizedString("bio", comment: ""), buddy.interests)
            cell_more_info.img_profile_picture.image = buddy.photo
            cell_more_info.student_number = buddy.studentid
            cell_more_info.delegate=self
            return cell_more_info
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BuddyChooseTableViewCell", for: indexPath) as! BuddyChooseTableViewCell
            cell.lbl_name.text = String(format: NSLocalizedString("name", comment: ""), buddy.firstname, buddy.surname)
            cell.lbl_studyyear.text = String(format: NSLocalizedString("studyyear", comment: ""), buddy.studyyear)
            cell.lbl_study.text = String(format: NSLocalizedString("study", comment: ""), buddy.study)
            cell.img_profile_picture.image = buddy.photo
            cell.student_number = buddy.studentid
            cell.delegate=self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let buddy = arrayOfBuddies[indexPath.row]
        if(buddy.more_info == true){ return 180 }
        else                       { return 100 }
    }
}

extension ChooseBuddyViewController: BuddyChooseCellDelegate, BuddyMoreInfoCellDelegate
{
    func clicked_more_info(student_number: Int)
    {
        for i in 0..<arrayOfBuddies.count
        {
            if (arrayOfBuddies[i].studentid == student_number)
            {
                arrayOfBuddies[i].more_info = true
            }
        }
        ChooseBuddyTableView.reloadData()
    }
    func clicked_less_info(student_number: Int){
        for i in 0..<arrayOfBuddies.count
        {
            if (arrayOfBuddies[i].studentid == student_number)
            {
                arrayOfBuddies[i].more_info = false
            }
        }
        ChooseBuddyTableView.reloadData()
    }
    
    
    func clicked_choose_buddy(student_number: Int){
        //get buddy name
        var buddy_name = ""
        for i in 0..<arrayOfBuddies.count
        {
            if (arrayOfBuddies[i].studentid == student_number)
            {
                buddy_name = arrayOfBuddies[i].firstname
            }
        }
        
        //alert confirmation
        var alert_title = NSLocalizedString("confirmation", comment: "")
        var alert_message = String(format: NSLocalizedString("confirmationMsg", comment: ""), buddy_name)
        var alert = UIAlertController(title: alert_title, message: alert_message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        //API call om de studenten te koppelen
        var coachID = student_number
        var tutorantID = KeychainWrapper.standard.string(forKey: "StudentID")
        ApiManager.MakeCoachTutorantMatch(studentIDCoach: coachID, studentIDTutorant: tutorantID)
        
        //alert nieuwe buddy
        alert_title = NSLocalizedString("newBuddyTitle", comment: "")
        alert_message = String(format: NSLocalizedString("newBuddyMsg", comment: ""), buddy_name)
        alert = UIAlertController(title: alert_title, message: alert_message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("oke", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        //ga naar home
        //...
    }
}
