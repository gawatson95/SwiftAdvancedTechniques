//
//  CloudKitPushNotification.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Grant Watson on 8/4/22.
//

import SwiftUI
import CloudKit

class CloudKitPushNotificationVM: ObservableObject {
    
    func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error)
            } else if success {
                print("Notification permissions success")
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permissions failure")
            }
        }
        
    }
    
    func subscribeToNotifications() {
        
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "Fruits", predicate: predicate, subscriptionID: "fruit_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "There is a new fruit!"
        notification.alertBody = "Open the app to check new fruits"
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription) { subscription, error in
            if let error = error {
                print(error)
            } else {
                print("Successfully subscribed to notifications.")
            }
        }
    }
    
    func unsubscribeToNotifications() {
        
//        CKContainer.default().publicCloudDatabase.fetchAllSubscriptions(completionHandler: T##([CKSubscription]?, Error?) -> Void)
        
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "fruit_added_to_database") { returnedID, error in
            if let error = error {
                print(error)
            } else {
                print("Successfully unsubscribed to notifications.")
            }
        }
    }
}

struct CloudKitPushNotification: View {
    
    @StateObject private var vm = CloudKitPushNotificationVM()
    
    var body: some View {
        VStack(spacing: 40) {
            Button("Request notification permissions") {
                vm.requestNotificationPermissions()
            }
            
            Button("Subscribe to notifications") {
                vm.subscribeToNotifications()
            }
            
            Button("Unsubscribe to notifications") {
                vm.unsubscribeToNotifications()
            }
        }
    }
}

struct CloudKitPushNotification_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitPushNotification()
    }
}
