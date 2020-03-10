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

class ChooseBuddyViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ChooseBuddyTableView: UITableView!
    var arrayOfBuddies = [Student]()
    @IBOutlet weak var LoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var NavigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ChooseBuddyTableView.dataSource = self
        self.ChooseBuddyTableView.register(UINib(nibName: "ChooseBuddyTableViewCell", bundle: nil), forCellReuseIdentifier: "ChooseBuddyTableViewCell")
    NavigationBar.title = NSLocalizedString("chooseBuddy", comment: "")
    self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        
        ChooseBuddyTableView.separatorStyle = .none
        LoadingIndicator.startAnimating()
        LoadingIndicator.isHidden = false
        
        ChooseBuddyTableView.reloadData()
        _ = Timer.scheduledTimer(timeInterval: 5.0,target: self,selector: #selector(execute),userInfo: nil,repeats: true)
    }
    
    @objc func execute() {
        ApiManager.getAllCoachProfiles().responseData(completionHandler: { [weak self] (response) in
            let jsonData = response.data!
            let decoder = JSONDecoder()
            let NewBuddyList = try? decoder.decode([Student].self, from: jsonData)
            if NewBuddyList != nil {
                self?.arrayOfBuddies = [] //
                for item in NewBuddyList!{
                    self?.arrayOfBuddies.append(item)
                }
                self!.LoadingIndicator.stopAnimating()
                self!.LoadingIndicator.isHidden = true
                self!.ChooseBuddyTableView.reloadData()
                
                let lastRow: Int = self!.ChooseBuddyTableView.numberOfRows(inSection: 0) - 1
                self!.ChooseBuddyTableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: false)
            }
        })
    }
}

extension ChooseBuddyViewController: AppDelegate, SceneDelegate, UITableViewDelegate, UITableViewDataSource{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfBuddies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*if(arrayOfBuddies[indexPath.row].cell == 1){
            let cell = Bundle.main.loadNibNamed("BuddyChooseTableViewCell", owner: self, options: nil)?.first as! BuddyChooseTableViewCell
            cell.img_profiel_foto.image = arrayOfBuddies[indexPath.row].image
            cell.lbl_buddy_info.text = arrayOfBuddies[indexPath.row].text
            cell.delegate=self
            return cell
        }
        else if(arrayOfBuddies[indexPath.row].cell == 2){
            let cell = Bundle.main.loadNibNamed("BuddyMoreInfoTableViewCell", owner: self, options: nil)?.first as! BuddyMoreInfoTableViewCell
            cell.img_profiel_foto.image = arrayOfBuddies[indexPath.row].image
            cell.lbl_buddy_info.text = arrayOfBuddies[indexPath.row].text
            cell.delegate=self
            return cell
        }
        else {*/
            let cell = Bundle.main.loadNibNamed("BuddyChooseTableViewCell", owner: self, options: nil)?.first as! BuddyChooseTableViewCell
            cell.img_profiel_foto.image = nil //arrayOfBuddies[indexPath.row].image
            cell.lbl_buddy_info.text = "test" //arrayOfBuddies[indexPath.row].text
            cell.delegate=self
            return cell
        //}
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*if(arrayOfBuddies[indexPath.row].cell == 1){
            return 130
        }
        else if(arrayOfBuddies[indexPath.row].cell == 2){
            return 180
        }
        else {*/
            return 130
        //}
    }
}

extension ChooseBuddyViewController: BuddyChooseCellDelegate, BuddyMoreInfoCellDelegate{
    func clicked_more_info(buddy_info: String){
        
    }
    func clicked_less_info(buddy_info: String){
        
    }
    func clicked_choose_buddy(buddy_id: Int, buddy_naam: String){
        //alert bevestiging
        let alert_title = "Bevestiging"
        let alert_message = "Weet je zeker dat je \(buddy_naam) als buddy wilt?"
        let alert = UIAlertController(title: alert_title, message: alert_message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Nee", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        //API call om de studenten te koppelen
        let coachID = buddy_id
        let tutorantID = KeychainWrapper.standard.string(forKey: "StudentID")
        ApiManager.MakeCoachTutorantMatch(coachID, TutorantID)
        
        //alert nieuwe buddy
        alert_title = "Nieuwe buddy!"
        alert_message = "\(buddy_naam) is je niewe buddy"
        alert = UIAlertController(title: alert_title, message: alert_message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        //ga naar home
        //...
    }
}
