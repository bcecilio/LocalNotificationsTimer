//
//  ViewController.swift
//  LocalNotificationsTimer
//
//  Created by Brendon Cecilio on 2/20/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var notifications = [UNNotificationRequest]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let pendingNOtification = PendingNotification()
    private var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

