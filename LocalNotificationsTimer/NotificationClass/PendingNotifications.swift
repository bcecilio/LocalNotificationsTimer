//
//  PendingNotifications.swift
//  LocalNotificationsTimer
//
//  Created by Brendon Cecilio on 2/20/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import Foundation
import UserNotifications

class PendingNotification {
    public func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (request) in
            print("there are \(request.count) pending requests.")
            completion(request)
        }
    }
}
