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
    
    private var timers = [UNNotificationRequest]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let pendingNotification = PendingNotification()
    private var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        configureRefreshControl()
        notificationCenter.delegate = self
        checkForNotificationAuthorization()
        loadNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController, let createVC = navController.viewControllers.first as? CreateTimerController else {
            fatalError("could not downcast to CreateTimerController")
        }
        createVC.delegate = self
    }
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadNotifications), for: .valueChanged)
        loadNotifications()
    }
    
    @objc private func loadNotifications() {
        pendingNotification.getPendingNotifications { (request) in
            self.timers = request
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func checkForNotificationAuthorization() {
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("app is authorized for notifications")
            } else {
                self.requestNotificationPermissions()
            }
        }
    }
    
    private func requestNotificationPermissions() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("error requesting athorization: \(error)")
                return
            }
            if granted {
                print("access was granted")
            } else {
                print("access denied")
            }
        }
    }
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath)
        let timerCell = timers[indexPath.row]
        cell.textLabel?.text = timerCell.content.title
        cell.detailTextLabel?.text = timerCell.content.body
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTimer(atIndexPath: indexPath)
        }
    }
    private func deleteTimer(atIndexPath indexPath: IndexPath) {
        let notification = timers[indexPath.row]
        let identifier = notification.identifier
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        timers.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension NotificationsViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

extension NotificationsViewController: CreateTimerControllerDelegate {
    func didCreateNotification(_ createTimerController: CreateTimerController) {
        loadNotifications()
    }
}
