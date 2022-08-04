//
//  CloudKitUserBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Grant Watson on 8/4/22.
//

import SwiftUI
//import CloudKit
import Combine

class CloudKitUserBootcampVM: ObservableObject {
    
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var username: String = ""
    @Published var permissionStatus: Bool = false
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getiCloudStatus()
        requestPermission()
//        fetchiCloudUserRecordID()
        getCurrentUserName()
    }
    
    func getiCloudStatus() {
        CloudKitUtility.getiCloudStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] success in
                self?.isSignedInToiCloud = success
            }
            .store(in: &cancellables)

        
//        CloudKitUtility.getiCloudStatus { [weak self] completion in
//            DispatchQueue.main.async {
//                switch completion {
//                case .success(let success):
//                    self?.isSignedInToiCloud = success
//                case .failure(let error):
//                    self?.error = error.localizedDescription
//                }
//            }
//        }
    }
    
//    func discoveriCloudUser(id: CKRecord.ID) {
//        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
//            DispatchQueue.main.async {
//                if let name = returnedIdentity?.nameComponents?.givenName {
//                    self?.username = name
//                }
//            }
//        }
//    }
//
//    func fetchiCloudUserRecordID() {
//        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
//            if let id = returnedID {
//                self?.discoveriCloudUser(id: id)
//            }
//        }
//    }
    
    func requestPermission() {
        
        CloudKitUtility.requestApplicationPermission()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] success in
                self?.permissionStatus = success
            }
            .store(in: &cancellables)

//        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { [weak self] returnedStatus, returnedError in
//            DispatchQueue.main.async {
//                if returnedStatus == .granted {
//                    self?.permissionStatus = true
//                }
//            }
//        }
    }
    
    func getCurrentUserName() {
        CloudKitUtility.discoverUserIdentity()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] returnedName in
                self?.username = returnedName
            }
            .store(in: &cancellables)
    }
}

struct CloudKitUserBootcamp: View {
    @StateObject private var vm = CloudKitUserBootcampVM()
    
    var body: some View {
        VStack {
            Text("IS SIGNED IN: \(vm.isSignedInToiCloud.description)")
            Text(vm.error)
            Text("PERMISSION: \(vm.permissionStatus.description)")
            Text("NAME: \(vm.username)")
        }
    }
}

struct CloudKitUserBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitUserBootcamp()
    }
}
