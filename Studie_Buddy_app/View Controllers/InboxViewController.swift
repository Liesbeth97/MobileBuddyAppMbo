//
//  MessagesViewController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 05/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Alamofire
import SwiftKeychainWrapper


var tutoranten: [Tutorants] = []
var tutorantenProfiles: [Student] = []
var coachConnection: Tutorants = nil
var coachProfile: Student? = nil
var LatestMessage: String = ""
var latestMessageDate: String = "2000-01-01T00:00:00+0000"
var totalNewMessages = 0

class inboxviewcontroller: UIViewController {
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var InboxTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.InboxTableView.dataSource = self
        self.InboxTableView.delegate = self
        self.InboxTableView.register(UINib(nibName: "InboxTableViewCell", bundle: nil), forCellReuseIdentifier: "InboxTableViewCell")
        
        NavigationBar.title = NSLocalizedString("inbox", comment: "")
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        if LoggedInStudent?.hbo_mbo == "hbo"    { loadnewtutorants()    }
        else                                    { loadCoach()           }
        CheckLatestMessage()
        
        InboxTableView.separatorStyle = .none
        //MakeApiCall()
        //InboxTableView.reloadData()
        // _ = Timer.scheduledTimer(timeInterval: 5.0,target: self,selector: #selector(execute),userInfo: nil,repeats: true)
    }
    
    func loadCoach(){
        let coachID = 0
        ApiManager.getCoach(studentIDTutorant: LoggedInStudent?.studentid).responseData(completionHandler: { [weak self] (response) in
            let jsonData = response.data!
            let decoder = JSONDecoder()
            Studentprofile = try? decoder.decode(Student.self, from: jsonData)
            coachID = Studentprofile?.studentid
        })
        ApiManager.getProfile(coachID).responseData(completionHandler: { [weak self] (response) in
            let jsonData = response.data!
            let decoder = JSONDecoder()
            Studentprofile = try? decoder.decode(Student.self, from: jsonData)
            coachProfile = Studentprofile
        })
        self?.InboxTableView.reloadData()
    }
    
    func loadnewtutorants(){
        tutorantenProfiles = []
        var indexnumber = 0
        ApiManager.getTutors(studentID: LoggedInStudent?.studentid).responseData(completionHandler: { [weak self] (response) in
            let jsonData = response.data!
            let decoder = JSONDecoder()
            let tutorants = try? decoder.decode([Tutorants].self, from: jsonData)
            if tutorants != nil {
                for item in tutorants!{
                    tutoranten.append(item)
                    print(item.tutorantid)
                }
                for i in 0...tutoranten.count - 1  {
                    
                    
                    ApiManager.getProfile(studentID: tutoranten[i].tutorantid).responseData(completionHandler: { [weak self] (response) in
                        let jsonData = response.data!
                        let decoder = JSONDecoder()
                        Studentprofile = try? decoder.decode(Student.self, from: jsonData)
                        // print(Studentprofile!.firstname)
                        if indexnumber < UserDefaults.standard.integer(forKey: "NumberOfTutoranten") || UserDefaults.standard.integer(forKey: "NumberOfTutoranten") == 0 {
                            tutorantenProfiles.insert(Studentprofile!, at: indexnumber)
                            indexnumber = indexnumber + 1
                        }
                        //print("count is:",tutorantenProfiles.count)
                        self!.InboxTableView.reloadData()
                        UserDefaults.standard.set(tutorantenProfiles.count, forKey: "NumberOfTutoranten")
                    })
                    
                }
                self?.InboxTableView.reloadData()
                
            }
        })
        
    }
    
    func CheckLatestMessage(){
        ApiManager.getMessages(senderID: 710 , receiverID: 701).responseData(completionHandler: { [weak self] (responseReceiver) in
            let jsonData = responseReceiver.data!
            let decoder = JSONDecoder()
            let NewMessagesReceiver = try? decoder.decode([Messages].self, from: jsonData)
            ApiManager.getMessages(senderID: 701 , receiverID: 710).responseData(completionHandler: { [weak self] (responseSender) in
                let jsonData = responseSender.data!
                let decoder = JSONDecoder()
                let NewMessagesSender = try? decoder.decode([Messages].self, from: jsonData)
                let size1 = NewMessagesSender!.count - 1
                let size2 = NewMessagesReceiver!.count - 1
                totalNewMessages = (NewMessagesReceiver!.count + NewMessagesSender!.count)
                if NewMessagesSender![size1].messageid < NewMessagesReceiver![size2].messageid {
                    LatestMessage = NewMessagesReceiver![size2].payload
                    latestMessageDate = NewMessagesReceiver![size2].created
                }else
                {
                    LatestMessage = NewMessagesSender![size1].payload
                    latestMessageDate = NewMessagesSender![size1].created
                    
                }
                self?.InboxTableView.reloadData()
            })
        })
        
    }
    
}

extension inboxviewcontroller: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if LoggedInStudent?.hbo_mbo == "hbo"{
            print(tutorantenProfiles.count)
            return  tutorantenProfiles.count
        }
        else {  return 1    }   //Coach chat
        // +1 for the groupschat
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "messagesviewcontroller") as! messagesviewcontroller
        if LoggedInStudent?.hbo_mbo == "hbo" { vc.ChatName = tutorantenProfiles[indexPath.row].firstname }
        else                                 { vc.ChatName = coachProfile?.firstname }
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxTableViewCell",
                                                 for: indexPath) as! InboxTableViewCell
        cell.InboxProfileImage.image = UIImage(named: "Profile")
        print("tutoranten profiles count is :", tutorantenProfiles.count)
        if tutorantenProfiles.count != 0 {
            cell.InboxChatName.text = tutorantenProfiles[indexPath.row].firstname
        }
        
        /*let dateFormatter = DateFormatter()
         dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
         dateFormatter.dateFormat = "HH:mm"
         let MessDate = dateFormatter.date(from:latestMessageDate)
         */
        let date = latestMessageDate.prefix(10)
        cell.InboxDateLabel.text = String(date)
        
        let NumberOfMessages = UserDefaults.standard.integer(forKey: "MessageAmount")
        if NumberOfMessages < totalNewMessages{
            cell.UnreadMessages = false
        }
        else{
            cell.UnreadMessages = true
        }
        let message = LatestMessage
        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
        let newMessage = trimmed.data(using: .utf8)
        cell.InboxLatestChat.text = String(data: newMessage!, encoding: .nonLossyASCII)
        
        
        return cell
    }
    
    
    
    
}



