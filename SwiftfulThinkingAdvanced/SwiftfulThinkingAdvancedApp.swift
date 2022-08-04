//
//  SwiftfulThinkingAdvancedApp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Grant Watson on 5/17/22.
//

import SwiftUI

@main
struct SwiftfulThinkingAdvancedApp: App {
    
    let currentUserIsSignedIn: Bool
    
    init() {
        // ARGUMENTS
        //let userIsSignedIn: Bool = CommandLine.arguments.contains("-UITest_startSignedIn") ? true: false
        let userIsSignedIn: Bool = ProcessInfo.processInfo.arguments.contains("-UITest_startSignedIn") ? true: false
        
        // ENVIRONMENT VARIABLES
        //let value = ProcessInfo.processInfo.environment["-UITest_startSignedIn2"]
        //let userIsSignedIn: Bool = value == "true" ? true : false
        
        self.currentUserIsSignedIn = userIsSignedIn
    }
    
    var body: some Scene {
        WindowGroup {
            CloudKitUserBootcamp()
            //UITestingBootcampView(currentUserIsSignedIn: currentUserIsSignedIn)
        }
    }
}
