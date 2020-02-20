//
//  CreateTimerController.swift
//  LocalNotificationsTimer
//
//  Created by Brendon Cecilio on 2/20/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import UIKit

class CreateTimerController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var hour:Int = 0
    var minutes:Int = 0
    var seconds:Int = 0
    private var timeInterval: TimeInterval = Date().timeIntervalSinceNow + 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func createLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = textField.text ?? "No Title"
        content.body = "Local Notifications is awesome when used appropriatly"
        content.subtitle = "Learning Locan Notifications"
        content.sound = .default // only works in the background and hte app is not on silent - please test on device
        // TODO: you can also import your own audio file
        
        // TODO: userInfo dictionary can hold additional data
        // content.userinfo =
        
        // create identifier
        let identifier = UUID().uuidString // unique string
        
        // attachment
        if let imageURL = Bundle.main.url(forResource: "demonBread", withExtension: "jpg"){
            do {
                let attachment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
                content.attachments = [attachment]
            } catch {
                print("error with attachment: \(error)")
            }
        } else {
            print("image resource could not be found")
        }
        // create a request
        // 3 possible triggers for local notifcations: time interval, calender, location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // add request to the UNNotificationCenter
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("error adding request: \(error)")
            } else {
                print("request was successfully added")
            }
        }
    }
    
    @IBAction func pickerViewChanged(_ sender: UIPickerView) {
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
    }
}

extension CreateTimerController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1, 2:
            return 60
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width / 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) Hr"
        case 1:
            return "\(row) Min"
        case 2:
            return "\(row) Sec"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = row
        case 1:
            minutes = row
        case 2:
            seconds = row
        default:
            break;
        }
    }
}
