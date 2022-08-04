//
//  UnitTestingBootcampView.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Grant Watson on 5/23/22.
//

/*
 1. Unit Tests
 - business logic in app
 
 2. UI Tests
 - UI of app
 */

import SwiftUI

struct UnitTestingBootcampView: View {
    
    @StateObject private var vm: UnitTestingBootcampVM
    
    init(isPremium: Bool) {
        _vm = StateObject(wrappedValue: UnitTestingBootcampVM(isPremium: isPremium))
    }
    var body: some View {
        Text(vm.isPremium.description)
    }
}

struct UnitTestingBootcampView_Previews: PreviewProvider {
    static var previews: some View {
        UnitTestingBootcampView(isPremium: true)
    }
}
